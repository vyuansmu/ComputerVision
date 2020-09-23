clc, close all
  clear all
  %Intial values
  sigmastart = 1;
  sigmaend = 8;
  %imagefile = 'Syros_Ermoupolis.jpg';
  imagefile = 'city.jpg'; %Image sourced from https://fineartamerica.com/featured/china-beijing-cityscape-elevated-view-jeremy-woodhouse.html
  im_rgb = im2double(imread(imagefile));
  figure
  imshow(im_rgb)
  row = size(im_rgb,1); %holds the total # of rows in a image
  %Since the assignment sheet asks specifically for user row selection i'll
  %use rowtop rowbot otherwise I would scale the top and bot divisions with
  %a scale of row  
  rowtop = 300;
  rowbot= 500; %picked these values from the graph on the problem sheet
  %error check to see if DOF rows are within the bounds of the image
  %if row < rowend
    %error
  %end
  %if 1 > rowtop
      %error
  %end
  %% Nonlinear 
  [sigma1,sigma2] = sigmagen(sigmastart,sigmaend,rowtop,rowbot,row);
  %% Red
  im_red = im_rgb(:,:,1);
    %Top portion
    rowtc = rowtop; %row top counter 
    %sigmadelta = (sigmaend-sigmastart)/(rowtc-1);%linear change of the sigma value
    %sigma1 = sigmastart:sigmadelta:sigmaend;
    filt_size = 2*ceil(3*sigma1)+1; %code fragment take from midterm doc
    %implementing gaussian filter (simple method)
    imblur = zeros(size(im_red));
    for i = 1:rowtc
        offset = rowtop - i + 1; % needs a offset so that the correct row is replaced
        H = fspecial('gaussian',filt_size(i), sigma1(i));
        imfil = imfilter(im_red,H);
        imblur(offset,:) = imfil(offset,:);
    end
    %Bot portion
    rowbc = row - rowbot;
    %sigmadelta = (sigmaend-sigmastart)/(rowbc-1);
    %sigma2 = sigmastart:sigmadelta:sigmaend;
    for i = 1:rowbc
        offset = rowbot + i; % needs a offset so that the correct row is replaced
        H = fspecial('gaussian',filt_size(i), sigma2(i));
        imfil = imfilter(im_red,H);
        imblur(offset,:) = imfil(offset,:);
    end
    %focused portion
    imblur(rowtop+1:rowbot,:) = im_red(rowtop+1:rowbot,:);
    imedit = im_rgb;
    imedit(:,:,1) = imblur;
  %% Green
  im_green = im_rgb(:,:,2);
    %Top portion
    rowtc = rowtop; %row top counter 
    %sigmadelta = (sigmaend-sigmastart)/(rowtc-1);%linear change of the sigma value
    %sigma1 = sigmastart:sigmadelta:sigmaend;
    filt_size = 2*ceil(3*sigma1)+1; %code fragment take from midterm doc
    %implementing gaussian filter (simple method)
    imblur = zeros(size(im_green));
    for i = 1:rowtc
        offset = rowtop - i + 1; % needs a offset so that the correct row is replaced
        H = fspecial('gaussian',filt_size(i), sigma1(i));
        imfil = imfilter(im_green,H);
        imblur(offset,:) = imfil(offset,:);
    end
    %Bot portion
    rowbc = row - rowbot;
    %sigmadelta = (sigmaend-sigmastart)/(rowbc-1);
    %sigma2 = sigmastart:sigmadelta:sigmaend;
    for i = 1:rowbc
        offset = rowbot + i; % needs a offset so that the correct row is replaced
        H = fspecial('gaussian',filt_size(i), sigma2(i));
        imfil = imfilter(im_green,H);
        imblur(offset,:) = imfil(offset,:);
    end
    %focused portion
    imblur(rowtop+1:rowbot,:) = im_green(rowtop+1:rowbot,:);

    imedit(:,:,2) = imblur;
%% blue
    im_blue = im_rgb(:,:,3);
    %Top portion
    rowtc = rowtop; %row top counter 
    %sigmadelta = (sigmaend-sigmastart)/(rowtc-1);%linear change of the sigma value
    
    %sigma1 = sigmastart:sigmadelta:sigmaend;
    filt_size = 2*ceil(3*sigma1)+1; %code fragment take from midterm doc
    %implementing gaussian filter (simple method)
    imblur = zeros(size(im_blue));
    for i = 1:rowtc
        offset = rowtop - i + 1; % needs a offset so that the correct row is replaced
        H = fspecial('gaussian',filt_size(i), sigma1(i));
        imfil = imfilter(im_blue,H);
        imblur(offset,:) = imfil(offset,:);
    end
    %Bot portion
    rowbc = row - rowbot;
    %sigmadelta = (sigmaend-sigmastart)/(rowbc-1);
    %sigma2 = sigmastart:sigmadelta:sigmaend;
    for i = 1:rowbc
        offset = rowbot + i; % needs a offset so that the correct row is replaced
        H = fspecial('gaussian',filt_size(i), sigma2(i));
        imfil = imfilter(im_blue,H);
        imblur(offset,:) = imfil(offset,:);
    end
    %focused portion
    imblur(rowtop+1:rowbot,:) = im_blue(rowtop+1:rowbot,:);

    imedit(:,:,3) = imblur;
%% combine all
    imhsv = rgb2hsv(imedit);
    imsat = imhsv(:,:,2)*3; %increases the saturation scaling by greater then 1
    imhsv(:,:,2) = imsat;
    imfinale = hsv2rgb(imhsv);
    figure
    imshow(imfinale)
end
function [sigma_top, sigma_bot] = sigmagen(sigma_start,sigma_end,row_start,row_end,imagerow)
%Generates a nonlinear set of sigma values that keeps the start and end
%sigma values
 rowtc = row_start;
 rowbc = imagerow - row_end; 
 
 kt = rowtc:-1:1;
 kb = rowbc:-1:1;
 
 %chebyshev distribution of sigma adapated from chebyshev points equation
 %page from wikipedia 
 sigma_top = 0.5*(sigma_end - sigma_start)*cos(((2*kt-1)/(2*rowtc))*pi) + 0.5*(sigma_start + sigma_end);
 sigma_bot = 0.5*(sigma_end - sigma_start)*cos(((2*kb-1)/(2*rowbc))*pi) + 0.5*(sigma_start + sigma_end);
end