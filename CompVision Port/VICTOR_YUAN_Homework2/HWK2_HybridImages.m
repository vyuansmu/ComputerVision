function HWK2_HybridImages(a,b)
  % Read the image from disk using imread()
  % Convert to grayscale using rgb2gray()
  image1 = rgb2gray(a); 
  image2 = rgb2gray(b); 
  %I modified this function slightly to test multiple images

  % Pick value for 
  %   sigma (standard deviation of Gaussian blur kernel)
  %   alpha (blend ratio)
  sigma = 5;
  alpha = 0.5;
  
  % Create hybrid image
  [hybrid_image,low_frequencies,high_frequencies] = ...
    HWK2_Create_hybrid_image( image1, image2, sigma, alpha );
  
  % Display hybrid image
  figure
    imshow( hybrid_image,[],'InitialMagnification','fit' )
    axis equal, axis tight
    title('Hybrid Image')
    
    
  % Display Original images
  figure
  subplot(1,2,1)
    imshow( image1,[],'InitialMagnification','fit' )
    axis equal, axis tight
    title('Original image 1')
  subplot(1,2,2)
    imshow( image2,[],'InitialMagnification','fit' )
    axis equal, axis tight
    title('Original image 2')
  % Display Filtered Images
  figure
  subplot(1,2,1)
    imshow(low_frequencies,[],'InitialMagnification','fit' )
    axis equal, axis tight
    title('Low passed image 1')
  subplot(1,2,2)
    imshow(high_frequencies,[],'InitialMagnification','fit' )
    axis equal, axis tight
    title('High passed image 2')
    
    
  % Visualize hybrid image
  output = HWK2_Visualize_hybrid_image(hybrid_image);    
  figure
    imshow( output,[],'InitialMagnification','fit' )
    axis equal, axis tight
    title('Hybrid Image Visualization')
end