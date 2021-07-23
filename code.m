clc
close all
clear all
%% read image

raw_img = imread('threecars.jpg');
raw_img = imresize(raw_img,[400 nan]);
%% read empty parking space

empty_img = imread('parking.jpg');
empty_img = imresize(empty_img,[400 nan]);
%% subtract to get rid of parking lines

img = imsubtract(raw_img,empty_img);
subplot(2,2,1),imshow(img),title('without parking lines');
%% convert from RGB to grayscale

igray = rgb2gray(img);
%% convert from grayscale to binary with specified threshold

level = 0.02;
ithresh = im2bw(igray,level);
subplot(2,2,2), imshow(ithresh),title('binary image');
%% fill holes

ifilled = imfill(ithresh,'holes');
%% shaping every object with specified disk size

se = strel('disk',5);
iopen = imopen(ifilled,se);
%% remove small unnecessary objects

iclear = bwareaopen(iopen,4,4);
subplot(2,2,3), imshow(iclear), title('car blobs');
%% making boundary boxes around detected cars

subplot(2,2,4),imshow(raw_img),title('boundary boxes');
props = regionprops(iclear,'BoundingBox','Image');
for i=1:size(props,1)
rectangle('Position',props(i).BoundingBox,'EdgeColor','g','LineWidth',2);
end
%% count no. of cars and print available spots

dialog = msgbox(['No. of availabe spots in this lot is: ',num2str(10-i)])