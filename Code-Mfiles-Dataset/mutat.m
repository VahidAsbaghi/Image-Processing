function mupop=mutat(crospop,Pm)
%% **********************Mutation Process**********************************

%1- for each coromosome: generate a random double number in [0,1]
%2- if 'random number'< Pm then do:
%3- replace 5% of genes with new random number

%for keep ascending order new random gen value must lower than next gen
%value and greater than previous gen value

%% ************************************************************************
len=length(crospop(:,1));
len1=length(crospop(1,:));
len2=round(5*len1/100);
for i=1:len
    ra=randi([1 1000])/1000;
    if (ra<Pm)
        ra1=randperm(len1-1);
        ra2=ra1(1:len2);
        for j=1:len2
            if(ra2(j)~=1) && (ra2(j)~=(len1-1))
                crospop(i,ra2(j))=randi([crospop(i,ra2(j)-1) crospop(i,ra2(j)+1)]);
            elseif (ra2(j)==1)
                crospop(i,ra2(j))=randi([0 crospop(i,ra2(j)+1)]);
            else
                crospop(i,ra2(j))=randi([crospop(i,ra2(j)-1) 255]);
            end
        end
        crospop(i,len1)=0;
    end
end
mupop=crospop;

%**************************************************************************
%***************************End Function***********************************
end
%**************************************************************************
%**************************************************************************