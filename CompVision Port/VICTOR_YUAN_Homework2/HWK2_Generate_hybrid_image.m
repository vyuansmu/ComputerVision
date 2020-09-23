close all
clear all
%% loading data into pairs
cat = imread('cat.bmp');
dog = imread('dog.bmp');
HWK2_HybridImages(dog,cat);

bird = imread('bird.bmp');
plane = imread('plane.bmp');
HWK2_HybridImages(bird,plane);

bike = imread('bicycle.bmp');
motor = imread('motorcycle.bmp');
HWK2_HybridImages(bike,motor);

fish = imread('fish.bmp');
sub = imread('submarine.bmp');
HWK2_HybridImages(fish,sub);

ein = imread('einstein.bmp');
mar = imread('marilyn.bmp');
HWK2_HybridImages(ein, mar)

  