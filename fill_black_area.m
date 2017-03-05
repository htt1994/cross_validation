function img_filled = fill_black_area(img, mask)

% row_offset = [-1 -1 -1 ; 0 0 0 ; 1 1 1]; row_offset = row_offset(:);
% col_offset = [-1 0 1 ;-1 0 1 ;-1 0 1]; col_offset = col_offset(:);

row = -10:10;
col = -10:10;
[row_offset,col_offset] = ndgrid(row,col);
row_offset = row_offset(:);
col_offset = col_offset(:);

[height, width] = size(img);
row = 1:height;
col = 1:width;
[R,C] = ndgrid(row,col);


growing_mask = mask;
img_filled = img;


iter = 1;
MAX_ITER = 50;

done = false;
while (~done)
%     disp(sprintf('Iteration #%d', iter));
%     iter = iter + 1;

   if (iter > MAX_ITER)
       done = true;
       continue;
   end


   % Find the border of the current mask
   border = imdilate(growing_mask, strel('disk', 1));
   border = xor(border,growing_mask);

   % If the border is empty, end this loop
   if (isempty(find(border,1)))
       done = true;
       continue;
   end

   %
   % For every border pixel, compute the median value of its neighbors
   % that are within the current mask
   %
   border_pixels_row = R(border);
   border_pixels_col = C(border);

   for k = 1:length(border_pixels_row)
       % Get current border pixel coordinates
       this_row = border_pixels_row(k);
       this_col = border_pixels_col(k);

       % Make vectors of row and col coordinates for the neighbors of the
       % current border pixel
       local_roi_row = this_row + row_offset;
       local_roi_col = this_col + col_offset;

       % Ensure that all neighbors of the current border pixel are within
       % the limits of the image
       local_roi_valid_pixels = ...
           (local_roi_row >= 1) & (local_roi_row <= height) & ...
           (local_roi_col >= 1) & (local_roi_col <= width);
       local_roi_row = local_roi_row(local_roi_valid_pixels);
       local_roi_col = local_roi_col(local_roi_valid_pixels);

       % Get the values (from img_filled) of the neighboring pixels that
       % are within the current mask
       local_roi_index = sub2ind([height width], local_roi_row, local_roi_col);
       local_roi_mask_pixels = growing_mask(local_roi_index);
       local_roi_index = local_roi_index(local_roi_mask_pixels);

       % Assign the median value of the neighboring pixels to the current
       % border pixel, in the image img_filled
       local_roi_values = img_filled(local_roi_index);
       img_filled(this_row, this_col) = mean(local_roi_values);
   end

   % Grow the current mask
   growing_mask = growing_mask | border;

end
