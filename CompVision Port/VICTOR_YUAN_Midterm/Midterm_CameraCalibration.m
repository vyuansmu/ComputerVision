function Midterm_CameraCalibration()
    clc, close all
    clear all
    load('cameraParams.mat')
   %measure height of first coin and stick figure in the 8th picture
   im = imread('calib0008.jpg');
   
   [J, newOrigin] = undistortImage(im,cameraParams);
   figure
   imshow(J,[])
   
   cointop = [1540 201]; %x y
   coinbot = [1557 282];
   sticktop = [216 681];
   stickbot = [341 973];
   
   K = cameraParams.IntrinsicMatrix;
   R = cameraParams.RotationMatrices(:,:,8);
   T = cameraParams.TranslationVectors(8,:);
   
   wp1 = pointsToWorld(cameraParams,R,T,cointop);
   wp2 = pointsToWorld(cameraParams,R,T,coinbot);
   wp3 = pointsToWorld(cameraParams,R,T,sticktop);
   wp4 = pointsToWorld(cameraParams,R,T,stickbot);
   
   coinHeight =  sqrt(sum((wp2 - wp1).^2))
   stickHegith = sqrt(sum((wp3 - wp4).^2))

  %% Step 3
  
  %Code fragment from Assignment Sheet
  
  ptCloud = pcread('teapot.ply');
  XYZ = ptCloud.Location;
  XYZ = XYZ * 20;
  XYZ(:,1) = XYZ(:,1) - min(XYZ(:,1)) + 20; %x
  XYZ(:,2) = XYZ(:,2) - min(XYZ(:,2)) + 20; %y
  XYZ(:,3) = XYZ(:,3) - min(XYZ(:,3)); %z
  
   %extract the R and T matrices and vectors for image 1 and 2 
   R1 = cameraParams.RotationMatrices(:,:,1);
   T1 = cameraParams.TranslationVectors(1,:);
   
   R2 = cameraParams.RotationMatrices(:,:,2);
   T2 = cameraParams.TranslationVectors(2,:); 
   
  ip1 = worldToImage(cameraParams,R1,T1,XYZ);
  ip2 = worldToImage(cameraParams,R2,T2,XYZ);
  %% Pixels are ready prep the images
   im1 = imread('calib0001.jpg');
   [J1, newOrigin1] = undistortImage(im1,cameraParams);
   im2 = imread('calib0002.jpg');
   [J2, newOrigin2] = undistortImage(im2,cameraParams);
  figure(2)
  imshow(J1)
  hold on
  plot(ip1(:,1),ip1(:,2))
  figure(3)
  imshow(J2)
  hold on
  plot(ip2(:,1),ip2(:,2))
  
  
end
