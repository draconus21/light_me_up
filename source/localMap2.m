
%% ===============INITIALIZING===============
clear all;
a = [0 0.1 0.3 0.5 0.8 1.2 1.4 1.6];
b = [255 240 207 176 128 64 30 0];
     
b = b - 128; % gauss is centered at 128
mapGauss = fspecial('gauss', [256, 1], 128);
mapGauss = mapGauss/max(mapGauss);
mapGradient = 2*(1 - mapGauss);

lome = [1 5 10 20 24 30 50 100];

% include the names of all input images in the 'name' array. Ensure that
% all file names are of the same length. Append spaces at the end of
% shorter file names.

name = ['DSC_2055.jpg'; 'DSC_2100.jpg'; 'DSC_1999.jpg'; 'DSC_2020.jpg'; 'DSC_2021.jpg'; 'DSC_2022.jpg'; 'DSC_2023.jpg'; 'DSC_2024.jpg'];
name = ['DSC_0868'; 'DSC_0791'];
name = cellstr(name);

% uncomment to run the program on a subset of the 'name' array. Include the
% indices of desired images in 'name' array in the goSet.
% goSet = ['1'];

%% ===============PROCESSING IMAGES===============
for ii=1:(length(name))
% uncomment if goSet is set
%   if(isempty(find(goSet == ii, 1)))
%       continue;
%   end
fprintf('\n=======================================\n');
tic

% replace 'test images\' with path to input images (the path should be
% within the working directory
img_name = char(strcat('test images\', name(ii), '.jpg'));

% replace 'output\' with desired path for output images (the path should be
% within the working directory
out_name = char(strcat('output\', name(ii)));

fprintf('Processing %s...\n', img_name);

w_size = 3;
img = imread(img_name);

%% some preprocessing
hsv = rgb2hsv(img);
if(size(hsv, 3)>1)
lum = hsv(:, :, 3);
else
lum = hsv;
end;
brite = log(lum);

%% generating alpha and beta images and compute guide image
fprintf('Generating alpha and beta images...\n');
tic
[aImg, bImg] = guidanceMap(brite, w_size);
fprintf('Alpha and beta images generated in ');
toc
fprintf('\n');
jImg = bImg .* brite + aImg;

fprintf('Map generated...\n');

g = 6; %using 30
gauss = fspecial('gaussian', [256, 1], lome(g));
gauss = 0.75 * gauss/max(gauss);

gImg = zeros(size(img, 1), size(img, 2), size(img, 3));

newImg = rgb2hsv(img);
newImg(:, :, 3) = newImg(:, :, 3) * 255;
img1 = newImg(:, :, 3);
img2 = newImg(:, :, 3);

%% generating multiple adjustment matrices
for i2=1:length(a)
    fprintf('Processsing image at s = %d\n', a(i2));
    [gImg h] = localGuidanceMap(img_name, a(i2), jImg);
    
    adj = setGaussianAdjust(gImg, gauss, b(i2));
    
    disp = 128 - abs(b(i2));
    
    hsvMap = equalizeSub(newImg(:, :, 3), b(i2)+128, disp);
    hsvMap = hsvMap .* mapGradient;

    newImg(:, :, 3) = fakeAdjust(newImg(:, :, 3), hsvMap, adj);
end

%% ===============FINALIZING===============
newImg(:, :, 3) = newImg(:, :, 3) ./255;

out_name1 = char(strcat(out_name, '-Final.jpg') );
fprintf('Writing final image on to disk at %s...\n', out_name1);
imwrite(hsv2rgb(newImg), out_name1);

%% uncomment line below to perform histogram equalization on the original image
% 
% out_name2 = char(strcat(out_name, ' eq.jpg'));
% eqImg = hsv;
% eqImg(:, :, 3) = histeq(eqImg(:, :, 3));
% eqImg = hsv2rgb(eqImg);
% imwrite(eqImg, out_name2);

toc
end

