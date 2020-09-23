function [houghSpace] = houghTransform_for_Circles(im,radius) %im is 0 or 1
  %Define the hough space
  [nR,nC] = size(im);
  
  if nargin < 2
    error('ERROR: Need to provide radius.');
  else
    assert( radius < norm([nR,nC])/2,'ERROR: ' );
  end

  % The Hough Accumulator array for circles is parametrized by two
  % quantities: the cent  er of each circle
  % The candidate centers could be anywhere in the image
  % Thus, the houghSpace must have size nR x nC
  
    H = zeros(nR,nC); %my interpertation of houghspace accumulator
  
  %Find the "edge" pixels
 for x = 1:nR
     for y = 1:nC 
         if im(x,y) == 1 % if the pixel value is a edge then its going to be 1 otherwise do nothing for that pixel
            % Define Hough Parameter Space
            for theta = 0:2*pi/360:2*pi
            % Angle parameter Used to create circles
            a = x - radius*cos(theta);
            b = y + radius*sin(theta);          
          
            a = round(a);
            b = round(b);
            
            a(a<=0 | a>=(nR-1)) = 1;  
            b(b<=0 | b>=(nC-1)) = 1;  
                        
            % Accumlate Hough votes
            H(a,b) = H(a,b) +  1;
         end
       end
 end
  % The boundary of the Hough space contains strong and spurious peaks
  % Null them out to avoid confusion
  H(1,:) = 0;
  H(:,1) = 0;
  H(end,:) = 0;
  H(:,end) = 0;
  houghSpace = H;
 
end