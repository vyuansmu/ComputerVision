function HWK5_EpipolarGeometry()
  clc, clear all, close all
  %
  % Load VLFEAT
  % vlfeat -0.9.16/toolbox/vl_setup.m run this file 
  % Load images
  im1 = imread('temple_im1.png');
  im2 = imread('temple_im2.png');
  img1 = single(rgb2gray(im1));
  img2 = single(rgb2gray(im2));
  % Extract SIFT keypoints & descriptors for images 1 & 2
  [F1,Da] = vl_sift(img1);
  [F2,Db] = vl_sift(img2);
  % Identify putative correspondences
  match_ab= vl_ubcmatch(Da, Db, 3); % increased threshold to 2.1 which is '2 or more'
  for i = 1:length(match_ab)
    matchedPointsAB_A(i,:) = F1(1:2,match_ab(1,i));
    matchedPointsAB_B(i,:) = F2(1:2,match_ab(2,i));
  end
  figure(1)
  showMatchedFeatures(img1,img2,matchedPointsAB_A,matchedPointsAB_B);
  % Estimate fundamental matrix
  [f,index] = estimateFundamentalMatrix(matchedPointsAB_A,matchedPointsAB_B,...
      'Method','LMedS','NumTrials',10000); %numtrials inc from 2000 to 6000
     
  % Find epipoles
  nfr = null(f); %right null vector unscaled
  er = nfr/nfr(3) %epipole 
  nfl= null(f');  %left null vector unscaled
  el = nfl/nfl(3) %epipole
  % Draw epipolar lines
  cor_ptsA = zeros((sum(index(:) == 1)),2); 
   inum = (sum(index(:) == 1));
  cor_ptsB = zeros(size(cor_ptsA));
  xs = 1; %start col
  xe = 480; %end col of the image
  cor_ptsA = matchedPointsAB_A.*index;
  v = nonzeros(cor_ptsA);
  cor_ptsA = reshape(v, size(v,1)/2,2);
  
  cor_ptsB = matchedPointsAB_B.*index;
  v = nonzeros(cor_ptsB);
  cor_ptsB = reshape(v, size(v,1)/2,2);
  
  onepad = ones(size(cor_ptsA,1),1);
  cptsA = [cor_ptsA onepad];
  cptsB = [cor_ptsB onepad];
  
  % Lines in image 2
  L2 = cptsA * f'; 
  L1 = cptsB * f; 
  
  d2 = L2(:,3);
  d1 = L1(:,3);
  
  xy2start = ones(inum,2); 
  xy2end = 480*ones(inum,2); %these hold the start and stop points of the lines on the 2nd image this second one is scaled to 480 ending x value 
  % the second  col of the ones above does not matter as they will be
  % reassigned 
  
  %image two lines
  xy2start(:,2) = ((-L2(:,1).*xy2start(:,1)) - d2)./L2(:,2);
  xy2end(:,2) = ((-L2(:,1).*xy2end(:,1)) - d2)./L2(:,2);
  
  %image one lines
  xy1start= ones(inum,2);
  xy1end = 480*ones(inum,2);
  
  xy1start(:,2) = ((-L1(:,1).*xy1start(:,1)) - d1)./L1(:,2);
  xy1end(:,2) = ((-L1(:,1).*xy1end(:,1)) - d1)./L1(:,2);
  
  figure(2)
  imshow(im1,[])
  hold on
  plot([1 480],[xy1start(:,2) xy1end(:,2)],'linewidth',2, 'Color','yellow')
  hold on 
  plot(cor_ptsA(:,1),cor_ptsA(:,2),'o','Color','red')
  
  figure(3)
  imshow(im2)
  hold on
  plot([1 480],[xy2start(:,2) xy2end(:,2)],'linewidth',2, 'Color','yellow')
    plot(cor_ptsB(:,1),cor_ptsB(:,2),'o','Color','red')
end