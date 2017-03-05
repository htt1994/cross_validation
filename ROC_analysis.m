function Az = ROC_analysis(discriminating_values, true_class)

N = length(true_class);
total_pos = sum(true_class);
total_neg = N - total_pos;

[~, sorting_permutation]  = sort(discriminating_values(:)); 
true_class_sorted = true_class(sorting_permutation);

false_neg = cumsum(true_class_sorted == 1);
true_pos_fraction = (total_pos - false_neg)/total_pos; 
% clear false_neg;

true_neg = cumsum(true_class_sorted == 0);
false_pos_fraction = (total_neg - true_neg)/total_neg; 
% clear true_neg;

Az = -sum(0.5*(true_pos_fraction(1:(N-1)) + true_pos_fraction(2:N)) .* diff(false_pos_fraction));

end