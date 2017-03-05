clear all
close all
clc
%%% Cross Validation for Training stage

% Set the path to the database of images:
DB_dir = '/media/sf_Dropbox/DOGMA12/Survey_crossvalidation/Angios_134';
%DB_dir = '/home/fercer/Dropbox/DOGMA12/Survey_crossvalidation/Angios_134';


% Set a new seed for the random number generation:
rng(6549832);

global_testing_size = 74;
global_training_size = 60;


% Read all the images:
img_or_cat = zeros(300, 300 * 134);
img_gt_cat = zeros(300, 300 * 134);
img_mk_cat = zeros(300, 300 * 134);

% Concatenate the set of images:
cat_idx = 1:300;

for i = 1:134
    i
    
    % Read original image:
    filename = sprintf('%s/%i.png', DB_dir, i);
    img_temp = imread(filename);
    img_temp = double(img_temp) / 255.0;

    % Compute the FOV mask:
    mask_temp = compute_FOV_mask(img_temp);
    mask_temp = mask_corners(mask_temp);
    img_temp = fill_black_area(img_temp, mask_temp);

    % Read ground-truth:
    filename = sprintf('%s/%i_gt.png', DB_dir, i);
    img_gt_temp = imread(filename);
    img_gt_temp = double(img_gt_temp) / 255.0;

    img_or_cat(:, cat_idx) = img_temp;
    img_gt_cat(:, cat_idx) = img_gt_temp;
    img_mk_cat(:, cat_idx) = mask_temp;

    cat_idx = cat_idx + 300;
end


% Indexes for the train set:
train_idx = 1:global_training_size;

% Indexes for the test set:
test_idx = (global_training_size + 1):134;

%--------------------------------------------------------------------------
k_folds = 10;

validation_size = global_training_size / k_folds;
training_size = global_training_size - validation_size;

validation_set  = 1:(300 * validation_size);

Az_max_cross = 0.0;
opti_pars_cross = 0;

% Log of the cross validation:
file_ID = fopen('SSG_Faraz_Rangayyan_crossvalidation.log', 'w');
fprintf(file_ID, 'Az_validation\tAz_training\tT\tL\tK\telsapsed_time\n');

for k = 1:k_folds
    tic
    training_set = setdiff(1:(global_training_size * 300), validation_set);
    
    %======================================================================
    %=================%
    % Training step   %
    %=================%
    
    img_or_cat_trn = img_or_cat(:, training_set);
    img_mk_cat_trn = img_mk_cat(:, training_set);
    img_gt_cat_trn = img_gt_cat(:, training_set);
    [Az_training opti_pars] = SSG_Faraz_Rangayyan_train(img_or_cat_trn, img_gt_cat_trn, img_mk_cat_trn);
    
    
    
    %=================%
    % Validation step %
    %=================%
    img_or_cat_val = img_or_cat(:, validation_set);
    img_mk_cat_val = img_mk_cat(:, validation_set);
    img_gt_cat_val = img_gt_cat(:, validation_set);
    
    % Validate the performnace of the filter with the selected
    % parameters in the validation set:
    Az_validation = SSG_Faraz_Rangayyan_performance(img_or_cat_val, img_gt_cat_val, opti_pars, img_mk_cat_val);
    
    k    
    Az_validation
    Az_training
    opti_pars
    
    elapsed_time = toc;
    fprintf(file_ID, '%f\t%f\t%f\t%f\t%f\t%f\n', Az_validation, Az_training, opti_pars(1), opti_pars(2), opti_pars(3), elapsed_time);

    % Update the best parameters found by the cross-validation
    if (Az_max_cross < Az_validation)
        Az_max_cross = Az_validation;
        opti_pars_cross = opti_pars;
    end
    
    %======================================================================
    
    % Move the indexes for the next fold:
    validation_set = validation_set + 300*validation_size;
end


%=================%
% Testing step    %
%=================%


tic
%%% Test the best parameters found by the cross-validation:
img_or_cat_tst = img_or_cat(:, (global_training_size * 300 + 1) : ((global_training_size + global_testing_size) * 300));
img_mk_cat_tst = img_mk_cat(:, (global_training_size * 300 + 1) : ((global_training_size + global_testing_size) * 300));
img_gt_cat_tst = img_gt_cat(:, (global_training_size * 300 + 1) : ((global_training_size + global_testing_size) * 300));
Az_testing = SSG_Faraz_Rangayyan_performance(img_or_cat_tst, img_gt_cat_tst, opti_pars_cross, img_mk_cat_tst)
elapsed_time = toc;
fprintf(file_ID, '%f\t-\t%f\t%f\t%f\t%f\n', Az_testing, opti_pars_cross(1), opti_pars_cross(2), opti_pars_cross(3), elapsed_time);
fclose(file_ID);
