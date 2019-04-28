function selpop=selectn(fitval,Pc,Popsize,Pop)
%% ********************** Selection Algorithm******************************

% article writers for selection choose roulette wheel algorithm
% roulette wheel give more chance to more probable choromosomes (greater fitness
% value) to select
% selected choromosomes in this procedure send to mate processes

%**************roulete wheel algorithm*************
%1- evaluate probability of fitness value for each choromosome
%2- evaluate cumulative sum of probabilities for each choromosome
%3- for 1 to a 'size number'= Pc*Population_size do:
%4- if cumsum(1)> rand_num then choose first choromosome
%5- else choose first choromosome that cumsum(i)>rand_num for i=2 to Popsize
% end do

%% ************************************************************************
prob=fitval./sum(fitval);
q=cumsum(prob);
len=length(fitval);

i=1;
while (i<=Popsize*Pc)
    r=randi([1 10000])/10000;
    if (q(1)>r)
        j(i)=1;
        i=i+1;
    else
        for k=2:len
            if (r<=q(k))
                j(i)=k;
                i=i+1;
                break;
            end
        end
    end
end
selpop=Pop(j,:);

%**************************************************************************
%********************************End Function******************************
end
%**************************************************************************
%**************************************************************************