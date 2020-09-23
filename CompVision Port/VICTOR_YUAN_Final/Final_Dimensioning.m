function Final_Dimensioning()
  clc, close all;
  
  FILENAME = 'FedEx_Box2_PCL_300.txt';
  
  TOF_Sensor_Specs = struct('numRows',240,'numCols',320 );
  
  % Read data from file
  [~,Intensity_Distorted,Depth_Distorted] = ...
    readPCL_data(TOF_Sensor_Specs, FILENAME);% function is given 
  
  % I_Distorted is the intensity image (with radial distortion)
  % Depth_Distorted is the depth image (with radial distortion)  
  
  % Camera intrinsic matrix
  IntrinsicMatrix = eye(3);
  IntrinsicMatrix(1,1) = 225.607;
  IntrinsicMatrix(1,3) = 158.205;       
  IntrinsicMatrix(2,2) = 224.547;
  IntrinsicMatrix(2,3) = 118.488;
  %
  % Radial distortion coefficients
  k1 = -0.202793;
  k2 = 0.176023;
  k3 = -0.0887613;
  % Tangential distortion coefficients
  p1 = 0.000450451;
  p2 = -0.000485368;
  %  
  figure
    imshow( Intensity_Distorted,[],'initialMagnification','fit' ),colorbar
  figure
    imshow( Depth_Distorted,[],'initialMagnification','fit' ),colorbar
  
%% STEP-1: Pre-processing
  % Establish cameraParams
    cameraParams = cameraParameters('IntrinsicMatrix',(IntrinsicMatrix)',...
        'RadialDistortion', [k1, k2, k3],'TangentialDistortion',[p1 p2]);
  % Remove lens distortion from Intensity image
  [J1,newOrigin1] = undistortImage(Intensity_Distorted,cameraParams);
  % Remove lens distortion from Depth map
  [J2,newOrigin2] = undistortImage(Depth_Distorted,cameraParams);
  % Define ROI
%   figure
%     imagesc(J1,[0.005 0.045])
%   figure
%     imagesc(J2,[0 5])
    
  figure
    imshow( J1,[],'initialMagnification','fit' ),
  figure
    imshow( log(J2),[],'initialMagnification','fit' ),
    
    % pulling from the graphs the region of interest is narrowed down to
    rows = 50:200; 
    cols = 100:250;
    % pancake the image 
    ROI = J2(rows,cols);
    feed2hist = reshape(ROI,1,[]);
    
%% STEP-2: Process histogram of depths
%    figure 
%    hist(feed2hist)
    [counts, centers] = hist(feed2hist);
  
  [~, index1] = max(counts);
  counts(index1) = 0; % set count to zero to find the 2nd greatest count which should be index of intrest
  [~, index2] = max(counts);
  % Identify depth of points on box
  % Identify depth of points on conveyor belt
  if centers(index1)< centers(index2) % this if statement should deteremine which is higher
      Zbox = centers(index1);
      Zbelt= centers(index2);
  else
      Zbox = centers(index2);
      Zbelt= centers(index1);
  end 
  % Zw of the box 
    Zw = abs(Zbox - Zbelt); % should never be negative anyways
%% STEP-3: Compute corners of box
    bw = edge(ROI,'Canny',0.95); 
  
    % i picked a high enough treshold such that only the edges of the box
    % shows up might need further tuning but 0.95 seems to work for now
    figure
    imshow(bw,[])
    hold on
    C = corner(bw,4); %this should find the 4 corners in bwf
    plot(C(:,1),C(:,2),'r*') % this plot shows the corners found

%% STEP-4: Compute world coordinates of box corners starting from pixel coordinates
    Xw = (Zbox*(C(:,1)+158.205)/225.607);
    Yw = (Zbox*(C(:,2)+118.488)/224.547); % these equations are calculated by hand 
    
    TR = [Xw(1) Yw(1)];
    TL = [Xw(2) Yw(2)];
    BR = [Xw(3) Yw(3)];
    BL = [Xw(4) Yw(4)];
    
    % horizontal euclidean
    ht = sqrt( (TR(1)-TL(1))^2 + (TR(2)-TL(2))^2 );
    hb = sqrt( (BR(1)-BL(1))^2 + (BR(2)-BL(2))^2 );
    avgH = (ht+hb)/2;
    
    % vertical euclidean
    vl = sqrt( (TL(1)-BL(1))^2 + (TL(2)-BL(2))^2 );
    vr = sqrt( (TR(1)-BR(1))^2 + (TR(2)-BR(2))^2 );
    avgV = (vl+vr)/2;
%% STEP-5: Report dimensions of box
    Height = Zw
    Length = avgV
    Width = avgH
end