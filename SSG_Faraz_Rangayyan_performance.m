function Az = SSG_Faraz_Rangayyan_performance( img, img_gt, parameters, mask)
% SSG_FARAZ_RANGAYYAN_PERFORMANCE Detection performance of the Hessiang-based       
%                    vessel enhancement method proposed by Oloumi et al.:
%        Az = SSG_Faraz_Rangayyan_performance(img, img_gt, parameters) returns the 
%                 performance of the top-hat filtering on 'img' compared 
%                 with its respective ground-truth 'img_gt'.
%
%        Az = SSG_Faraz_Rangayyan_performance(img, img_gt, parameters, mask) 
%                 returns the performance using a mask for the FOV of the
%                 image.
%
%        The performance is measured as the area under the ROC curve.


    if nargin == 3
        % If the mask was not passed as argument, the total size
        % is used as FOV:
        mask = ones(size(img));
    end
    
    size_img = size(img);
    n_imgs = size_img(2) / size_img(1);
    if (n_imgs > 1)
        Ie = zeros(size_img(1), n_imgs * size_img(1));
        resp_idx = 1:size_img(1);
        for i = 1:n_imgs
			display([i, parameters])
            Ie(:, resp_idx) = gabor(:, img(resp_idx), parameters(1), parameters(2), parameters(3), mask);
            resp_idx = resp_idx + size_img(1);
        end
    else	
        Ie  = gabor(img, parameters(1), parameters(2), parameters(3), mask); 
    end

    % Performance measurement:
    Az = run_ROC(mask, Ie, img_gt);
end
