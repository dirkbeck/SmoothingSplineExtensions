using SplineSmoothingExtensions
using Test

# cars dataset
# using RDatasets
# cars = dataset("datasets","cars")
# X = map(Float64,convert(Array,cars[:Speed]))
X = [4.0,4.0,7.0,7.0,8.0,9.0,10.0,10.0,10.0,11.0,11.0,12.0,12.0,12.0,
  12.0,13.0,13.0,13.0,13.0,14.0,14.0,14.0,14.0,15.0,15.0,15.0,16.0,
  16.0,17.0,17.0,17.0,18.0,18.0,18.0,18.0,19.0,19.0,19.0,20.0,20.0,
  20.0,20.0,20.0,22.0,23.0,24.0,24.0,24.0,24.0,25.0]
# Y = map(Float64,convert(Array,cars[:Dist]))
Y = [2.0,10.0,4.0,22.0,16.0,10.0,18.0,26.0,34.0,17.0,28.0,14.0,20.0,24.0,
  28.0,26.0,34.0,34.0,46.0,26.0,36.0,60.0,80.0,20.0,26.0,54.0,32.0,40.0,
  32.0,40.0,50.0,42.0,56.0,76.0,84.0,36.0,46.0,68.0,32.0,48.0,52.0,56.0,
  64.0,66.0,54.0,70.0,92.0,93.0,120.0,85.0]

lambda = 25.0;
max_iter = 100;
lambda_precision = 1.0;
confidence_interval = .95;

@test SplineSmoothingExtensions.getloocv ≈ 245.45616042973157 rtol=1e-4
@test SplineSmoothingExtensions.getoptimallambda ≈ 99.0 rtol=.9
@test SplineSmoothingExtensions.getdegreesoffreedom(X, lambda) ≈ 5.1089512303522495 rtol=1e-4