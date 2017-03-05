function [max_energy, ang_max_energy] = gabor(img, t, l, K, mask)

[rows, cols] = size(img);

sx = t/(2*sqrt(2*log(2)));
sy = l*sx;
fx = 1/t;
fy = 0;

u = ((1:cols) - 1 - cols/2)*(2*pi/cols);
v = ((1:rows) - 1 - rows/2)*(2*pi/rows);
[U,V] = meshgrid(u,v);

theta = (pi/180)*(0:(180/K):179);

%max_energy =-Inf(rows,cols);
max_energy = zeros(rows,cols);
ang_max_energy = zeros(rows,cols);

IMG = fft2(img);

% High-pass filter img
HPF = 1 - exp(-(1/2)*((sy^2)*(U.^2 + V.^2)));
HPF = fftshift(HPF);
IMG = IMG.*HPF;

% Gabor filter bank
for i=1:length(theta)
    Up =  U*cos(theta(i)) + V*sin(theta(i));
    Vp = -U*sin(theta(i)) + V*cos(theta(i));
    Gabor = exp(-(1/2)*((sx^2)*(Up.^2 + (2*pi*fx)^2) + (sy^2)*(Vp.^2 + (2*pi*fy)^2))).*cosh(2*pi*((sx^2)*fx*Up + (sy^2)*fy*Vp));

    Gabor = fftshift(Gabor);
    FILT = IMG.*Gabor;
    amplitude = real(ifft2(FILT));
        
    idx_max = amplitude > max_energy;
    max_energy(idx_max) = amplitude(idx_max);
    ang_max_energy(idx_max) = -theta(i) + pi/2;
end

max_energy(mask(:) == 0) = 0;
ang_max_energy(mask(:) == 0) = 0;