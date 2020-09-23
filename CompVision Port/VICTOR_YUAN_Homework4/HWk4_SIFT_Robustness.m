function HWK4_SIFT_Robustness()
  clc, clear all, close all
  %
  % Load VLFEAT
  % vl_setup
  % Load image
    im = imread('Oxford_VGG_Graffiti_img1.ppm');
    img = single(rgb2gray(im));
  % Extract SIFT keypoints & descriptors for image-1
    [F,D] = vl_sift(img);
  % Visualize keypoints
  imagesc(im); colormap gray; hold on;
   vl_plotframe(F(:,200:800)) 
  % Visualize desriptors
    vl_plotsiftdescriptor(...
        D(:,200:800),F(:,200:800))
  % Check Robustness to brightness change
    delta = -100:20:100;
    repe = zeros(11,1); %storage
    for i = 1:11
    im_mod = min(max(img+delta(i),0),255);
    [F_mod, D_mod] = vl_sift(im_mod,'FRAMES',F);
    Matches = vl_ubcmatch(D, D_mod);
    repe(i,1) = length(Matches)/length(F);
    end
    figure
    plot(delta,repe)
    title('Repeatability brightness change')
  % Check Robustness to contrast change
    y = 0.5:0.25:2;
    repe = zeros(7,1);
    for i = 1:7
    im_mod2 = (img./255).^y(i) * 255;
    [F_mod2, D_mod2] = vl_sift(im_mod2,'FRAMES',F);
    Matches = vl_ubcmatch(D, D_mod2);
    repe(i,1) = length(Matches)/length(F);
    end
    figure
    plot(y,repe)
    title('Repeatability contrast change')
  % Check Robustness to blur
    sigma = [1 2 4 8 10]; 
    repe = zeros(5,1);
    for i = 1:5
    hsize = 10*sigma(i)+1;
    h = fspecial('gaussian',hsize, sigma(i));
    imdouble = im2double(img);
    im_mod3 =  imfilter(imdouble,h);
    im_mod3 = single(im_mod3);
    
    
    [F_mod3, D_mod3] = vl_sift(im_mod3,'FRAMES',F);
    Matches = vl_ubcmatch(D, D_mod3);
    repe(i,1) = length(Matches)/length(F);
    end
    figure
    plot(sigma,repe)
    title('Repeatability Blurring')
end