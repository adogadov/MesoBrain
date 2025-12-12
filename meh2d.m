function Image2 = meh2d(Image,scale)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
[n,m] = size(Image);
% Image2=zeros(n,m);
Mhat=zeros(n,m);
% for x=1:n
%     for y=1:m
%         for x2=1:n
%             for y2=1:n
%                 Image2(x,y)=Image2(x,y)+Image(x,y)*(1-0.5*((x2^2+y2^2)/scale^2))*exp(-(x2^2+y2^2)/(2*scale^2))/(pi*scale^4);
%             end
%         end
%     end
% end
for x2=1:n
    for y2=1:m
        Mhat(x2,y2)=(1-0.5*(((x2-round(n/2))^2+(y2-round(m/2))^2)/scale^2))*exp(-((x2-round(n/2))^2+(y2-round(m/2))^2)/(2*scale^2))/(pi*scale^4);
    end
end
Image2=fftshift(ifft2(fft2(Image).*fft2(Mhat)));
end

