function newImg = fakeAdjust(img, map, adj)

newImg = (img);

for i=1:size(img, 3)
for j = 1:size(img, 1)
for k = 1:size(img, 2)
    newImg(j, k, i) = (img(j, k, i)) - round(map(img(j, k, i)+1, i)*adj(j, k, i));
    if(newImg(j, k, i) > 255)
        newImg(j, k, i) = 255;    
    elseif(newImg(j, k, i) < 0)
        newImg(j, k, i) = 0;
    else
        newImg(j, k, i);
    end;
end
end
end

end