function [aImg, bImg] = guidanceMap( orig_img, w_size )

%create guidance map for image
p1 = 0.5;
p2 = 0.2;
p3 = 0.25;
p4 = 0.05;
% lambda = 0.55;
lambda = 1;

comp = (w_size-1)/2;
h = size(orig_img, 1);
w = size(orig_img, 2);
aImg = zeros(h, w);
bImg = zeros(h, w);
for i = 1:h
    for j = 1:w
        
        ii = i;
        jj = j;
        ctr = 1;
        iFlag = 0;
        jFlag = 0;
        sample = zeros(1,w_size*w_size);
        
        while(((ii-1)<=comp || (h-ii+1) < comp) && ii<=h)
            sample(1,ctr) = orig_img(i, j);
            ctr = ctr + 1;
            ii = ii + 1;
            iFlag = 1;
        end
        
        while(((jj-1)<=comp || (w-jj+1) < comp) && jj<=w)
            sample(1,ctr) = orig_img(i, j);
            ctr = ctr + 1;
            jj = jj + 1;
            jFlag = 1; 
        end
        
        a = (comp-i+1)*2*(h-i)/h;
        b = (comp-h+i)*2*i/h;
        c = (comp-j+1)*2*(w-j)/w;
        d = (comp-w+j)*2*j/w;
        a = floor((a+abs(a))/2);
        b = floor((b+abs(b))/2);
        c = floor((c+abs(c))/2);
        d = floor((d+abs(d))/2);
        
       if(iFlag==1 && jFlag==1)
           for iii = 1:(a+b)
               for jjj = 1:(c+d)
                   sample(1,ctr) = orig_img(i, j);
                   ctr = ctr + 1;
               end
           end
       end
       
       li = max(1, i-comp);
       ui = min(h, i+comp);
       lj = max(1, j-comp);
       uj = min(w, j+comp);
       
       for ii=li:ui;
           for jj=lj:uj
               sample(1, ctr) = orig_img(ii, jj);
               ctr = ctr + 1;
           end
       end
 
       u = abs(mean(sample));
       v = abs(var(sample));
       
       aImg(i, j) = 1/(u^p1 + lambda * v^p2);
       bImg(i, j) = u^p3 + lambda * v^p4;    
    end
end
            
end