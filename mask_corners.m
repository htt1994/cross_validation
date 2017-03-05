%Throught connected components eliminate the black area that are not
%connected to the four corners in the mask.

function mask_wcorners = mask_corners(mask)
	[sx,sy] = size(mask);
	mask = 1 - mask;% CC are detected in white pixels
	CC = bwconncomp(mask);%calculate Connected components methods
	numPixels = cellfun(@numel,CC.PixelIdxList);%obtain list of connected
	[~,nofcc] = size(numPixels);
	for i=1:nofcc
	corner = false;
		[num,~] = size(CC.PixelIdxList{i});
		for j=1:num
			if(CC.PixelIdxList{i}(j) == 1)
				corner = true;
			end
			if(CC.PixelIdxList{i}(j) == sx)
				corner = true;
			end
			if(CC.PixelIdxList{i}(j) == 1+(sx*(sy-1)))
				corner = true;
			end
			if(CC.PixelIdxList{i}(j) == sx*sy)
				corner = true;
			end
		end
		if(corner == false)
			mask(CC.PixelIdxList{i}) = 0;		
		end		
	end
mask_wcorners = logical(1 - mask);
end
