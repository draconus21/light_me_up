function [guideImg h] = localGuidanceMap(img_name, s, jImg)

img = imread(img_name);
hsv = rgb2hsv(img);
lum = hsv(:, :, 3);

jLum = exp(jImg);

nImg = double(img);

HDR(:, :, 1) = ((nImg(:, :, 1)./lum).^s) .* jLum;
HDR(:, :, 2) = ((nImg(:, :, 2)./lum).^s) .* jLum;
HDR(:, :, 3) = ((nImg(:, :, 3)./lum).^s) .* jLum;

guideImg = uint8((HDR));

e = unique(guideImg);
h = histc(guideImg(:), e);

end
