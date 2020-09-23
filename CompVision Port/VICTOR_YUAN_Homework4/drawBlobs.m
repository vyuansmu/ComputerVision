function drawBlobs(I, cx, cy, rad, color)
%Basicly does the exact thing visCircles does but it accepts image as a
%imput
%   Detailed explanation goes here
    if color == 'blue'
        c = 'b';
    else 
        c = 'r'; % default red
    end
    figure
    imshow(I)
    viscircles([cy, cx],rad,'color',c)
end

