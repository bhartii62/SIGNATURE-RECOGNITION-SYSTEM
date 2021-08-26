function [features1,valid_points1] = findfeatures(I2)


% I2 = rgb2gray(I2);

% Find the corners.
points1 = detectSURFFeatures(I2);

% Extract the neighborhood features.
[features1,valid_points1] = extractFeatures(I2,points1);


end

