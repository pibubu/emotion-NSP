  clc
  clear all
for nSub = 17:1:32
    
    path = strcat('E:\0PhD\9\2022-example\DEAP\results\gamma_10\s',num2str(nSub),'_FC_plv')
    load(path)
    
    data_temp = FC_plv_gamma;
    N = size(data_temp,3);
    TN = size(data_temp,2);
    
    for trail =1:1:40
        FC_trial = squeeze(data_temp(trail,:,:,:));
    
    for timepoint = 1:1:TN
         FC = squeeze(FC_trial(timepoint,:,:));
         FC = FC +FC'+eye(N);

         [FEC FE]=eig(FC);
         [Clus_num,Clus_size] = Functional_HP2(FC,N);

         [Hin,Hse,HF] =Balance(FC,N,Clus_size,Clus_num);

         allClus_size{timepoint} = Clus_size;
         allClus_num{timepoint} = Clus_num;

         x_balance_temp(timepoint) = Hin-Hse;
         x_Hin_temp(timepoint) = Hin;
         x_Hse_temp(timepoint) = Hse;

         H1=(diag(HF)*flipud((FEC.^2)'));

         IN_temp(timepoint,:) = H1(1,:);
         IM_temp(timepoint,:) = sum(H1(2:N,:));
         nodal_Balance_temp(timepoint,:) = H1(1,:)-sum(H1(2:N,:));
    end
    
    x_balance(trail,:) = x_balance_temp;
    x_Hin(trail,:) = x_Hin_temp;
    x_Hse(trail,:) = x_Hse_temp;
    
    IN(trail,:,:) = IN_temp; 
    IM(trail,:,:) = IM_temp;
    nodal_Balance(trail,:,:) = nodal_Balance_temp;
    
    end
     saveBALANCE = strcat('E:\0PhD\9\2022-example\DEAP\results\gamma_10\s',num2str(nSub),'_HP_gamma')
    save(saveBALANCE,'x_balance','x_Hin','x_Hse','IN','IM','nodal_Balance')
end