function Midterm_Panorama()
    %% Load In images
    clc, close all
    clear all
    %vlfeat -0.9.16/toolbox/vl_setup.m run this file 
    %following the examples from the previous hw 
    im1 = imread('keble_a.jpg');
    im2 = imread('keble_b.jpg');
    im3 = imread('keble_c.jpg');
    img1 = single(rgb2gray(im1));
    img2 = single(rgb2gray(im2));
    img3 = single(rgb2gray(im3));
    
  % Extract SIFT keypoints & descriptors for images
    [F1,Da] = vl_sift(img1);
    [F2,Db] = vl_sift(img2);
    [F3,Dc] = vl_sift(img3);
    
  % From inspection it looks in order from a-> b-> C but just in case check
    match_ab= vl_ubcmatch(Da, Db);
    match_bc= vl_ubcmatch(Db, Dc);
    t1 = length(match_ab) + length(match_bc); %count the matches 
  % check other order combos(just in case)
    %acb
    %match_ac= vl_ubcmatch(Da,Dc);
    %match_cb= vl_ubcmatch(Dc,Db);
    %t2 = length(match_ac) +length(match_cb);
    %bac
    %match_ba= vl_ubcmatch(Db,Da);
    %match_ac= vl_ubcmatch(Da,Dc);
    %t3 = length(match_ba) + length(match_ac);
    %bca
    %match_bc= vl_ubcmatch(Db,Dc);
    %match_ca= vl_ubcmatch(Dc,Da);
    %t4 = length(match_bc) + length(match_ca);
    %cba
    %match_cb= vl_ubcmatch(Dc,Db);
    %match_ba= vl_ubcmatch(Db,Da);
    %t5 = length(match_cb) + length(match_ba);
    %cab
    %match_ca= vl_ubcmatch(Dc,Da);
    %match_ab= vl_ubcmatch(Da,Db);
    %t6 = length(match_ca) + length(match_ab);
    % upon closer inspection it is obvious the order is A->B->C but to make
    % sure the above test can be performed to see which pair has the
    % highest total match pair and the two pairs that had the highest
    % matching pair was abc and cba with cba just being the inverse of abc
    % it has been commented out to reduce sucessive computation time 
    
    %A->B->C
    matchedPointsAB_A = zeros(length(match_ab),2);
    matchedPointsAB_B = zeros(length(match_ab),2);
    matchedPointsBC_B = zeros(length(match_bc),2);
    matchedPointsBC_C = zeros(length(match_bc),2);
    
    %extracting xy coordinates from F
    for i = 1:length(match_ab)%460  
    matchedPointsAB_A(i,:) = F1(1:2,match_ab(1,i));
    matchedPointsAB_B(i,:) = F2(1:2,match_ab(2,i));
    end
    
    for i = 1:length(match_bc)%475
    matchedPointsBC_B(i,:) = F2(1:2,match_bc(1,i));
    matchedPointsBC_C(i,:) = F3(1:2,match_bc(2,i));
    end

    tform1 = estimateGeometricTransform(matchedPointsAB_A,matchedPointsAB_B,...
        'projective','MaxNumTrials',1001,'Confidence',97,'MaxDistance',1.51);
    
    tform2 = estimateGeometricTransform(matchedPointsBC_C,matchedPointsBC_B,...
        'projective','MaxNumTrials',1001,'Confidence',97,'MaxDistance',1.51);
    tforms = [tform1 tform2];
    I = zeros(size(img2,1),size(img2,2),3);
    I(:,:,1) = img1;
    I(:,:,2) = img2;
    I(:,:,3) = img3;

    
    xlim = zeros(2,2);
    ylim = zeros(2,2);
    %computing the output limits of the transforms
    
    [xlim(1,:), ylim(1,:)] = outputLimits(tforms(1),[1 size(img1,1)],[1 size(img1,1)]); 
    [xlim(2,:), ylim(2,:)] = outputLimits(tforms(2),[1 size(img3,1)],[1 size(img3,1)]); 
    
    maxImageSize = size(I); %max not needed since uniform sized images
    
    %The following Code section was modified from the panorama example
    %referenced by the assignment sheet and can be found at:
    %https://www.mathworks.com/help/vision/examples/feature-based-panoramic-image-stitching.html
    xMin = min([1; xlim(:)]);
    xMax = max([maxImageSize(2); xlim(:)]);
    
    yMin = min([1; ylim(:)]);
    yMax = max([maxImageSize(1); ylim(:)]);
    
    % Width and height of panorama.
    width  = round(xMax - xMin);
    height = round(yMax - yMin);
    

    panorama = zeros([height width 3], 'like', im1);
    
    xLimits = [xMin xMax];
    yLimits = [yMin yMax];
    panoramaView = imref2d([height width], xLimits, yLimits);

    %Apply the transforms
    output1 = imwarp(im1,tform1,'OutputView', panoramaView);
    output2 = imwarp(im3,tform2,'OutputView', panoramaView);
    
    blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  
    mask = imwarp(true(size(im1,1),size(im1,2)), tforms(1), 'OutputView', panoramaView);
    panorama = step(blender, panorama, output1, mask);
    
    mask = imwarp(true(size(im3,1),size(im3,2)), tforms(2), 'OutputView', panoramaView);
    panorama = step(blender, panorama, output2, mask);
    
    tform_nochange = [1 0 0; 0 1 0; 0 0 1]; % a identity matrix
    tformn = projective2d(tform_nochange);
    outputmid = imwarp(im2,tformn,'OutputView', panoramaView);
    mask = imwarp(true(size(im2,1),size(im2,2)), tformn, 'OutputView', panoramaView);
    panorama = step(blender, panorama, outputmid, mask);
    figure
    imshow(panorama,[])
    %% Deliverables 
    figure
    ax = axes;
    showMatchedFeatures(img1,img2,matchedPointsAB_A,matchedPointsAB_B,'montage');
    hold on
    title(ax, 'Candidate point matches A to B');
    legend(ax, 'Matched points A','Matched points B');
    
    figure
    ax = axes;
    showMatchedFeatures(img2,img3,matchedPointsBC_B,matchedPointsBC_C,'montage');
    hold on
    title(ax, 'Candidate point matches B to C');
    legend(ax, 'Matched points B','Matched points C');
        
    %After Homography
    %recalculate match points
    out1 = single(rgb2gray(output1));
    out2 = single(rgb2gray(output2));
    [F1h,Dah] = vl_sift(out1);
    [F2h,Dbh] = vl_sift(img2);
    [F3h,Dch] = vl_sift(out2);
    match_abh= vl_ubcmatch(Dah, Dbh);
    match_bch= vl_ubcmatch(Dbh, Dch);
    
    matchedPointsAB_Ah = zeros(length(match_abh),2);
    matchedPointsAB_Bh = zeros(length(match_abh),2);
    matchedPointsBC_Bh = zeros(length(match_bch),2);
    matchedPointsBC_Ch = zeros(length(match_bch),2);
    
    %extracting xy coordinates from F
    for i = 1:length(match_abh) 
    matchedPointsAB_Ah(i,:) = F1h(1:2,match_abh(1,i));
    matchedPointsAB_Bh(i,:) = F2h(1:2,match_abh(2,i));
    end
    
    for i = 1:length(match_bch)
    matchedPointsBC_Bh(i,:) = F2h(1:2,match_bch(1,i));
    matchedPointsBC_Ch(i,:) = F3h(1:2,match_bch(2,i));
    end
    
    figure
    ax = axes;
    showMatchedFeatures(output1,im2,matchedPointsAB_Ah,matchedPointsAB_Bh,'montage');
    hold on
    title(ax, 'Candidate point matches A to B, After Homography');
    legend(ax, 'Matched points A','Matched points B');
    
    figure
    ax = axes;
    showMatchedFeatures(im2,output2,matchedPointsBC_Bh,matchedPointsBC_Ch,'montage');
    hold on
    title(ax, 'Candidate point matches B to C');
    legend(ax, 'Matched points B','Matched points C, After Homography');
end