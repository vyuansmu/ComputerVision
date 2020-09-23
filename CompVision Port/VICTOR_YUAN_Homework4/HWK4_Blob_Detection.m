function HWK4_Blob_Detection()
  clc,close all
  
  % Load images:
  im = imread('Dalmatian.jpg');
  im = rgb2gray(im2double(im));
  im = ( im-min(im(:)) )/( max(im(:))-min(im(:)) );
  figure
    imshow(im)
    
  % Select parameters for blob detection:
  sigma_init = 	1;
  k = 2^(1/4);
  N = 10; %10 to 15
  % Storage for LoG scale-space
  [nR, nC] = size(im);
  nL = N;
  scaleSpace = zeros(nR,nC,nL);
for n = 1:N
  % Initialize LoG filter(s)
  sigma_n = (sigma_init * k.^n)';
  filt_size = 2*ceil(3*sigma_n)+1;
  LoG = sigma_n.^2 .* fspecial('log', filt_size, sigma_n);
  % applying filter
  im_filtered = imfilter(im,LoG);
  % Storing
  scaleSpace(:,:,n) = im_filtered;
end
 
  % NMS Stage 1
  maxScaleSpace = zeros(nR,nC,nL); %Storage
  for i = 1:N
        A = scaleSpace(:,:,i).^2; %Each element was sqaured bc some are neg values
        maxScaleSpace(:,:,i) = ordfilt2(A,9,ones(3,3));
  end
  
  % NMS Stage 2
  for i = 1:N
  maxScaleSpace(:,:,i) = max(maxScaleSpace(:,:,max(i-1,1) :min(i+1, nL)),[],3);
  end
  
  %Binary Mask
  maxScaleSpace = maxScaleSpace .*(maxScaleSpace == A); %changed to A since maxScale was calcu
  

  
  % Thresholding - Unsure of what values to pick so i'll just start off
  % with a scalar of the Max value in maxScaleSpace
  


  % Row Col Dim of non zeros(shifted down to not repeat calculations after thresholding)
  lind = find(maxScaleSpace > 0.35*max(maxScaleSpace(:)));
  [r, c, d] = ind2sub(size(maxScaleSpace), lind);
  radius = d * sqrt(2);
  %drawBlobs(im,r,d,radius) %this function you are telling us to use does
  %not exist atleast not on my version of matlab R2017a, I could not find
  %any documentation for it either online, Instead Im going to use
  %viscircles from the last hw
    drawBlobs(im,r,c,radius,'blue')
  
end
%max(max(maxScaleSpace(:,:,:)))