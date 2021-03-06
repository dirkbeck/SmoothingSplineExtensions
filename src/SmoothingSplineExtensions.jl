module SmoothingSplineExtensions

export getloocv, getoptimallambda, plotlambdavscv, geterrorbars, plotfitwitherrorbars, getsmoothermatrix, getdegreesoffreedom, getboostingsmoothingspline, getboostingsmoothingsplinepred, plotboostingsmoothingsplineMSEs

using SmoothingSplines, Gadfly, LinearAlgebra

function getloocv(X,Y,lambda)
    # gets leave-one-out cross-validation for a smoothingspline fit on given data
    err = 0.0;
    for i = 1:length(X);
      err += (Y[i] - predict(fit(SmoothingSpline, deleteat!(copy(X), i), deleteat!(copy(Y), i), lambda), X[i]))^2;
    end
    err = err/length(X);
end

function getoptimallambda(X,Y,lambda_precision,max_iter)
    # finds lambda such that loocv has a local minimum
    lambda = 0.0;
    cv_previous_lambda = Inf;
    cv_current_lambda = getloocv(X,Y,lambda);
    while cv_current_lambda < cv_previous_lambda && lambda < max_iter*lambda_precision
        lambda += lambda_precision;
        cv_previous_lambda = cv_current_lambda;
        cv_current_lambda = getloocv(X,Y,lambda);
    end
    return lambda - lambda_precision
end

function plotlambdavscv(X,Y,lambda_precision,iter)
    # plots lambda vs cv over the range [0 iter]
    lambdas = 0.0:lambda_precision:(iter-1)*lambda_precision;
    cvs = zeros(iter);
    for i=1:iter
        cvs[i] = getloocv(X,Y,lambdas[i]);
    end
    plot(layer(x=lambdas, y=cvs, Geom.line),
        layer(x=[lambdas[findfirst(isequal(minimum(cvs)), cvs)]], y=[minimum(cvs)], Geom.point),
        Guide.xlabel("λ"),
        Guide.ylabel("LOOCV"),
        Guide.Title("Optimal λ"))
end

function geterrorbars(X,Y,lambda,confidence_interval)
    # returns upper and lower confidence interval using a leave-one-out bootstrap method.
    # 95% confidence_interval would return the 2.5th and 97.5th percentile of predictions at each X value.
    m = length(X);
    loo_estimates = zeros(m,m);
    lower_confidence_interval = zeros(m);
    upper_confidence_interval = zeros(m);
    for i=1:m
        X_loo_i_fit = fit(SmoothingSpline, deleteat!(copy(X), i), deleteat!(copy(Y), i), lambda);
        loo_estimates[i,:] = predict(X_loo_i_fit, X);
    end
    for i=1:m
        lower_confidence_interval[i] = sort!(copy(loo_estimates[:,i]))[Int(floor((m-1)*(1-confidence_interval)/2+1))];
        upper_confidence_interval[i] = sort!(copy(loo_estimates[:,i]))[Int(ceil((m-1)*(1 - (1 - confidence_interval)/2)+1))];
    end
    return lower_confidence_interval, upper_confidence_interval
end

function plotfitwitherrorbars(X,Y,lambda,confidence_interval)
    # similar to geterrorbars, but returns a plot
    lower_confidence_interval, upper_confidence_interval = geterrorbars(X,Y,lambda,confidence_interval)
    plot(layer(x=X, y=Y, Geom.point),
        layer(x=X, y=predict(fit(SmoothingSpline,X,Y,lambda)), ymin = lower_confidence_interval, ymax = upper_confidence_interval, Geom.line, Geom.ribbon),
        Guide.xlabel("x"),
        Guide.ylabel("y"),
        Guide.Title("Smoothing spline with error bars"))
end

function getsmoothermatrix(X, lambda)
    # gets the matrix that smoothens X in smoothing splines
    n = length(X);
    w = zeros(n,n);
    for i=1:n
        y = vec(zeros(n, 1));  # Equivalent to rep(0, length.out=n) but faster
        y[i] = 1;
        spl = fit(SmoothingSpline, X, y, lambda);
        w[:,i] = predict(spl);
    end
    return(w)
end

function getdegreesoffreedom(X, lambda)
    # gets approximate degrees of freedom for some lambda, calculated as the trace of the smoother matrix
    return tr(getsmoothermatrix(X, lambda))
end

function getboostingsmoothingspline(X,Y,lambda,iter,v)
    # gets Y predictions by boosting smoothing splines given number of iterations (iter) with a penalty scalar (0 ≤ v ≤ 1)
    Ypred = copy(Y);
    for i=0:iter
        Ypred = predict(fit(SmoothingSpline, X, Y + v * (Y - Ypred), lambda));
    end
    return Ypred
end

function getboostingsmoothingsplinepred(X, Y, lambda, iter, v, x)
    # makes a prediction from a boosted smoothing spine using a cubic spline fit through boosted predictions
    # X, Y, lambda, iter, v apply to the fit through X and Y, similar to the inputs in getboostingsmoothingspline
    # x is the point at which the prediction is made
    return predict(fit(SmoothingSpline, X, getboostingsmoothingspline(X,Y,lambda,iter,v), 0.0), x)
end

function plotboostingsmoothingsplineMSEs(X,Y,lambda,iter,v)
    # similar to getboostingsmoothingspline, but plots the MSE at each iteration
    Ypred = copy(Y);
    mses = zeros(iter+1)
    for i=0:iter
        Ypred = predict(fit(SmoothingSpline, X, Y + v * (Y - Ypred), lambda));
        mse = 0.0;
        for j=1:length(Y)
            mse += (Ypred[j] - Y[j])^2
        end
        mses[i+1] = mse/length(Y);
    end
    plot(layer(x=0:iter, y=mses, Geom.line),
    layer(x=[findfirst(isequal(minimum(mses)), mses)-1], y=[minimum(mses)], Geom.point),
    Guide.xlabel("boosting iteration"),
    Guide.ylabel("MSE"),
    Guide.Title("Optimal # of Boosting Iterations"))
end

end
