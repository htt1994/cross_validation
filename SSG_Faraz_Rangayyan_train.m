function [Az_max opti_pars] = SSG_Faraz_Rangayyan_train(img, img_gt, mask)
% SSG_Faraz_Rangayyan_train Full search of the parameters of the Hessian-based 
%                    vessel enchancement method proposed by Oloumi et al.
%        [Az_max opti_pars] = SSG_Faraz_Rangayyan_train(img, img_gt) returns the 
%                            maximal performance reached and the parameters
%                            used to achieve that performance.
%
%        [Az_max opti_pars] = SSG_Faraz_Rangayyan_train(img, img_gt, mask) returns 
%                            the perfomance and optimal parameters using
%                            the defined mask passed as argument.
%        
%        The predefined search space is [10, 16] in steps of 1 for Tau, 
%        [2.1, 4.1] in steps of 0.4 for L, and K filters fixed in 180.
%
    
    if nargin == 3
        mask = ones(size(img));
    end
    
    Az_max = 0;
    opti_pars = zeros(1, 3);

	pars = zeros(1, 3);
	pars(3) = 180;

    % Full search of the parameters that maximize Az:
    for T = 10:1:16
		pars(1) = T;
		for L = 2.1:0.4:4.1
			pars(2) = L;
			Az = SSG_Faraz_Rangayyan_performance(img, img_gt, pars, mask);
			if Az_max < Az
				Az_max = Az;
				opti_pars = pars;
			end
		end
    end
end
