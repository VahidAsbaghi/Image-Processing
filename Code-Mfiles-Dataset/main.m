function [psnr,edg,time]=main(Popsize,Pc,Pm,Gen,testimage)
%% ****************Main Function. Call All Other Functions*****************
%
%**************************************************************************
%********************Selected Parameters in Article************************
% Pc=0.8;
% Pm=0.1;
% Gen=100;
% Popsize=10;
% imtest=imread('5236.tif');
% testimage=imtest;
%Termination Criteria: after reach to maximum iteration or when the diffrence of best
%fitnes in two last consecutive generation is less than epsilon.

%Crossover Method: two point
%Mutation Method: replace five percent of gens by new random number if a
%                   random generated number is lower than Pm

%Selection Method: Roulette Wheel
%in article dont say about replacement method but it is not important
%because it is a routine job.
%**************************************************************************
%********************Main function Do:*************************************
%1- examine image is RGB or Graylevel and devide job to two section for RGB
%   or gray separatly
%2- for RGB images: do original algorithm for Red or Green or Blue part
%   of image matrix separatly and lastly combine those and show enhanced
%   image and return wanted values (psnr and number of edges)


%% ************************************************************************
tic();
%**************************************************************************
%*******************if image is rgb****************************************

if (ndims(testimage)==3)%use ndims becuase isrgb is a obsolete function and have a warning message 
    for l=1:3 %for R and G and B separately
        testimage1=testimage(:,:,l);
        uniqim=unique(testimage1); % bring out uniqe pixel values from image
        len=length(uniqim);
        lenl=len+1;
        Pop=zeros(Popsize,lenl);
        %generate initial population randomly for 0-255 graylevels
        %to save and achive all dynamic range in all choromoses firt gen
        %set to zero and last gen set to 255
        for i=1:Popsize
            Pop(i,:)=randi([0,255],1,lenl);
            Pop(i,1)=0;
            Pop(i,len)=255;
            Pop(i,lenl)=0;
            Pop(i,1:len)=sort(Pop(i,1:len),'ascend');%sort all Population members ascendent
        end
        
        temfit=zeros(1,Popsize);
        for i=1:Gen+1
            fitval=fitn(Pop,Popsize,testimage1,uniqim);%evaluate fitness for all pop members
            [f,J]=max(fitval);
            if(i==Gen+1)
                [image1(:,:,l),psnr,edg]=imageshow(Pop,testimage1,uniqim,fitval);
                break;
            end
            
            eps=0.02*f; %evaluate epsilon for termination
            
            %in some images if say (max(fitval)-max(temfit))~=0 may image
            %enhance better becuase in replace we select 10% of elite choromosomes
            %but in article dont say it. ofcourse for other images
            %this selected criteria is very good and running time is less
            
            if((max(fitval)-max(temfit))<eps)%&&((max(fitval)-max(temfit))~=0)
                [image1(:,:,l),psnr,edg]=imageshow(Pop,testimage1,uniqim,fitval);
                break;
            end
            
            temfit=fitval;% save fitness value of current population to compare with next population
            %fintess value for termination criteria
            selpop=selectn(fitval,Pc,Popsize,Pop); %selection
            crospop=crosov(selpop);%crossover
            mupop=mutat(crospop,Pm);%mutation
            Pop=replace(Pop,mupop,fitval,Popsize,Pc);%replacement
        end
    end
    figure;
    imshow(uint8(image1),[0 255]); %show enhanced image
    title('Enhanced Image');
    figure;
    imshow(testimage,[0 255]); %show original image
    title('Original Image');
    
    %************************************************************************
    %******************else if image is gray*********************************
else
    uniqim=unique(testimage);
    len=length(uniqim);
    lenl=len+1;
    Pop=zeros(Popsize,lenl);
    for i=1:Popsize
        Pop(i,:)=randi([0,255],1,lenl);
        Pop(i,1)=0;
        Pop(i,len)=255;
        Pop(i,lenl)=0;
        Pop(i,1:len)=sort(Pop(i,1:len),'ascend');
    end
    
    temfit=zeros(1,Popsize);
    for i=1:Gen+1
        fitval=fitn(Pop,Popsize,testimage,uniqim);
        [f,J]=max(fitval);
        if(i==Gen+1)
            [image,psnr,edg]=imageshow(Pop,testimage,uniqim,fitval);
            break;
        end
        eps=0.02*f;
        
        if((max(fitval)-max(temfit))<eps)%&&((max(fitval)-max(temfit))~=0)
            [image,psnr,edg]=imageshow(Pop,testimage,uniqim,fitval);
            break;
        end
        
        temfit=fitval;
        selpop=selectn(fitval,Pc,Popsize,Pop);
        crospop=crosov(selpop);
        mupop=mutat(crospop,Pm);
        Pop=replace(Pop,mupop,fitval,Popsize,Pc);
    end
    figure;
    imshow(image,[0 255]);
    title('Enhanced Image');
    figure;
    imshow(testimage,[0 255]);
    title('Original Image')
end
time=toc();%evaluate running time

%**************************************************************************
%****************************** End Function*******************************
%end
%**************************************************************************
%**************************************************************************
