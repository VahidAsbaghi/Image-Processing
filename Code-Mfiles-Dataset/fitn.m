function [fitval]=fitn(Pop,Popsize,testimage,uniqim)
%% ******************* Fitness Function ***********************************

% fitness function is multiplication of number of edges detected by sobel
% operator and double logarithm of overall intensity.
% overall intensity is described in article and report completely.

%% ************************************************************************
len=length(uniqim);
imtemp=zeros(256,256);
fitnes=zeros(1,Popsize);
filt1=[-1,-2,-1;0,0,0;1,2,1];   %for evaluate overall intensity in horizontal direction
filt2=[-1,0,1;-2,0,2;-1,0,1];   %for evaluate overall intensity in vertical direction
for i=1:Popsize
    if (Pop(i,len+1)==0)
        for j=1:len
            temp=uniqim(j);
            [x,y]=find(testimage==temp);    %find pixels in test image by temp value
            for k=1:length(x)
                imtemp(x(k),y(k))=Pop(i,j);     %create new image by set pixels by choromosoms values
            end
        end
        ed=edge(imtemp,'sobel');    %edge detect by sobel
        nedge=sum(sum(ed)); %count number of edges
        delh=imfilter(imtemp,filt1);
        delv=imfilter(imtemp,filt2);
        eix=sum(sum(sqrt(delv.^2+delh.^2)));    % evaluate E(I(x))
        fitnes(i)=log(log(eix)).*nedge;     %fitness
        Pop(i,len+1)=fitnes(i);
    else
        fitnes(i)=Pop(i,len+1);
    end
end
fitval=fitnes;

%**************************************************************************
%*************************End Function*************************************
end
%**************************************************************************
%**************************************************************************