function HWK2_SeamCarving()
% Best Practices
  clc, close all

  im = imread('pencil.jpg');      % Read the image
  im = im2double(rgb2gray(im)); % Convert to grayscale & double
  %
  numColumns_to_drop =25;     
  im_reduced = reduce_width( im, numColumns_to_drop );
  
  % Display
  figure(1)
    imshow( im, 'initialmagnification','fit' ); 
    title('Original Image');
  figure(2)
    imshow( im_reduced, 'initialmagnification','fit' ); 
    title('Result of Seam Carving');
 
    %% q2
    q2(im)
    q2(im_reduced)
    
end

function im_reduced = reduce_width(im, numPixels)
  im_old = im;
  for niter = 1:numPixels
    %{
      Function that identifies optimal vertical seam
        - accepts as input an image
        - outputs the columns associated with the optimal Vertical seam
          beginning with the first row
    %}
    optVertSeamPath = findOptVertSeam( im_old );
    
    % MATLAB code fragment for removing vertical seam from image
    im_new = 0 * im_old(:,1:end-1); % Define storage for new image with reduced width
    % From each row, remove the column associated with the optimal vertical seam  
    for r = 1:size(im,1)
      im_new(r,:) = im_old(r,[1:optVertSeamPath(r)-1,optVertSeamPath(r)+1:end]);
    end
    % Update the image and proceed to next iteration
    im_old = im_new;
    %{
      Display the result of intermediate seam removal
    %}
    figure(101),
      % Display the image
      imshow( im_new,'initialMagnification','fit' );
      % Overlay optimal Vertical Seam
      line( optVertSeamPath,1:size(im,1) ,'color','r','linewidth',0.5 );
      % Display iteration number
      title(sprintf('Iteration %d',niter));    
    %  
    pause(0.01)
  end
  im_reduced = im_new;
end


%{
  Function to find optimum vertical seam given an image
    - accepts as input an image
    - outputs the columns associated with the optimal Vertical seam
      beginning with the first row
%}
function optVertSeamPath = findOptVertSeam( im )
    [Gx, Gy] = imgradientxy(im);
    Es = abs(Gx) + abs(Gy); %calculating energy
    %display Es
   [row, col] = size(Es);
    M = zeros(row,col);%accounts for the padding on each side
   %first row never changes
     E = padarray(Es, [0 1], Inf); %padding array with Inf as advised
     M(1,:) = Es(1,:);
     M = padarray(Es, [0 1], Inf);
    %rows arent changed so just change values of j in E for the loop
    for i= 2:row
        for j = 2:col+1
        M(i,j) = E(i,j) + min([M(i-1,j-1) M(i-1,j) M(i-1,j+1)]);
        end
    end
    
    
   [~,j] = min(M(end,:));
   optCols = zeros(row,1);
   x = 1;
   optCols(x,1) = j;
   
    for i= row-1:-1:1
        x = x +1;
       [~,y] = min([M(i,j-1) M(i,j) M(i,j+1)]);
        if y == 1
            j = j-1;
        end
        if y == 2
            j = j;
        end
        if y == 3
            j = j+1;
        end
       optCols(x,1) = j;
    end
    optVertSeamPath = optCols - 1;
end

%im just recalling the function for the first iteration becuase i dont want
%to sort thru 10 itterations 
function display4question2 = q2( im )
    [Gx, Gy] = imgradientxy(im);
    Es = abs(Gx) + abs(Gy); %calculating energy
    %display Es
   [row, col] = size(Es);
    M = zeros(row,col);%accounts for the padding on each side
   %first row never changes
     E = padarray(Es, [0 1], Inf); %padding array with Inf as advised
     M(1,:) = Es(1,:);
     M = padarray(Es, [0 1], Inf);
    %rows arent changed so just change values of j in E for the loop
    for i= 2:row
        for j = 2:col+1
        M(i,j) = E(i,j) + min([M(i-1,j-1) M(i-1,j) M(i-1,j+1)]);
        end
    end
    m = zeros(row,col);
    m = M(:,2:end-1);%removes infs
    figure()
    imagesc(Es)
    figure()
    imagesc(m)
end
