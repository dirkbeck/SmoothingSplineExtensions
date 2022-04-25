# SmoothingSplineExtensions

[![Build Status](https://github.com/dirkbeck/SmoothingSplineExtensions.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/dirkbeck/SmoothingSplineExtensions.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/dirkbeck/SmoothingSplineExtensions.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/dirkbeck/SmoothingSplineExtensions.jl)

A Julia package that adds to SmoothingSplines [1], which performs nonparametric regression with Cubic Smoothing Splines. The SmoothingSplineExtensions package resolves two of the "TO DOs" listed in the SmoothingSplines package: 1) conversion between regularization parameter λ and degrees of freedom, and 2) automatic selection of λ. It also includes methods for calculating error bars through a bootstrap technique [2] and fitting smoothing splines with boosting [3].


### TODO

* make code more efficient
* add alternate methods for determining CV, λ, error bars etc.
* more test scripts, including for functions that return plots


**References**

[1] https://github.com/nignatiadis/SmoothingSplines.jl/blob/master/README.md (2022).

[2] Wang, Y., &amp; Wahba, G. (1995). Bootstrap Confidence Intervals for Smoothing Splines and their Comparison to Bayesian 'Confidence Intervals'. Journal of Statistical Computation and Simulation, 51(2-4), 263–279.

[3] Peter Bühlmann & Bin Yu (2003). Boosting With the L2 Loss, Journal of the American Statistical Association, 98:462, 324-339.
