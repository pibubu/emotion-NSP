for nSub = 1:1:32

path1 = strcat('E:\DEAP\2020-DEAP-HP\result\PLV\beta\s',num2str(nSub),'_PLV_beta.mat')
load(path1)    
    
path2 = strcat('E:\DEAP\2020-DEAP-HP\result\x\beta\s',num2str(nSub),'_x_beta.mat')
load(path2)


N = 32;
for nVideos = 1:1:40
    
        FC = PLV_beta{nVideos,timepoint};
        FC = FC +FC'+eye(30);
               
             [FEC FE]=eig(FC);
             [Clus_num,Clus_size] = Functional_HP2(FC,N);
  for timepoint = 1:1:287            
             
             [Hin,Hse,HF] =Balance(FC,N,Clus_size,Clus_num);
             
             x_balance(nVideos,timepoint) = Hin-Hse;
             x_sum(nVideos,timepoint) = Hin+Hse;
             x_Hin(nVideos,timepoint) = Hin; 
             x_Hse(nVideos,timepoint) = Hse;
             
             H1=(diag(HF)*flipud((FEC.^2)'));            

             IN{nVideos,timepoint} = H1(1,:);
             IM{nVideos,timepoint} = sum(H1(2:N,:));
             nodal_Balance{nVideos,timepoint} = H1(1,:)-sum(H1(2:N,:));
             nodal_Sum{nVideos,timepoint} = H1(1,:)+sum(H1(2:N,:));
       
    end
end

saveBALANCE = strcat('E:\0PhD\9\2020-gonogo\FC_PLV\beta\1\s',num2str(nSub),'_FC_plv_beta')
save(saveBALANCE,'x_balance','x_Hin','x_Hse','IN','IM','nodal_Balance','allClus_size','allClus_num')
end

