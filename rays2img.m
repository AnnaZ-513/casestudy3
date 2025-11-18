function [img,x,y] = rays2img(rays_x,rays_y,width,Npixels)
% rays2img - Simulates the operation of a camera sensor, where each pixel
% simply collects (i.e., counts) all of the rays that intersect it. The
% image sensor is assumed to be square with 100% fill factor (no dead
% areas) and 100% quantum efficiency (each ray intersecting the sensor is
% collected).
%
% inputs:
% rays_x: A 1 x N vector representing the x position of each ray in meters.
% rays_y: A 1 x N vector representing the y position of each ray in meters.
% width: A scalar that specifies the total width of the image sensor in 
%   meters.
% Npixels: A scalar that specifies the number of pixels along one side of 
%   the square image sensor.
%
% outputs:
% img: An Npixels x Npixels matrix representing a grayscale image captured 
%   by an image sensor with a total Npixels^2 pixels.
% x: A 1 x 2 vector that specifies the x positions of the left and right 
%   edges of the imaging sensor in meters.
% y: A 1 x 2 vector that specifies the y positions of the bottom and top 
%   edges of the imaging sensor in meters.
%
% Matthew Lew 11/27/2018
% 11/26/2021 - edited to create grayscale images from a rays_x, rays_y
% vectors
% 11/9/2022 - updated to fix axis flipping created by histcounts2()
load("lightField.mat");

% eliminate rays that are off screen
onScreen = abs(rays_x)<width/2 & abs(rays_y)<width/2;
x_in = rays_x(onScreen);
y_in = rays_y(onScreen);

% separate screen into pixels, calculate coordinates of each pixel's edges
mPerPx = width/Npixels;
Xedges = ((1:Npixels+1)-(1+Npixels+1)/2)*mPerPx;
Yedges = ((1:Npixels+1)-(1+Npixels+1)/2)*mPerPx;

% count rays at each pixel within the image
img = histcounts2(y_in,x_in,Yedges,Xedges);    % histcounts2 for some reason assigns x to rows, y to columns


% rescale img to uint8 dynamic range
img = uint8(round(img/max(img(:)) * 255));
x = Xedges([1 end]);
y = Yedges([1 end]);

% figure;
% image(x_edges([1 end]),y_edges([1 end]),img); axis image xy;
end





figure;
f= 0.15; %m
r = 0.02; %m
Mf = [1 0 0 0;-1/f 1 0 0;0 0 1 0;0 0 -1/f 1];
Md1 = Md;
c = 0.4;
Md2 = [1 c 0 0; 0 1 0 0; 0 0 1 c; 0 0 0 1];
M = (Md2*Mf*Md1);
prop = M * original;


z_plot = [0; d];         
x_plot = [original(1,:); prop(1,:)];   

idx1 = 1:N;
idx2 = (N+1):(2*N);

plot(z_plot, x_plot(:,idx1), 'blue', 'LineWidth', 1.4); 
hold on;
plot(z_plot, x_plot(:,idx2), 'red', 'LineWidth', 1.4); 

xlabel('z (m)');
ylabel('x (m)');
title('Propagated rays from two points');
legend('x = 0 mm','x = 10 mm');



figure; 
hold on; 

% Segment 1: object → lens (all rays)
z1 = [0; d1];
x1 = [original(1,:); rays_at_lens(1,:)];

plot(z1, x1(:,1:N), 'b', 'LineWidth', 1.3);       % rays from x = 0 mm
plot(z1, x1(:,N+1:2*N), 'r', 'LineWidth', 1.3);   % rays from x = 10 mm

% Segment 2: lens → final plane (only rays that hit lens)
z2 = [d1; d1 + d2];
x2 = [rays_at_lens(1,hits); rays_final(1,:)];

plot(z2, x2, 'k', 'LineWidth', 1.3);


xlabel('z (m)');
ylabel('x (m)');
title('Rays through lens');
legend('Object = 0 mm', 'Object = 10 mm', 'Rays Through Lens');




