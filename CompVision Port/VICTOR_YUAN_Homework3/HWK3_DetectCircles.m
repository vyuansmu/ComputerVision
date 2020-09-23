function HWK3_DetectCircles()
  clc, close all
  clear all

  numCircles = 2;  % Number of circles we want to detect
  radius = 35;  %180 for chips  % Radius of circles you are trying to detect 

  %% STEP 1. Select image
  txt = 'FaceCloseUp.jpg';
  im_rgb = im2double(imread(txt));
  if size(im_rgb,3) > 1 % If color convert to grayscale
    im_gray = im2double(rgb2gray(im_rgb));
  else
    im_gray = im_rgb;
  end
  % Display original image
  figure(1)
   imshow(im_rgb);
    title('Original')
  %% STEP 2. Threshold gradient or use Canny edge detector
  im_binary = edge(im_gray,'Canny',0.3,5);% 3 for coins .3/5 for chips
  % Display edge image
  figure(2)
     imshow(im_binary,[]);
    title('Output of Canny edge Detector')
  %% STEP 3. Build Hough Accumulator
  % WARNING: You need to complete this code
  [HS] = houghTransform_for_Circles(im_binary, radius); 
  %a and b deleted since its implemented in step 4
   %% STEP 4. Detect local maxima in Hough Space
  % Use built-in function provided by MATLAB
  % does non-maximum suppression for you
  % Pick different thresholds...What do you see?
  P  = houghpeaks(HS,numCircles,'Threshold',0.1*max(max(HS)));  
  centers = [ P(:,2) , P(:,1) ]; % y,x coordinates of circle centers
  % Display hough space image & overlay peaks
  figure(3)
  imshow(HS,[])
  hold on
  plot(centers(:,1)-1, centers(:,2)-1,'rx', 'MarkerSize', 10, 'LineWidth', 2)
  title('HoughSpace With Peaks') 
  %% STEP 5. Draw circles associated with peaks in Hough Space
  r = repelem(radius,size(centers,1))';
  figure(4)
  imshow(im_rgb)
  viscircles(centers,r,'color','b')
  title('Original With Overlays')
  
  %% STEP 6. Find red circle (poker chips only)
  if strcmp(txt,'PokerChips.png') %otherwise ignores this step
        red = ...
        [im_rgb(centers(1,2),centers(1,1),1) ...
        im_rgb(centers(2,2),centers(2,1),1) ...
        im_rgb(centers(3,2),centers(3,1),1) ...
        im_rgb(centers(4,2),centers(4,1),1) ];
        [~,loc] = max(red);
        figure(5)
        imshow(im_rgb)
        viscircles(centers(loc,:),radius,'color','g')
        title('Red Only')
  end

  
end