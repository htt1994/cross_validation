function mask = compute_FOV_mask(img)
% The threshold level was empirically determined (trial-and-error)

threshold_level = 0.1;
mask = im2bw(img, threshold_level);
[a b] = size(img);
%conn = ( 0.6 * (a*b));
%mask = bwareaopen(mask, conn);
mask = bwareaopen(mask, 1000);
mask = imerode(mask, strel('disk', 5));
