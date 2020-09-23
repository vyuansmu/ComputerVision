%function HWK1_ImageFiltering()
    %I am not sure how to turn this into an effetective function so im just
    %turning it into a simple script
% Best practice
  clc, close all

% Read image (use imread, im2double)
  im = imread('pi-small.png');
 im = im2double(im);
%% Filter A
% Create filter specified in assignment (create array in MATLAB)
  ha = zeros(5,5);
  ha(3,3) = 1;

% Apply filter (using imfilter)
  im_fltrda = imfilter(im,ha);
%% Filter B
    hb = zeros(5,5);
    hb(3,4) = 1;
     im_fltrdb = imfilter(im,hb);
%% Filter C
    hc = zeros(5,5);
    hc(3,2) = 1;
         im_fltrdc = imfilter(im,hc);
%% Filter D
    hd = randn(5,5).*1.5; %gauss filter with sigma = 1.5
         im_fltrdd = imfilter(im,hd);
%% Filter E
    he = zeros(3,3);
    he(:,1) = 1;
    he(:,3) = -1;
     im_fltrde = imfilter(im,he);
%% Filter F
    hf = zeros(3,3)
    hf(1,1) = 1;
    hf(1,3) = 1;
    hf(3,1) = -1;
    hf(3,3) = -1;
    im_fltrdf = imfilter(im,hf);
%% Filter G
    hg1 = zeros(3,3);
    hg2 = -(1/9)*ones(3,3);
    hg1(2,2) = 3;
    hg = hg1 - hg2;
    im_fltrdg = imfilter(im,hg);


%% graphing
% Determine size of image
  sz = size(im);
  numRows = sz(1);  % number of rows in image
  numCols = sz(2);  % number of columns in image
  
  
  figure, hold on
% Display original image
  subplot(241)
  imshow( im, 'InitialMagnification','fit' )
  line(round(numCols/2)*[1,1],[1,numRows],'Color','r','LineWidth',1);
  line([1,numCols],round(numRows/2)*[1,1],'Color','b','LineWidth',1);
  title('original')

% Display filtered image
  subplot(242)
  imshow( im_fltrda, 'InitialMagnification','fit' )
  line(round(numCols/2)*[1,1],[1,numRows],'Color','r','LineWidth',1);
  line([1,numCols],round(numRows/2)*[1,1],'Color','b','LineWidth',1);
  title('filter A')
 
% Display filtered image
  subplot(243)
  imshow( im_fltrdb, 'InitialMagnification','fit' )
  line(round(numCols/2)*[1,1],[1,numRows],'Color','r','LineWidth',1);
  line([1,numCols],round(numRows/2)*[1,1],'Color','b','LineWidth',1);
  title('filter B')

% Display filtered image
  subplot(244)
  imshow( im_fltrdc, 'InitialMagnification','fit' )
  line(round(numCols/2)*[1,1],[1,numRows],'Color','r','LineWidth',1);
  line([1,numCols],round(numRows/2)*[1,1],'Color','b','LineWidth',1);
  title('filter C')
  
% Display filtered image
  subplot(245)
  imshow( im_fltrdd, 'InitialMagnification','fit' )
  line(round(numCols/2)*[1,1],[1,numRows],'Color','r','LineWidth',1);
  line([1,numCols],round(numRows/2)*[1,1],'Color','b','LineWidth',1);
  title('filter D')
  
% Display filtered image
  subplot(246)
  imshow( im_fltrde, 'InitialMagnification','fit' )
  line(round(numCols/2)*[1,1],[1,numRows],'Color','r','LineWidth',1);
  line([1,numCols],round(numRows/2)*[1,1],'Color','b','LineWidth',1);
  title('filter E')
  
% Display filtered image
  subplot(247)
  imshow( im_fltrdf, 'InitialMagnification','fit' )
  line(round(numCols/2)*[1,1],[1,numRows],'Color','r','LineWidth',1);
  line([1,numCols],round(numRows/2)*[1,1],'Color','b','LineWidth',1);
  title('filter F')
  
% Display filtered image
  subplot(248)
  imshow( im_fltrdg, 'InitialMagnification','fit' )
  line(round(numCols/2)*[1,1],[1,numRows],'Color','r','LineWidth',1);
  line([1,numCols],round(numRows/2)*[1,1],'Color','b','LineWidth',1);
  title('filter G')
%end

