close 
clear all
%% HWK1_Denoising_by_Averaging
im_original = imread('HubbleImageGray.png');
HubbleImageGray = double(im_original); %converted to pray scale

%% noise generation loop
s = size(HubbleImageGray);
sigma = 50;
noise = zeros(s(1,1),s(1,2),200);
output = zeros(s(1,1),s(1,2),200);
for i = 1:200
  noise(:,:,i) = randn(s).*sigma;
  output(:,:,i) =max(min(HubbleImageGray + noise(:,:,i),255),0) ;
end
%% smoothing by 25 50 100 200
counter = 0;
sum25 = zeros(s);
for i = 1:25
sum25 = sum25 + output(:,:,i); 
end
denoised25 = sum25./25;


sum50 = zeros(s);
for i = 1:50
sum50 = sum50 + output(:,:,i); 
end
denoised50 = sum50./50;

sum100 = zeros(s);
for i = 1:100
sum100 = sum100 + output(:,:,i); 
end
denoised100 = sum100./100;

sum200 = zeros(s);
for i = 1:100
sum200 = sum200 + output(:,:,i); 
end
denoised200 = sum200./200;


%% Graphing 
figure(1)
subplot(2,2,1)
imshow(denoised25,[])
title('25 images')

subplot(2,2,2)
imshow(denoised50,[])
title('50 images')

subplot(2,2,3)
imshow(denoised100,[])
title('100 images')

subplot(2,2,4)
imshow(denoised200,[])
title('200 images')

figure(2)
imshow(HubbleImageGray,[])
%% Error Calc
err25 = HubbleImageGray - denoised25; %using the double version of the original img
err50 = HubbleImageGray - denoised50;
err100 = HubbleImageGray - denoised100;
err200 = HubbleImageGray - denoised200;
mse25 = mean(err25(:).^2);
mse50 = mean(err50(:).^2);
mse100 = mean(err100(:).^2);
mse200 = mean(err200(:).^2);

