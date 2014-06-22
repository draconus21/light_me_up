function mapC = equalizeSub(img2, center, disp)

if nargin < 1
    error('no input image specified')
end
img = img2;

lLimit = max(center - disp, 0);
rLimit = min(center + disp, 255);
range = rLimit - lLimit;

alpha = 1;

uni1 = unique(img);
ad = uni1>=lLimit & uni1 <=rLimit;
uni = uni1(ad);

l = length(uni);
if(l == 0)
    mapC = ones(256, 1);
    return;
end

freq = zeros(l, 1);
probc = zeros(l, 1);
output = zeros(l, 1);

for i = 1:length(uni)
    freq(i) = length(find(img == uni(i)));
    if(i>1)
        probc(i) = probc(i-1) + freq(i);
    else
        probc(i) = freq(i);
    end
end

NoP = probc(length(probc));
probc = probc ./NoP;
bins = min(round(range*(1+alpha)), 255);
ex = round((bins - range)/2);
if(lLimit-ex >= 0 && rLimit+ex <= 255)
    lLimit = lLimit-ex;
elseif (rLimit+ex >255)
    lLimit = lLimit - 2*ex;
end
    
for i = 1:size(probc)       
    output(i) = lLimit + round(probc(i) * bins);
end

dis = zeros(256, 1);
mapC = zeros(256, 1);

for i=1:length(mapC)
    dis(i) = i - 1;
    mapC(i) = i-1;
end

for i = 1:length(output)
    dis(uni(i)+1) = output(i);
end

mapC = mapC - dis;

end