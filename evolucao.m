function [mV,mB,mF,mS]=evolucao(MV,MB,MF,MS,C,T,IC,dT,H,pH,pP,E,F,...
    nex,ney,pts,V2Hv,V2Hb,V2Hf,V2Hs,V1,V2,dV,Hb,Hf,Hs,IE,Ms,Mc,M_tmb,M_tmf)
% Programa para evoluir o cenário no tempo. 
% 
% Variáveis de entrada consideradas para esta simulação:
%           >> HERBIVORIA por espécie e estrutura, com aleatoriedade LOCAL
%           >> POLINIZAÇÃO por espécie, com aleatoriedade LOCAL
%           >> AUTOFECUNDAÇÃO por espécie, com aleatoriedade LOCAL
%           >> CHUVAS por espécie, com aleatoriedade NA BASELINE
%           >> FLORADA por espécie, com aleatoriedade NA BASELINE
% 
% Variáveis de saída consideradas para esta simulação:
%           >> FOLHAS - Quant. de matéria vegetal na planta
%           >> BOTÕES - Quant. de botões florais na planta
%           >> FLORES - Quant. de flores na planta
%           >> FRUTOS - Quant. de frutos produzidos por planta
% 
% Baseado na oscilação medida em campo, a cada iteração é estimado um valor
% para cada variável, e este valor é aplicado nas matrizes de folhas,
% botões, flores e sementes, guardando as devidas especificidades. Estas
% oscilações são estimadas de acordo com dados reais, acrescidos de
% flutuações aleatórias, como feito em todo o programa.
% 
% Ordem adotada: 'Malifolia','Peixotoa','Laevifolia','Campestris'

%% DECLARAÇÃO DAS VARIÁVEIS DE SAÍDA
mV=zeros(dT*T,4);mB=mV;mF=mV;mS=mV;
tranfer_BF=zeros(nex,ney,4);
tranfer_FS=tranfer_BF;
transfer_frutos=tranfer_BF;
contador_anual=1;
V2_new=V2;
% h = waitbar(0,'Solving the model...');
% interface_post

%% LOOP PRINCIPAL
for i=1:dT*T
    
    %% CAPTURA DE RESPOSTA ================================================
    
    % Conta quantos são os elementos não-nulos
    
    %FOLHAS
    tv1=length(find(MV(:,:,1))); tv2=length(find(MV(:,:,2)));
    tv3=length(find(MV(:,:,3))); tv4=length(find(MV(:,:,4)));
    %BOTÕES
    tb1=length(find(MV(:,:,1))); tb2=length(find(MV(:,:,2)));
    tb3=length(find(MV(:,:,3))); tb4=length(find(MV(:,:,4)));
    %FLORES
    tf1=length(find(MV(:,:,1))); tf2=length(find(MV(:,:,2)));
    tf3=length(find(MV(:,:,3))); tf4=length(find(MV(:,:,4)));
    %FRUTOS
    ts1=length(find(MV(:,:,1))); ts2=length(find(MV(:,:,2)));
    ts3=length(find(MV(:,:,3))); ts4=length(find(MV(:,:,4)));
    
    % Faz a média das respostas nos elementos não nulos
    
    %FOLHAS
    mV(i,1)=sum(sum(MV(:,:,1)))/tv1; mV(i,2)=sum(sum(MV(:,:,2)))/tv2;
    mV(i,3)=sum(sum(MV(:,:,3)))/tv3; mV(i,4)=sum(sum(MV(:,:,4)))/tv4;
    %BOTÕES
    mB(i,1)=sum(sum(MB(:,:,1)))/tb1; mB(i,2)=sum(sum(MB(:,:,2)))/tb2;
    mB(i,3)=sum(sum(MB(:,:,3)))/tb3; mB(i,4)=sum(sum(MB(:,:,4)))/tb4;
    %FLORES
    mF(i,1)=sum(sum(MF(:,:,1)))/tf1; mF(i,2)=sum(sum(MF(:,:,2)))/tf2;
    mF(i,3)=sum(sum(MF(:,:,3)))/tf3; mF(i,4)=sum(sum(MF(:,:,4)))/tf4;
    %FRUTOS
    mS(i,1)=sum(sum(MS(:,:,1)))/ts1; mS(i,2)=sum(sum(MS(:,:,2)))/ts2;
    mS(i,3)=sum(sum(MS(:,:,3)))/ts3; mS(i,4)=sum(sum(MS(:,:,4)))/ts4;
    
    
    %% HERBIVORIA =========================================================
    
    %Geração da matriz booleana aleatória de herbivoria
    naH=round(nex*ney*pH);          
    kick=[rand(1,naH);rand(1,naH)]';
    kick(:,1)=kick(:,1)*(nex-1);    
    kick(:,2)=kick(:,2)*(ney-1);
    kick=round(kick)+1;             
    MH=zeros(nex,ney);
    
    Mh=ones(nex,ney);
    for j=1:naH
        MH(kick(j,1),kick(j,2))=Mh(kick(j,1),kick(j,2));
    end
    
    
    %% POLINIZAÇÃO ========================================================
    
    %Geração da matriz booleana aleatória de polinização
    naP=round(nex*ney*pP);          
    kick=[rand(1,naP);rand(1,naP)]';
    kick(:,1)=kick(:,1)*(nex-1);    
    kick(:,2)=kick(:,2)*(ney-1);
    kick=round(kick)+1;             
    MP=zeros(nex,ney);
    
    Mp=ones(nex,ney);
    for j=1:naP
        MP(kick(j,1),kick(j,2))=Mp(kick(j,1),kick(j,2));
    end
    
    
    %% FOLHAS =============================================================
    
    for m=1:4
        
        %Determinação da herbivoria por espécie
        MHv=MH.*(H(m) + rand(nex,ney)*V2Hv);
        
        %Equação que rege a quantidade elementar de folhas
        MV(:,:,m)=MV(:,:,m)+...                         %o que tinha
            MV(:,:,m).*(-MHv+C(i)*IC(m)+E(i,m)*IE(m));  %variação

        %Aplica os limites do domínio do modelo
        for j=1:nex
            for k=1:ney
                if MV(j,k,m)>1
                    MV(j,k,m)=1;
                end
                if MV(j,k,m)<1E-9
                    MV(j,k,m)=0;
                end
            end
        end
    end
    
    
    %% BOTÕES =============================================================
    
    for m=1:4
        
        %Determinação da herbivoria por espécie
        MHb=MH.*(Hb(m) + rand(nex,ney)*V2Hb);
        
        %Quantidade de flores formadas na semana 'i'
        tranfer_BF(:,:,m)=(MB(:,:,m)/2)*M_tmb(m);
        
        %Equação que rege a quantidade elementar de botões
        MB(:,:,m)=MB(:,:,m)+...         %o que tinha
            MB(:,:,m).*(-MHb)+...       %o que sai por herbivoria
            F(i,m)*MV(:,:,m)-...        %o que vem da florada
            tranfer_BF(:,:,m);          %o que vira flor

        %Aplica os limites do domínio do modelo
        for j=1:nex
            for k=1:ney
                if MB(j,k,m)<1E-9
                    MB(j,k,m)=0;
                end
            end
        end
    end
    
    
    %% FLORES =============================================================
    
    for m=1:4
        
        %Determinação da herbivoria instantânea, CONSIDERANDO INTERAÇÃO
        total_flowering=mF(i,1)+mF(i,2)+mF(i,3)+mF(i,4);
        MHf=MH.*(Hf(m) + rand(nex,ney)*V2Hf);
        if total_flowering > 1
            MHf=MHf/total_flowering;
        end
        
        %Ajuste da matriz de autofecundação
        MAi=MP*V1(m)*Ms(m);
        
        %Ajuste da matriz de polinização, CONSIDERANDO INTERAÇÃO
        if total_flowering > 1
            V2_new(m)=V2(m)/total_flowering;
            MPi=MP*V2_new(m)*Mc(m);
        elseif total_flowering <= 1
            MPi=MP*V2(m)*Mc(m);
        end
        
        %Quantidade de frutos formadas na semana 'i'
        tranfer_FS(:,:,m)=MF(:,:,m).*(dV(m)*rand(nex,ney) + MPi + MAi);
        
        %Equação que rege a quantidade elementar de flores
        MF(:,:,m)= MF(:,:,m)+...                      %o que tinha
            MF(:,:,m).*(-MHf)-tranfer_FS(:,:,m)+...   %a variação
            tranfer_BF(:,:,m);                        %o que vem dos botões

        %Aplica os limites do domínio do modelo
        for j=1:nex
            for k=1:ney
                if MF(j,k,m)<1E-9
                    MF(j,k,m)=0;
                end
            end
        end
    end
    
    
    %% FRUTOS =============================================================
    
    for m=1:4
        
        %Determinação da herbivoria instantânea
        MHs=MH.*(Hs(m) + rand(nex,ney)*V2Hs);
        
        %Quantidade de frutos viáveis formados na semana 'i'
        transfer_frutos(:,:,m)=(MS(:,:,m)/3)*M_tmf(m);
        
        %Equação que rege a quantidade elementar de sementes
        MS(:,:,m)=MS(:,:,m)+...                 %o que tinha
            MS(:,:,m).*(-MHs)+...               %herbivorado
            tranfer_FS(:,:,m)-...               %o que vem das flores
            transfer_frutos(:,:,m);             %o que cai e nasce
        
        %Aplica os limites do domínio do modelo
        for j=1:nex
            for k=1:ney
                if MS(j,k,m)<1E-9
                    MS(j,k,m)=0;
                end
            end
        end
    end
    

    %% PLOTA O CENÁRIO ATUAL
    
    if pts==1
        plot_cerrado(MV,MB,MF,MS,C,nex,ney,T,dT,i,contador_anual)
    end
    
    
    %% CONTROLE DO LOOP
    
    if i==dT*contador_anual;
        contador_anual=contador_anual+1;
    end
%     waitbar(contador_anual/(T)) %plota a barra de progresso
    
    
end
% close(h)















