function Az = run_ROC(mask,gaborMag,groundTruth)

% Required for computing the ROC curve
total_ground_truth = [];
total_real_gabor = [];

img_ground_truth_valid_pixels = groundTruth(mask(:) == 1);
img_gabor_real_valid_pixels = gaborMag(mask(:) == 1);

img_ground_truth_valid_pixels = img_ground_truth_valid_pixels(:);
img_gabor_real_valid_pixels = img_gabor_real_valid_pixels(:);

total_ground_truth = [total_ground_truth ; img_ground_truth_valid_pixels];
total_real_gabor = [total_real_gabor ; img_gabor_real_valid_pixels];

Az = ROC_analysis(total_real_gabor, total_ground_truth);

%figure;
%plot(false_pos_fraction, true_pos_fraction);
%xlabel('FPF');
%ylabel('TPF');
%title(sprintf('A_z = %.3f',Az));
