function adj = setGaussianAdjust(gImg, gauss, offset)

adj = zeros(size(gImg, 1), size(gImg, 2), size(gImg, 3));

newGauss = zeros(size(gauss));

for i = 1:length(gauss)
    idx = i - offset;
    if(idx>256 || idx <1)
        newGauss(i) = 0;
    else
        newGauss(i) = gauss(idx); 
    end
end

    for i = 1:size(gImg, 1)
    for j = 1:size(gImg, 2)
    for k= 1:size(gImg, 3)
        adj(i, j, k) = newGauss(gImg(i, j, k) + 1);
    end
    end
    end
end