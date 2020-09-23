function [hybrid_image,low_pass,high_pass] = HWK2_Create_hybrid_image( im1, im2, sigma, alpha )
% Inputs:
% - image1 -> The image from which to take the low frequencies.
% - image2 -> The image from which to take the high frequencies.
% - sigma  -> The standard deviation, in pixels, of the Gaussian blur.
% - alpha  -> The blend ratio.
%
% Task:
% - Use imfilter to create 'low_pass' and 'high_pass'.
% - Combine them to create 'hybrid_image'.

    %{
        The two source images must have the same for computing the hybrid
        image. Attempt to do this by identifying the largest image size that can
        accommodate both images. Zero pad each image so that the padded
        images has the same size. This will the size of the hybrid image
    %}
    sz1 = size(im1);
    sz2 = size(im2);
    sz_hybrid = [ max(sz1(1),sz2(1)) , max(sz1(2),sz2(2)) ];
    %
    im1 = padarray(im1, [max(sz_hybrid(1),sz1(1))- sz1(1),...
        max(sz_hybrid(2),sz1(2))- sz1(2)]);
    
    im2 = padarray(im2, [max(sz_hybrid(1),sz2(1))-sz2(1),...
        max(sz_hybrid(2),sz2(2))- sz2(2)] );
    
    % 
    
    %generating h filter
    h = fspecial('gaussian', [20 20], sigma);
    
    %{
        Remove the high frequencies from image1 by blurring it. The amount of
        blur that works best will vary with different image pairs.
        Ensure that the kernel has ODD number of pixels.
    %}
   low_pass =  imfilter(im1,h,'conv');
    
    
    %{
        Remove the low frequencies from image2. The easiest way to do this is to
        subtract a blurred version of image2 from the original version of image2.
        This will give you an image centered at zero with negative values.
    %}

    high_pass = (im2 - (imfilter(im2,h,'conv')));

    
    %{
        Combine the high frequencies and low frequencies
    %}
    hybrid_image = alpha .*(low_pass) + (1- alpha).*high_pass;
end
