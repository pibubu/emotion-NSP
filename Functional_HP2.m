function [Clus_num,Clus_size,FC] = Functional_HP(data,N)
[FEC FE]=eig(data);
FEC=fliplr(FEC);
H1_1=find(FEC(:,1)<0);
H1_2=find(FEC(:,1)>=0);
%%%%==============================================================
Clus_num=[1];%% number of cluster size 
Clus_size=cell(N,1);
for mode=2:N
    x=find(FEC(:,mode)>=0);
    y=find(FEC(:,mode)<0);
    H={};
    for j=1:2*Clus_num(mode-1)
        H{j}=eval(['H',num2str(mode-1),'_',num2str(j)]);%% assume the number of cluster in j-1 level is 2^(mode-1)
    end
    id = cellfun('length',H);%% length of each cluster in H
    H(id==0)=[];%% delete the cluster with 0 size
    id(id==0)=[];
    Clus_size{mode-1}=id;
    Clus_num=[Clus_num,length(H)];%% number of cluster
    k=1; 
    for j=1:2:2*Clus_num(mode)%模块数量
         Positive_Node=intersect(H{k},x);
         Negtive_Node=intersect(H{k},y);         
         k=k+1;
         eval(['H',num2str(mode),'_',num2str(j+1), '=', 'Positive_Node', ';'])
         eval(['H',num2str(mode),'_',num2str(j), '=', 'Negtive_Node', ';'])
    end  
    for j=1:2*Clus_num(mode-1)%模块数量
         eval(['clear',' H',num2str(mode-1),'_',num2str(j),'']);
    end
     Z=[];
    if (Clus_num(end)==N)
        for j=1:2*Clus_num(mode)
            Z=[Z;eval(['H',num2str(mode),'_',num2str(j)])];
        end
        break;
    end
end
Clus_num(1)=[];
Clus_num=[Clus_num/N,ones(1,N-length(Clus_num))];
% FC=zeros(N,N);
% for i=1:N
%     for j=1:N
%         FC(i,j)=data(Z(i),Z(j));
%     end
% end
end