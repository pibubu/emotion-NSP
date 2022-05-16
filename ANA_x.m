%% 统计x轴上下面积和/切换频率/分离时间占比/方差/标准差
for nSub = 1:1:36
    
    fileName = strcat('E:\0PhD\9\2020-gonogo\BALANCE\beta\x & nodal\4\s',num2str(nSub),'_nodal_plv_beta')
    load(fileName)
    
    x_balance_plv_beta{nSub} = x_balance;
    x_Hse_plv_beta{nSub} = x_Hse;
    x_Hin_plv_beta{nSub} = x_Hin;
    
    nodal_balance_plv_beta{nSub} = nodal_Balance; 
    IN_plv_beta{nSub} = IN; 
    IM_plv_beta{nSub} = IM; 
end

%% 统计x_balance x轴上下面积和/切换频率/分离时间占比/方差/标准差;  x_Hin/Hse VAR/STD
for nSub = 1:1:36
        fileName = strcat('E:\0PhD\9\2020-gonogo\BALANCE\beta\x & nodal\4\s',num2str(nSub),'_nodal_plv_beta')
        load(fileName)
        
        t1 = size(x_balance,1);
for nEvent = 1:1:t1
        
        sig_E = squeeze(x_balance(nEvent,:));
        
        % 整合分离强度(可用方差/标准差表示)
        index1 = find(sig_E>0);
        sig_integration = abs(sig_E(index1)); 
        
        index2 = find(sig_E<0);
        sig_segregation = abs(sig_E(index2));    
        
        %
        bb_temp(nEvent)= sum(sig_integration)+sum(sig_segregation);

        
        % 切换频率
        x(find( sig_E<0 )) = -1;
        x(find( sig_E>0 )) = 1;
        x;
        
        
        N = size(x_balance,2);       
        m =0;
        for  n = 1:1:N-1
            if x(n) ~= x(n+1)
                m = m+1;
            else
                h=0;
            end
        end
        
        Fre_temp(nEvent) = m/N;   
        
        % 占用时间
        pre_seg_temp(nEvent) = size(sig_segregation)/size(sig_E);
        pre_int_temp(nEvent) = size(sig_integration)/size(sig_E);
        
        % 方差/标准差
        VAR_temp(nEvent) = var(sig_E,1);
        STD_temp(nEvent) = std(sig_E);
        
        % Hin
        sig_E1 = squeeze(x_Hin(nEvent,:));
        % 方差/标准差
        VAR_in_temp(nEvent) = var(sig_E1,1);
        STD_in_temp(nEvent) = std(sig_E1);
        
        % Hse
        sig_E2 = squeeze(x_Hse(nEvent,:));  
        % 方差/标准差
        VAR_se_temp(nEvent) = var(sig_E2,1);
        STD_se_temp(nEvent) = std(sig_E2);
    
end

bb{nSub} = bb_temp;
Fre{nSub} = Fre_temp;
prei{nSub} = pre_int_temp;
VAR{nSub} = VAR_temp;
STD{nSub} = STD_temp;
VAR_in{nSub} = VAR_in_temp;
STD_in{nSub} = STD_in_temp;
VAR_se{nSub} = VAR_se_temp;
STD_se{nSub} = STD_se_temp;

  clear x_Hin x_Hse x_Hin  bb_temp Fre_temp pre_int_temp pre_seg_temp sig_integration sig_segregation VAR_temp STD_temp STD_se_temp VAR_se_temp STD_in_temp VAR_in_temp sig_E sig_E1 sig_E2 x

end
 saveANA = strcat('E:\0PhD\9\2020-gonogo\BALANCE\beta\ANA\ANA_x_beta')
 save (saveANA,'VAR','STD','Fre','prei','bb','VAR_in','STD_in','VAR_se','STD_se')


 %% 分类求和 x_balance
for nSub =1:1:29
filename = strcat('E:\0PhD\9\2020-gonogo\data\type\3\',num2str(nSub),'.xlsx')  
new = xlsread(filename,'Sheet1');
    
bb_temp = bb{nSub} ;
Fre_temp = Fre{nSub};
pre_int_temp = prei{nSub} ;
VAR_temp = VAR{nSub} ;
STD_temp = STD{nSub} ;
VAR_in_temp = VAR_in{nSub} ;
STD_in_temp = STD_in{nSub} ;
VAR_se_temp = VAR_se{nSub};
STD_se_temp = STD_se{nSub};

    for type = 1:1:2
    nEvent_temp{type} = squeeze(new(:,type));
    nEvent_temp2 = nEvent_temp{type};
    z{type}= find(~isnan(nEvent_temp2));
    z2 = z{type};
    nEvent_temp{type} = nEvent_temp2(z2);
    nEvent = nEvent_temp{type} ;
    a = size(nEvent,1);
    
    T_fre = 0 ;T_prei = 0 ;T_var = 0;T_std = 0;  T_bb =0;     
    T_var_in = 0; T_std_in = 0; T_var_se = 0; T_std_se = 0;
    for i = 1:1:a
    b = nEvent(i);
    T_bb = bb_temp(b) + T_bb;    
    T_fre = Fre_temp(b) + T_fre;
    T_prei = pre_int_temp(b) + T_prei;
    T_var= VAR_temp(b) + T_var;
    T_std= STD_temp(b) + T_std;
    T_var_in= VAR_in_temp(b) + T_var_in;
    T_std_in= STD_in_temp(b) + T_std_in;
    T_var_se= VAR_se_temp(b) + T_var_se;
    T_std_se= STD_se_temp(b) + T_std_se;
    end

    F_bb(nSub,type) = T_bb/a;  
    F_fre(nSub,type) = T_fre/a;
    F_prei(nSub,type) = T_prei/a;
    F_var(nSub,type) = T_var/a;
    F_std(nSub,type) = T_std/a;
    F_var_in(nSub,type) = T_var_in/a;
    F_std_in(nSub,type) = T_std_in/a;
    F_var_se(nSub,type) = T_var_se/a;
    F_std_se(nSub,type) = T_std_se/a;

    end
    
    clear a b  flename i new nSub nEvent nEvent_temp nEvent_temp2 type z z2 
    clear bb_temp  Fre_temp pre_int_temp VAR_temp  STD_temp  VAR_in_temp  STD_in_temp VAR_se_temp  STD_se_temp 
end

saveANA = strcat('E:\0PhD\9\2020-gonogo\BALANCE\beta\ANA\3\2type_x_balance_beta')
save (saveANA,'F_bb','F_fre','F_prei','F_var','F_std','F_var_in','F_std_in','F_var_se','F_std_se')

%% 统计nodal_balance
for nSub = 1:1:36
        fileName = strcat('E:\0PhD\9\2020-gonogo\BALANCE\beta\x & nodal\4\s',num2str(nSub),'_nodal_plv_beta')
        load(fileName)
    t1 = size(x_balance,1);
for nEvent = 1:1:t1
        
        for timepoint = 1:1:566  
            sig_E_allnode(:,timepoint) = (nodal_Balance{nEvent,timepoint})';
            sig_E1_allnode(:,timepoint) = (IN{nEvent,timepoint})';
            sig_E2_allnode(:,timepoint) = (IM{nEvent,timepoint})';        
        end
        
        for numNode = 1:1:30
            sig_E = squeeze(sig_E_allnode(numNode,:));
        
            % 整合分离强度(可用方差/标准差表示)
            index1 = find(sig_E>0);
            sig_integration = abs(sig_E(index1)); 
            
            index2 = find(sig_E<0);
            sig_segregation = abs(sig_E(index2));    
            
            % x轴上下面积和
            bb_temp(nEvent,numNode)= sum(sig_integration)+sum(sig_segregation);
            
            % 切换频率
            x(find( sig_E<0 )) = -1;
            x(find( sig_E>0 )) = 1;
            x;       
            
            N = 566;       
            m =0;
            
            for  n = 1:1:N-1
                if x(n) ~= x(n+1)
                    m = m+1;
                else
                    h=0;
                end
            end
            
            Fre_temp(nEvent,numNode) = m/566;     
            
            % 占用时间
            pre_seg_temp(nEvent,numNode) = size(sig_segregation)/size(sig_E);
            pre_int_temp(nEvent,numNode) = size(sig_integration)/size(sig_E);
            
            % 方差/标准差
            VAR_temp(nEvent,numNode) = var(sig_E,1);
            STD_temp(nEvent,numNode) = std(sig_E);
            
            % Hin
            sig_E1 = squeeze(sig_E1_allnode(numNode,:));
            % 方差/标准差
            VAR_in_temp(nEvent,numNode) = var(sig_E1,1);
            STD_in_temp(nEvent,numNode) = std(sig_E1);
            
            % Hse
            sig_E2 = squeeze(sig_E2_allnode(numNode,:));  
            % 方差/标准差
            VAR_se_temp(nEvent,numNode) = var(sig_E2,1);
            STD_se_temp(nEvent,numNode) = std(sig_E2);
        
        end
end
bb{nSub} = bb_temp;
Fre{nSub} = Fre_temp;
prei{nSub} = pre_int_temp;
VAR{nSub} = VAR_temp;
STD{nSub} = STD_temp;
VAR_in{nSub} = VAR_in_temp;
STD_in{nSub} = STD_in_temp;
VAR_se{nSub} = VAR_se_temp;
STD_se{nSub} = STD_se_temp;    

end

 saveANA = strcat('E:\0PhD\9\2020-gonogo\BALANCE\beta\ANA\ANA_nodal_beta')
 save (saveANA,'bb','Fre','prei','VAR','STD','VAR_in','STD_in','VAR_se','STD_se')

 %% 分类求和 nodal_balance
for  nSub = 1:1:29
filename = strcat('E:\0PhD\9\2020-gonogo\data\type\3\',num2str(nSub),'.xlsx')  
new = xlsread(filename,'Sheet1');

bb_temp = bb{nSub} ;
Fre_temp = Fre{nSub};
pre_int_temp = prei{nSub} ;
VAR_temp = VAR{nSub} ;
STD_temp = STD{nSub} ;
VAR_in_temp = VAR_in{nSub} ;
STD_in_temp = STD_in{nSub} ;
VAR_se_temp = VAR_se{nSub};
STD_se_temp = STD_se{nSub};
    
    for type = 1:1:2
    nEvent_temp{type} = squeeze(new(:,type));
    nEvent_temp2 = nEvent_temp{type};
    z{type}= find(~isnan(nEvent_temp2));
    z2 = z{type};
    nEvent_temp{type} = nEvent_temp2(z2);
    nEvent = nEvent_temp{type} ;
    a = size(nEvent,1);
    
    T_fre = zeros(1,30) ;T_prei = zeros(1,30) ;T_var =zeros(1,30);T_std = zeros(1,30);  T_bb =zeros(1,30);     
    T_var_in = zeros(1,30); T_std_in = zeros(1,30); T_var_se = zeros(1,30); T_std_se = zeros(1,30);
    for i = 1:1:a
    b = nEvent(i);
    T_bb = squeeze(bb_temp(b,:)) + T_bb;    
    T_fre = squeeze(Fre_temp(b,:)) + T_fre;
    T_prei = squeeze(pre_int_temp(b,:)) + T_prei;
    T_var= squeeze(VAR_temp(b,:)) + T_var;
    T_std= squeeze(STD_temp(b,:)) + T_std;
    T_var_in= squeeze(VAR_in_temp(b,:)) + T_var_in;
    T_std_in= squeeze(STD_in_temp(b,:)) + T_std_in;
    T_var_se= squeeze(VAR_se_temp(b,:)) + T_var_se;
    T_std_se= squeeze(STD_se_temp(b,:)) + T_std_se;
    end

    F_bb(nSub,type,:) = T_bb/a;  
    F_fre(nSub,type,:) = T_fre/a;
    F_prei(nSub,type,:) = T_prei/a;
    F_var(nSub,type,:) = T_var/a;
    F_std(nSub,type,:) = T_std/a;
    F_var_in(nSub,type,:) = T_var_in/a;
    F_std_in(nSub,type,:) = T_std_in/a;
    F_var_se(nSub,type,:) = T_var_se/a;
    F_std_se(nSub,type,:) = T_std_se/a;

    end
    
    clear a b  flename i new nSub nEvent nEvent_temp nEvent_temp2 type z z2 
    clear bb_temp  Fre_temp pre_int_temp VAR_temp  STD_temp  VAR_in_temp  STD_in_temp VAR_se_temp  STD_se_temp 
end

saveANA = strcat('E:\0PhD\9\2020-gonogo\BALANCE\beta\ANA\3\2type_nodal_balance_beta')
save (saveANA,'F_bb','F_fre','F_prei','F_var','F_std','F_var_in','F_std_in','F_var_se','F_std_se')