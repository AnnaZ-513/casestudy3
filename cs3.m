clear; clc; close all;


x = [0, 10e-3];  
y = [0, 0];      

N = 8; 
angles = linspace(-pi/20, pi/20, N);

d = 0.2;   

originalOne = zeros(4,N);
originalOne(1,:) = x(1);
for i = 1:N
    originalOne(2,i) = angles(i);
end

originalTwo = zeros(4,N);
originalTwo(1,:) = x(2);
for r = 1:N
    originalTwo(2,r) = angles(r);
end
original = [originalOne, originalTwo];

Md = [1 d 0 0; 0 1 0 0; 0 0 1 d; 0 0 0 1];

final = Md * original;

figure;  
z_plot = [0; d];         
x_plot = [original(1,:); final(1,:)];   

idx1 = 1:N;
idx2 = (N+1):(2*N);

plot(z_plot, x_plot(:,idx1), 'blue', 'LineWidth', 1.4); 
hold on;
plot(z_plot, x_plot(:,idx2), 'red', 'LineWidth', 1.4); 

xlabel('z (m)');
ylabel('x (m)');
title('Propagated rays from two points');
legend('x = 0 mm','x = 10 mm');




f= 0.15; %m
r = 0.02; %m
z_dist = 0.2 %m

d1 = z_dist;    
c = 0.4;
d2 = c - d1; 

Md1 = [1 d1 0 0; 0 1 0 0; 0 0 1 d1; 0 0 0 1];
Md2 = [1 d2 0 0; 0 1 0 0; 0 0 1 d2; 0 0 0 1];

Mf = [1 0 0 0; -1/f 1 0 0; 0 0 1 0; 0 0 -1/f 1];

rays_at_lens = Md1 * original;

hits = abs(rays_at_lens(1,:)) <= r


rays_after_lens = Mf * rays_at_lens(:, hits);  
rays_final = Md2 * rays_after_lens;             

figure; 
hold on; 


blue_hits = hits(1:N);         
red_hits = hits(N+1:end);       

z1 = [0; d1];
x1_all = [original(1,:); rays_at_lens(1,:)];

plot(z1, x1_all(:,1:N), 'b', 'LineWidth', 1.3);    
plot(z1, x1_all(:,N+1:end), 'r', 'LineWidth', 1.3); 

z2 = [d1; d1+d2];

blue_count = 0;
for i = 1:N
    if blue_hits(i)
        blue_count = blue_count + 1;
        x_lens = rays_at_lens(1,i);
        x_final = rays_final(1,blue_count);
        
        plot([d1, d1+d2], [x_lens, x_final], 'b', 'LineWidth', 1.3);
    end
end

red_count = 0;
for i = 1:N
    if red_hits(i)
        red_count = red_count + 1;
        x_lens = rays_at_lens(1,N+i);
        x_final = rays_final(1,blue_count + red_count);
        
        plot([d1, d1+d2], [x_lens, x_final], 'r', 'LineWidth', 1.3);
    end
end

xlabel('z (m)');
ylabel('x (m)');
title('Rays through lens');
legend('x=0mm', 'x=10mm');