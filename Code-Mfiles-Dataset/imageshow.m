function [image,psnr,edg]=imageshow(Pop,testimage,uniqim,fitval)
%% Build New Image by best Choromosom, Original Image and Uniqe Number Pixels

% and return enhanced image, psnr and number of edges
% number of edges evaluated by sum ones value after do sobel edge detection
% threshold value is selected by matlab automatically
% evaluation of psnr is presented in algorithm below

%% ************************************************************************
len=length(uniqim);
[C,I]=max(fitval);
for j=1:len
    temp=uniqim(j);
    [x,y]=find(testimage==temp);
    for k=1:length(x)
        imtemp(x(k),y(k))=Pop(I,j);
    end
end
image=imtemp;
%t=double(testimage)-imtemp;
edges=edge(image,'sobel');
edg=sum(sum(edges));    %Calculate Number of Edges
[M,N]=size(testimage);
msee=(sum(sum(double(double(testimage)-imtemp).^2)))/(M*N); %Calculate MSE(Mean Squred Error)
psnr=10*log10((255^2)/msee);    %Calculate PSNR(Peak Signal to Noise Ratio)

%**************************************************************************
%***********************************End Function***************************
end
%**************************************************************************
%**************************************************************************