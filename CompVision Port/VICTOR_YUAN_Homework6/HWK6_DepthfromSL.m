function HWK6_DepthfromSL()
clc, close all

% Parameter of Interest
% relative ratio between the frequency of the low & high frequency illumination patterns.....(0,6) and (0,105)
  G = 16.25;    

% Read images into following variables
  % pcosL, mcosL, psinL, msinL
    pcosL = double(imread('pcosL.tif'));
    mcosL = double(imread('mcosL.tif'));
    psinL = double(imread('psinL.tif'));
    msinL = double(imread('msinL.tif'));
  
  % pcosH, mcosH, psinH, msinH
    pcosH = double(imread('pcosH.tif'));
    mcosH = double(imread('mcosH.tif'));
    psinH = double(imread('psinH.tif'));
    msinH = double(imread('msinH.tif'));
    
% Identify low-res phase map
  % Identify carrier frequency if unknown

    icosL = 0.5*(pcosL - mcosL);
    isinL = 0.5*(psinL - msinL);
    %compL = (icosL) + sqrt(-1)*(isinL);
    %some_img = fftshift(abs(fft2(compL)));
    % figure(); imshow(some_img,[]); %---> found to peak at (700,404)
    eL = 0;
    nL = 4;%404-400
  % Demodulate carrier
    [X,Y]= meshgrid(0:1398,0:798);
    deModCos = cos(2*pi/799*nL*Y); %eL deliberatly zeroed out
    deModSin = sin(2*pi/799*nL*Y);
    cmplx_image = deModCos.*icosL + deModSin.*isinL +sqrt(-1)*(deModCos.*isinL - deModSin.*icosL);
    phaseMapL = pi + angle(cmplx_image);
    figure(1)
    imshow(phaseMapL,[])
    title('Low-Res phase Map')
% Identify high-res phase map
  % Identify carrier frequency if unknown
    icosH = 0.5*(pcosH - mcosH);
    isinH = 0.5*(psinH - msinH);
    compH = (icosH) + sqrt(-1)*(isinH);
    %some_img2 = fftshift(abs(fft2(compH)));
    %figure(); imshow(some_img2,[]); %double checked to verify if i can
    %reuse previous parameters
	eH = G*eL;
    nH = G*nL;
  % Demodulate carrier
    [X,Y]= meshgrid(0:1398,0:798);
    deModCos = cos(2*pi/799*nH*Y); %eH deliberatly zeroed out
    deModSin = sin(2*pi/799*nH*Y);
    cmplx_image2 = deModCos.*icosH + deModSin.*isinH +sqrt(-1)*(deModCos.*isinH - deModSin.*icosH);
    phaseMapH = pi + angle(cmplx_image2);
    figure(2)
    imshow(phaseMapH,[])
    title('High-Res phase Map')
% Phase-unwrapping  
    phaseMapUnwrapped = phaseMapH + 2*pi*round((G.*phaseMapL - phaseMapH)/(2*pi));
    figure(3)
    imshow(phaseMapUnwrapped,[])
    title('Unwrapped phase map')
    Z = 1./phaseMapUnwrapped;
% Estimate depth
  % Post-process result
  % pixels whose intensities didnt change much
  T1 = 0.025;  %% <<< YOU NEED TO PROVIDE THIS PARAMETER >>>
  bw_shadow_mask = mask_shadow_and_occlusion_pixels(pcosH,mcosH,psinH,msinH,T1);
  figure(4)
    imshow( bw_shadow_mask )
    title('shadow occlusion pixels')
  %
  T2 = 0.0009;  %% <<< YOU NEED TO PROVIDE THIS PARAMETER >>>
  bw_flying_pixel_mask = mask_flying_pixels(Z,T2);
  %
  % Combine both masks  
  bw_mask = or( bw_shadow_mask , bw_flying_pixel_mask );
  % Median filter to fill in holes
  bw_mask = medfilt2(bw_mask,[7,7],'symmetric');

  figure(101)
    imshow( bw_mask )
    title('Inavlid Pixel mask (white are invalid)');
    
  Z(bw_mask) = NaN; % Replace invalid pixels with NaN's
  figure(102)
    mesh( Z' );
    view([45,60])
  set(gcf,'Color',[0.2 0.2 0])
  set( 102,'name','Qualitative Depth Map' )
  set( 102,'numbertitle','off' )  
end


%% Helper functions needed for assignment
function bw_mask = mask_shadow_and_occlusion_pixels(pcos,mcos,psin,msin,T)
  cosimg = 0.5*(pcos-mcos);
  sinimg = 0.5*(psin-msin);
  modln_strength = sqrt( (cosimg).^2 + (sinimg).^2 );
  nrmld_modln_strength = adjustDR( modln_strength,1,0 ); % re-normalize modln_strength so it has values from 0 to 1
  bw_mask = ( nrmld_modln_strength < T );  
end

function bw_mask = mask_flying_pixels(Z,T)
  std = stdfilt(Z,ones(3));
  bw_mask = false(size(Z));
  bw_mask(std > T) = 1;  
  % Morhphological proceessing of binary mask
  bw_mask = bwmorph(bw_mask,'fill');
  bw_mask = bwmorph(bw_mask,'clean');
  bw_mask = bwmorph(bw_mask,'close');
  bw_mask = bwmorph(bw_mask,'spur');
  %
  CC = bwconncomp(bw_mask);
  numPixels = cellfun(@numel,CC.PixelIdxList);
  [srt,idx] = sort(numPixels,'descend');
  strt_mask = false(size(bw_mask));
  strt_mask(CC.PixelIdxList{idx(1)}) = true;
  strt_mask(CC.PixelIdxList{idx(2)}) = true;
  strt_mask(CC.PixelIdxList{idx(3)}) = true;
  %
  bw_mask = strt_mask;
end

function img = adjustDR( img,mx,mn )
  mx_img = max(img(:));
  mn_img = min(img(:));    
  img = (img-mn_img)/(mx_img-mn_img)*(mx-mn) + mn;
end

