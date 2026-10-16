function [Erro,Erro_Quad,Rms,Rsk,Rku,RmsE,RskE,RkuE,INT,INT_EQ,Eperc,...
    E_Rms,E_Rsk,E_Rku]=resposta_stat(mV_full,mB_full,mF_full,mS_full,...
    cV,cB,cF,cS,T,dT,flag3,flag4,flag9)
% Calcula estatísticas entre as curvas de Folhas, Botões, Flores e
% Frutos,  simuladas e reais. Calcula também a integral abaixo das curvas
% de Folhas, Botões, Flores e Frutos, tanto das curvas simuladas e das
% curvas reais medidas em campo. Resumindo:
%
% >> Desvio quadrático médio entre as curvas, STD
% >> Desvio médio quadrático, Rms
% >> Skewness, Rsk
% >> Kurtosis, Rku
% >> Integral, método dos trapézios
%
% Estes parâmetros são usualmente usados para comparar superfícies de
% materiais, usados em tribologia, e serão usados aqui de maneira similar,
% para comparar curvas reais e simuladas.

%% CASO DE UM CICLO TÍPICO ================================================
if flag9==1
    
    %% Startup
    n=dT;
    
    mV(:,1)=mV_full(dT+1:2*dT,1);       mV(:,2)=mV_full(dT+1:2*dT,2);
    mV(:,3)=mV_full(dT+1:2*dT,3);       mV(:,4)=mV_full(dT+1:2*dT,4);
    
    mB(:,1)=mB_full(dT+1:2*dT,1);       mB(:,2)=mB_full(dT+1:2*dT,2);
    mB(:,3)=mB_full(dT+1:2*dT,3);       mB(:,4)=mB_full(dT+1:2*dT,4);
    
    mF(:,1)=mF_full(dT+1:2*dT,1);       mF(:,2)=mF_full(dT+1:2*dT,2);
    mF(:,3)=mF_full(dT+1:2*dT,3);       mF(:,4)=mF_full(dT+1:2*dT,4);
    
    mS(:,1)=mS_full(dT+1:2*dT,1);       mS(:,2)=mS_full(dT+1:2*dT,2);
    mS(:,3)=mS_full(dT+1:2*dT,3);       mS(:,4)=mS_full(dT+1:2*dT,4);
    
    %% Entra dados reais de campo
    mVE(:,1)=cV(dT+1:2*dT,1);       mVE(:,2)=cV(dT+1:2*dT,2);
    mVE(:,3)=cV(dT+1:2*dT,3);       mVE(:,4)=cV(dT+1:2*dT,4);
    
    mBE(:,1)=cB(dT+1:2*dT,1);       mBE(:,2)=cB(dT+1:2*dT,2);
    mBE(:,3)=cB(dT+1:2*dT,3);       mBE(:,4)=cB(dT+1:2*dT,4);
    
    mFE(:,1)=cF(dT+1:2*dT,1);       mFE(:,2)=cF(dT+1:2*dT,2);
    mFE(:,3)=cF(dT+1:2*dT,3);       mFE(:,4)=cF(dT+1:2*dT,4);
    
    mSE(:,1)=cS(dT+1:2*dT,1);       mSE(:,2)=cS(dT+1:2*dT,2);
    mSE(:,3)=cS(dT+1:2*dT,3);       mSE(:,4)=cS(dT+1:2*dT,4);
    
    %% Desvio roots mean squared (Rms) - nos dados reais
    E2V=sum(mVE.^2);RmsV=sqrt((1/n).*(E2V));
    E2B=sum(mBE.^2);RmsB=sqrt((1/n).*(E2B));
    E2F=sum(mFE.^2);RmsF=sqrt((1/n).*(E2F));
    E2S=sum(mSE.^2);RmsS=sqrt((1/n).*(E2S));
    RmsE=[RmsV;RmsB;RmsF;RmsS];
    
    %% Skewness (Rsk) - nos dados reais
    E3V=sum(mVE.^3);RskV=(1./(n*RmsV.^3)).*(E3V);
    E3B=sum(mBE.^3);RskB=(1./(n*RmsB.^3)).*(E3B);
    E3F=sum(mFE.^3);RskF=(1./(n*RmsF.^3)).*(E3F);
    E3S=sum(mSE.^3);RskS=(1./(n*RmsS.^3)).*(E3S);
    RskE=[RskV;RskB;RskF;RskS];
    
    %% Kurtosis (Rku) - nos dados reais
    E4V=sum(mVE.^4);RkuV=(1./(n*RmsV.^4)).*(E4V);
    E4B=sum(mBE.^4);RkuB=(1./(n*RmsB.^4)).*(E4B);
    E4F=sum(mFE.^4);RkuF=(1./(n*RmsF.^4)).*(E4F);
    E4S=sum(mSE.^4);RkuS=(1./(n*RmsS.^4)).*(E4S);
    RkuE=[RkuV;RkuB;RkuF;RkuS];
    
    %% Desvio roots mean squared (Rms) - nos dados simulados
    E2V=sum(mV.^2);RmsV=sqrt((1/n).*(E2V));
    E2B=sum(mB.^2);RmsB=sqrt((1/n).*(E2B));
    E2F=sum(mF.^2);RmsF=sqrt((1/n).*(E2F));
    E2S=sum(mS.^2);RmsS=sqrt((1/n).*(E2S));
    Rms=[RmsV;RmsB;RmsF;RmsS];
    
    %% Skewness (Rsk) - nos dados simulados
    E3V=sum(mV.^3);RskV=(1./(n*RmsV.^3)).*(E3V);
    E3B=sum(mB.^3);RskB=(1./(n*RmsB.^3)).*(E3B);
    E3F=sum(mF.^3);RskF=(1./(n*RmsF.^3)).*(E3F);
    E3S=sum(mS.^3);RskS=(1./(n*RmsS.^3)).*(E3S);
    Rsk=[RskV;RskB;RskF;RskS];
    
    %% Kurtosis (Rku) - nos dados simulados
    E4V=sum(mV.^4);RkuV=(1./(n*RmsV.^4)).*(E4V);
    E4B=sum(mB.^4);RkuB=(1./(n*RmsB.^4)).*(E4B);
    E4F=sum(mF.^4);RkuF=(1./(n*RmsF.^4)).*(E4F);
    E4S=sum(mS.^4);RkuS=(1./(n*RmsS.^4)).*(E4S);
    Rku=[RkuV;RkuB;RkuF;RkuS];
    
    %% Erros entre Rms, Rsk, Rku reais e simulados
    E_Rms=abs(Rms-RmsE)./Rms*100;
    E_Rsk=abs(Rsk-RskE)./Rsk*100;
    E_Rku=abs(Rku-RkuE)./Rku*100;
    
    %% Integrais das curvas - nos dados simulados
    
    % FOLHAS
    INTv(1)=(trapz(mV(:,1)));
    INTv(2)=(trapz(mV(:,2)));
    INTv(3)=(trapz(mV(:,3)));
    INTv(4)=(trapz(mV(:,4)));
    
    % BOTÕES
    INTb(1)=(trapz(mB(:,1)));
    INTb(2)=(trapz(mB(:,2)));
    INTb(3)=(trapz(mB(:,3)));
    INTb(4)=(trapz(mB(:,4)));
    
    % FLORES
    INTf(1)=(trapz(mF(:,1)));
    INTf(2)=(trapz(mF(:,2)));
    INTf(3)=(trapz(mF(:,3)));
    INTf(4)=(trapz(mF(:,4)));
    
    % SEMENTES
    INTs(1)=(trapz(mS(:,1)));
    INTs(2)=(trapz(mS(:,2)));
    INTs(3)=(trapz(mS(:,3)));
    INTs(4)=(trapz(mS(:,4)));
    
    % Monta tudo num vetor resposta
    INT=[INTv;INTb;INTf;INTs];
    
    %% Calcula o erro e erro quadrático entre a curva simulada e a baseline
    %% experimental, medida no campo, não usada na criação desta simulação.
    
    % ERRO
    ev=mV-mVE;
    eb=mB-mBE;
    ef=mF-mFE;
    es=mS-mSE;
    Erro=[ev';eb';ef';es'];
    
    % ERRO QUADRÁTICO
    evq=ev.^2;
    ebq=eb.^2;
    efq=ef.^2;
    esq=es.^2;
    Erro_Quad=[evq';ebq';efq';esq'];
    
    %% Integrais dos erros quadráticos, para estimar a magnitude percentual do
    %% erro em relação os dados originais.
    
    % FOLHAS
    INT_EQv(1)=(trapz(evq(:,1)));
    INT_EQv(2)=(trapz(evq(:,2)));
    INT_EQv(3)=(trapz(evq(:,3)));
    INT_EQv(4)=(trapz(evq(:,4)));
    
    % BOTÕES
    INT_EQb(1)=(trapz(ebq(:,1)));
    INT_EQb(2)=(trapz(ebq(:,2)));
    INT_EQb(3)=(trapz(ebq(:,3)));
    INT_EQb(4)=(trapz(ebq(:,4)));
    
    % FLORES
    INT_EQf(1)=(trapz(efq(:,1)));
    INT_EQf(2)=(trapz(efq(:,2)));
    INT_EQf(3)=(trapz(efq(:,3)));
    INT_EQf(4)=(trapz(efq(:,4)));
    
    % SEMENTES
    INT_EQs(1)=(trapz(esq(:,1)));
    INT_EQs(2)=(trapz(esq(:,2)));
    INT_EQs(3)=(trapz(esq(:,3)));
    INT_EQs(4)=(trapz(esq(:,4)));
    
    % Monta tudo num vetor resposta
    INT_EQ=[INT_EQv;INT_EQb;INT_EQf;INT_EQs];
    
    
    %% Cálculo do erro percentual da simulação
    
    % (Eperc%)=(1-(INT-INT_EQ)/(INT))*100
    Eperc=(1-(INT-INT_EQ)./INT)*100;
    
    if flag3==1
        
        % =========================================================================
        % SUBPLOT - Plota os erros
        % =========================================================================
        
        % standardized colors
        deepBlue = [0, 0, 139] / 255;
        darkOran = [230, 159, 0] / 255;
        tealGree = [0, 158, 115] / 255;
        crimsonR = [213, 94, 0] / 255;
        
        %% FOLHAS
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(ev(:,1),'color',deepBlue,'linewidth',2);hold on;
        plot(ev(:,2),'color',darkOran,'linewidth',2);
        plot(ev(:,3),'color',tealGree,'linewidth',2);
        plot(ev(:,4),'color',crimsonR,'linewidth',2);hold off;grid on;
        set(gca,'XTick',0:48:length(mV(:,1)));xlim([0,240]);ylim([0,1])
        title('Foliage error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        
        
        %% BOTÕES
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(eb(:,1),'color',deepBlue,'linewidth',2);hold on;
        plot(eb(:,2),'color',darkOran,'linewidth',2);
        plot(eb(:,3),'color',tealGree,'linewidth',2);
        plot(eb(:,4),'color',crimsonR,'linewidth',2);hold off;grid on;
        set(gca,'XTick',0:48:length(mV(:,1)));xlim([0,240]);ylim([0,1])
        title('Floral buds error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        
        
        %% FLORES
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(ef(:,1),'color',deepBlue,'linewidth',2);hold on;
        plot(ef(:,2),'color',darkOran,'linewidth',2);
        plot(ef(:,3),'color',tealGree,'linewidth',2);
        plot(ef(:,4),'color',crimsonR,'linewidth',2);hold off;grid on;
        set(gca,'XTick',0:48:length(mV(:,1)));xlim([0,240]);ylim([0,1])
        title('Flowers error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        
        %% SEMENTES
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(es(:,1),'color',deepBlue,'linewidth',2);hold on;
        plot(es(:,2),'color',darkOran,'linewidth',2);
        plot(es(:,3),'color',tealGree,'linewidth',2);
        plot(es(:,4),'color',crimsonR,'linewidth',2);hold off;grid on;
        set(gca,'XTick',0:48:length(mV(:,1)));xlim([0,240]);ylim([0,1])
        title('Fruits error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        
        % =========================================================================
        % SUBPLOT - Plota os erros quadráticos
        % =========================================================================
        
        %% BOTÕES
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(ebq(:,1),'color',deepBlue,'linewidth',2);hold on;
        plot(ebq(:,2),'color',darkOran,'linewidth',2);
        plot(ebq(:,3),'color',tealGree,'linewidth',2);
        plot(ebq(:,4),'color',crimsonR,'linewidth',2);hold off;grid on;
        set(gca,'XTick',0:48:length(mV(:,1)))
        set(gca,'XTick',0:48:length(mV(:,1)));xlim([0,240]);ylim([0,1])
        title('Floral buds quadratic error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        
        
        %% FLORES
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(efq(:,1),'color',deepBlue,'linewidth',2);hold on;
        plot(efq(:,2),'color',darkOran,'linewidth',2);
        plot(efq(:,3),'color',tealGree,'linewidth',2);
        plot(efq(:,4),'color',crimsonR,'linewidth',2);hold off;grid on;
        set(gca,'XTick',0:48:length(mV(:,1)));xlim([0,240]);ylim([0,1])
        title('Flowers quadratic error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        
        
        %% SEMENTES
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(esq(:,1),'color',deepBlue,'linewidth',2);hold on;
        plot(esq(:,2),'color',darkOran,'linewidth',2);
        plot(esq(:,3),'color',tealGree,'linewidth',2);
        plot(esq(:,4),'color',crimsonR,'linewidth',2);hold off;grid on;
        set(gca,'XTick',0:48:length(mV(:,1)));xlim([0,240]);ylim([0,1])
        title('Fruits quadratic error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        
    end
    if flag4==1
        
        % =========================================================================
        % SUBPLOT - Plota a curva real e a simulada para comparação
        % =========================================================================
        
        %correção dos pontos final e inicial
        mB(1,:)=0; mB(end,:)=0; mF(1,:)=0; mF(end,:)=0; mS(1,:)=0; mS(end,:)=0;
        mBE(1,:)=0;mBE(end,:)=0;mFE(1,:)=0;mFE(end,:)=0;mSE(1,:)=0;mSE(end,:)=0;
        
        % MALIFOLIA ===============================================================
        figure;
        subplot(3,1,1);fill([(1:dT)';((1:dT)')],...
            [mB(:,1);mBE(:,1)],[.7 .7 .7]);hold on;
        subplot(3,1,1);plot((1:dT),[mB(:,1),(mBE(:,1))],...
            'linewidth',2);hold off;set(gca,'XTick',0:dT:dT)
        title('Malifolia floral buds error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        legend('Malifolia','Simulation','Mean field Data','location','northeast')
        
        subplot(3,1,2);fill([(1:dT)';((1:dT)')],...
            [mF(:,1);mFE(:,1)],[.7 .7 .7]);hold on;
        subplot(3,1,2);plot((1:dT),[mF(:,1),(mFE(:,1))],...
            'linewidth',2);hold off;set(gca,'XTick',0:dT:dT)
        title('Malifolia flowers error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        subplot(3,1,3);fill([(1:dT)';((1:dT)')],...
            [mS(:,1);mSE(:,1)],[.7 .7 .7]);hold on;
        subplot(3,1,3);plot((1:dT),[mS(:,1),(mSE(:,1))],...
            'linewidth',2);hold off;set(gca,'XTick',0:dT:(dT*T))
        title('Malifolia fruits error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        % PEIXOTOA ================================================================
        figure;
        subplot(3,1,1);fill([(1:dT)';((1:dT)')],...
            [mB(:,2);mBE(:,2)],[.7 .7 .7]);hold on;
        subplot(3,1,1);plot((1:dT),[mB(:,2),(mBE(:,2))],...
            'linewidth',2);hold off;set(gca,'XTick',0:dT:dT)
        title('Peixotoa floral buds error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        legend('Peixotoa','Simulation','Mean field Data','location','northeast')
        
        subplot(3,1,2);fill([(1:dT)';((1:dT)')],...
            [mF(:,2);mFE(:,2)],[.7 .7 .7]);hold on;
        subplot(3,1,2);plot((1:dT),[mF(:,2),(mFE(:,2))],...
            'linewidth',2);hold off;set(gca,'XTick',0:dT:dT)
        title('Peixotoa flowers error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        subplot(3,1,3);fill([(1:dT)';((1:dT)')],...
            [mS(:,2);mSE(:,2)],[.7 .7 .7]);hold on;
        subplot(3,1,3);plot((1:dT),[mS(:,2),(mSE(:,2))],...
            'linewidth',2);hold off;set(gca,'XTick',0:dT:dT)
        title('Peixotoa fruits error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        % LAEVIFOLIA ==============================================================
        figure;
        subplot(3,1,1);fill([(1:dT)';((1:dT)')],...
            [mB(:,3);mBE(:,3)],[.7 .7 .7]);hold on;
        subplot(3,1,1);plot((1:dT),[mB(:,3),(mBE(:,3))],...
            'linewidth',2);hold off;set(gca,'XTick',0:dT:dT)
        title('Laevifolia floral buds error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        legend('Laevifolia','Simulation','Mean field Data','location','northeast')
        
        subplot(3,1,2);fill([(1:dT)';((1:dT)')],...
            [mF(:,3);mFE(:,3)],[.7 .7 .7]);hold on;
        subplot(3,1,2);plot((1:dT),[mF(:,3),(mFE(:,3))],...
            'linewidth',2);hold off;set(gca,'XTick',0:dT:dT)
        title('Laevifolia flowers error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        subplot(3,1,3);fill([(1:dT)';((1:dT)')],...
            [mS(:,3);mSE(:,3)],[.7 .7 .7]);hold on;
        subplot(3,1,3);plot((1:dT),[mS(:,3),(mSE(:,3))],...
            'linewidth',2);hold off;set(gca,'XTick',0:dT:dT)
        title('Laevifolia fruits error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        % CAMPESTRIS ==============================================================
        figure;
        subplot(3,1,1);fill([(1:dT)';((1:dT)')],...
            [mB(:,4);mBE(:,4)],[.7 .7 .7]);hold on;
        subplot(3,1,1);plot((1:dT),[mB(:,4),(mBE(:,4))],...
            'linewidth',2);hold off;set(gca,'XTick',0:dT:dT)
        title('Campestris floral buds error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        legend('Campestris','Simulation','Mean field Data','location','northeast')
        
        subplot(3,1,2);fill([(1:dT)';((1:dT)')],...
            [mF(:,4);mFE(:,4)],[.7 .7 .7]);hold on;
        subplot(3,1,2);plot((1:dT),[mF(:,4),(mFE(:,4))],...
            'linewidth',2);hold off;set(gca,'XTick',0:dT:dT)
        title('Campestris flowers error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        subplot(3,1,3);fill([(1:dT)';((1:dT)')],...
            [mS(:,4);mSE(:,4)],[.7 .7 .7]);hold on;
        subplot(3,1,3);plot((1:dT),[mS(:,4),(mSE(:,4))],...
            'linewidth',2);hold off;set(gca,'XTick',0:dT:dT)
        title('Campestris fruits error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
    end
    
    
    %% CASO DE TODOS OS CICLOS COMPLETOS ======================================
elseif flag9==0
    
    %% Startup
    n=length(mV_full);
    
    %% Entra dados reais de campo
    mVE=cV;
    mBE=cB;
    mFE=cF;
    mSE=cS;
    
    %% Desvio roots mean squared (Rms) - nos dados reais
    E2V=sum(mVE.^2);RmsV=sqrt((1/n).*(E2V));
    E2B=sum(mBE.^2);RmsB=sqrt((1/n).*(E2B));
    E2F=sum(mFE.^2);RmsF=sqrt((1/n).*(E2F));
    E2S=sum(mSE.^2);RmsS=sqrt((1/n).*(E2S));
    RmsE=[RmsV;RmsB;RmsF;RmsS];
    
    %% Skewness (Rsk) - nos dados reais
    E3V=sum(mVE.^3);RskV=(1./(n*RmsV.^3)).*(E3V);
    E3B=sum(mBE.^3);RskB=(1./(n*RmsB.^3)).*(E3B);
    E3F=sum(mFE.^3);RskF=(1./(n*RmsF.^3)).*(E3F);
    E3S=sum(mSE.^3);RskS=(1./(n*RmsS.^3)).*(E3S);
    RskE=[RskV;RskB;RskF;RskS];
    
    %% Kurtosis (Rku) - nos dados reais
    E4V=sum(mVE.^4);RkuV=(1./(n*RmsV.^4)).*(E4V);
    E4B=sum(mBE.^4);RkuB=(1./(n*RmsB.^4)).*(E4B);
    E4F=sum(mFE.^4);RkuF=(1./(n*RmsF.^4)).*(E4F);
    E4S=sum(mSE.^4);RkuS=(1./(n*RmsS.^4)).*(E4S);
    RkuE=[RkuV;RkuB;RkuF;RkuS];
    
    %% Desvio roots mean squared (Rms)
    E2V=sum(mV_full.^2);RmsV=sqrt((1/n).*(E2V));
    E2B=sum(mB_full.^2);RmsB=sqrt((1/n).*(E2B));
    E2F=sum(mF_full.^2);RmsF=sqrt((1/n).*(E2F));
    E2S=sum(mS_full.^2);RmsS=sqrt((1/n).*(E2S));
    Rms=[RmsV;RmsB;RmsF;RmsS];
    
    %% Skewness (Rsk)
    E3V=sum(mV_full.^3);RskV=(1./(n*RmsV.^3)).*(E3V);
    E3B=sum(mB_full.^3);RskB=(1./(n*RmsB.^3)).*(E3B);
    E3F=sum(mF_full.^3);RskF=(1./(n*RmsF.^3)).*(E3F);
    E3S=sum(mS_full.^3);RskS=(1./(n*RmsS.^3)).*(E3S);
    Rsk=[RskV;RskB;RskF;RskS];
    
    %% Kurtosis (Rku)
    E4V=sum(mV_full.^4);RkuV=(1./(n*RmsV.^4)).*(E4V);
    E4B=sum(mB_full.^4);RkuB=(1./(n*RmsB.^4)).*(E4B);
    E4F=sum(mF_full.^4);RkuF=(1./(n*RmsF.^4)).*(E4F);
    E4S=sum(mS_full.^4);RkuS=(1./(n*RmsS.^4)).*(E4S);
    Rku=[RkuV;RkuB;RkuF;RkuS];
    
    %% Erros entre Rms, Rsk, Rku reais e simulados
    E_Rms=abs(Rms-RmsE)./Rms*100;
    E_Rsk=abs(Rsk-RskE)./Rsk*100;
    E_Rku=abs(Rku-RkuE)./Rku*100;
    
    %% Integrais das curvas
    
    % FOLHAS
    INTv(1)=(trapz(mV_full(:,1)));
    INTv(2)=(trapz(mV_full(:,2)));
    INTv(3)=(trapz(mV_full(:,3)));
    INTv(4)=(trapz(mV_full(:,4)));
    
    % BOTÕES
    INTb(1)=(trapz(mB_full(:,1)));
    INTb(2)=(trapz(mB_full(:,2)));
    INTb(3)=(trapz(mB_full(:,3)));
    INTb(4)=(trapz(mB_full(:,4)));
    
    % FLORES
    INTf(1)=(trapz(mF_full(:,1)));
    INTf(2)=(trapz(mF_full(:,2)));
    INTf(3)=(trapz(mF_full(:,3)));
    INTf(4)=(trapz(mF_full(:,4)));
    
    % SEMENTES
    INTs(1)=(trapz(mS_full(:,1)));
    INTs(2)=(trapz(mS_full(:,2)));
    INTs(3)=(trapz(mS_full(:,3)));
    INTs(4)=(trapz(mS_full(:,4)));
    
    % Monta tudo num vetor resposta
    INT=[INTv;INTb;INTf;INTs];
    
    %% Calcula o erro e erro quadrático entre a curva simulada e a baseline
    %% experimental, medida no campo, não usada na criação desta simulação.
    
    % ERRO
    ev=mV_full-mVE;
    eb=mB_full-mBE;
    ef=mF_full-mFE;
    es=mS_full-mSE;
    Erro=[ev';eb';ef';es'];
    
    % ERRO QUADRÁTICO
    evq=ev.^2;
    ebq=eb.^2;
    efq=ef.^2;
    esq=es.^2;
    Erro_Quad=[evq';ebq';efq';esq'];
    
    %% Integrais dos erros quadráticos, para estimar a magnitude percentual do
    %% erro em relação os dados originais.
    
    % FOLHAS
    INT_EQv(1)=(trapz(evq(:,1)));
    INT_EQv(2)=(trapz(evq(:,2)));
    INT_EQv(3)=(trapz(evq(:,3)));
    INT_EQv(4)=(trapz(evq(:,4)));
    
    % BOTÕES
    INT_EQb(1)=(trapz(ebq(:,1)));
    INT_EQb(2)=(trapz(ebq(:,2)));
    INT_EQb(3)=(trapz(ebq(:,3)));
    INT_EQb(4)=(trapz(ebq(:,4)));
    
    % FLORES
    INT_EQf(1)=(trapz(efq(:,1)));
    INT_EQf(2)=(trapz(efq(:,2)));
    INT_EQf(3)=(trapz(efq(:,3)));
    INT_EQf(4)=(trapz(efq(:,4)));
    
    % SEMENTES
    INT_EQs(1)=(trapz(esq(:,1)));
    INT_EQs(2)=(trapz(esq(:,2)));
    INT_EQs(3)=(trapz(esq(:,3)));
    INT_EQs(4)=(trapz(esq(:,4)));
    
    % Monta tudo num vetor resposta
    INT_EQ=[INT_EQv;INT_EQb;INT_EQf;INT_EQs];
    
    
    %% Cálculo do erro percentual da simulação
    
    % (Eperc%)=(1-(INT-INT_EQ)/(INT))*100
    Eperc=(1-(INT-INT_EQ)./INT)*100;
    
    if flag3==1
        
        % =========================================================================
        % SUBPLOT - Plota os erros
        % =========================================================================
        
        % standardized colors
        deepBlue = [0, 0, 139] / 255;
        darkOran = [230, 159, 0] / 255;
        tealGree = [0, 158, 115] / 255;
        crimsonR = [213, 94, 0] / 255;

        %% FOLHAS
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(ev(:,1),':' ,'color',deepBlue,'linewidth',1);hold on;
        plot(ev(:,2),'-' ,'color',darkOran,'linewidth',1);
        plot(ev(:,3),'--','color',tealGree,'linewidth',1);
        plot(ev(:,4),'-.','color',crimsonR,'linewidth',1);hold off;grid on;
        set(gca,'XTick',0:48:240);xlim([0,240]);ylim([0,1])
        title('Foliage error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        print(gcf, 'ERROR_LIN_1.png', '-dpng', '-r300');
        
        %% BOTÕES
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(eb(:,1),':' ,'color',deepBlue,'linewidth',1);hold on;
        plot(eb(:,2),'-' ,'color',darkOran,'linewidth',1);
        plot(eb(:,3),'--','color',tealGree,'linewidth',1);
        plot(eb(:,4),'-.','color',crimsonR,'linewidth',1);hold off;grid on;
        set(gca,'XTick',0:48:240);xlim([0,240]);ylim([0,1])
        title('Floral buds error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        print(gcf, 'ERROR_LIN_2.png', '-dpng', '-r300');
        
        %% FLORES
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(ef(:,1),':' ,'color',deepBlue,'linewidth',1);hold on;
        plot(ef(:,2),'-' ,'color',darkOran,'linewidth',1);
        plot(ef(:,3),'--','color',tealGree,'linewidth',1);
        plot(ef(:,4),'-.','color',crimsonR,'linewidth',1);hold off;grid on;
        set(gca,'XTick',0:48:240);xlim([0,240]);ylim([0,1])
        title('Flowers error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        print(gcf, 'ERROR_LIN_3.png', '-dpng', '-r300');
        
        %% SEMENTES
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(es(:,1),':' ,'color',deepBlue,'linewidth',1);hold on;
        plot(es(:,2),'-' ,'color',darkOran,'linewidth',1);
        plot(es(:,3),'--','color',tealGree,'linewidth',1);
        plot(es(:,4),'-.','color',crimsonR,'linewidth',1);hold off;grid on;
        set(gca,'XTick',0:48:240);xlim([0,240]);ylim([0,1])
        title('Fruits error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        print(gcf, 'ERROR_LIN_4.png', '-dpng', '-r300');
        
        % =========================================================================
        % SUBPLOT - Plota os erros quadráticos
        % =========================================================================
        
        %% BOTÕES
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(ebq(:,1),':' ,'color',deepBlue,'linewidth',1);hold on;
        plot(ebq(:,2),'-' ,'color',darkOran,'linewidth',1);
        plot(ebq(:,3),'--','color',tealGree,'linewidth',1);
        plot(ebq(:,4),'-.','color',crimsonR,'linewidth',1);hold off;grid on;
        set(gca,'XTick',0:48:240);xlim([0,240]);ylim([0,1])
        title('Floral buds quadratic error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        print(gcf, 'ERROR_SQ_1.png', '-dpng', '-r300');
        
        %% FLORES
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(efq(:,1),':' ,'color',deepBlue,'linewidth',1);hold on;
        plot(efq(:,2),'-' ,'color',darkOran,'linewidth',1);
        plot(efq(:,3),'--','color',tealGree,'linewidth',1);
        plot(efq(:,4),'-.','color',crimsonR,'linewidth',1);hold off;grid on;
        set(gca,'XTick',0:48:240);xlim([0,240]);ylim([0,1])
        title('Flowers quadratic error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        print(gcf, 'ERROR_SQ_2.png', '-dpng', '-r300');
        
        %% SEMENTES
        figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
        plot(esq(:,1),':' ,'color',deepBlue,'linewidth',1);hold on;
        plot(esq(:,2),'-' ,'color',darkOran,'linewidth',1);
        plot(esq(:,3),'--','color',tealGree,'linewidth',1);
        plot(esq(:,4),'-.','color',crimsonR,'linewidth',1);hold off;grid on;
        set(gca,'XTick',0:48:240);xlim([0,240]);ylim([0,1])
        title('Fruits quadratic error, field data X simulation','fontweight','bold',...
            'fontname','Arial','fontangle','italic','fontsize',12)
        xlabel('Timesteps (48 divisions/year) [time]')
        ylabel('Percentual amplitude [%]')
        legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
            '\itB. Laevifolia\rm','\itB. Campestris\rm',...
            'location','bestoutside')
        print(gcf, 'ERROR_SQ_3.png', '-dpng', '-r300');
        
    end
    if flag4==1
        
        % =========================================================================
        % SUBPLOT - Plota a curva real e a simulada para comparação
        % =========================================================================
        
        %correção dos pontos final e inicial
        mB_full(1,:)=0;mB_full(end,:)=0;
        mF_full(1,:)=0;mF_full(end,:)=0;
        mS_full(1,:)=0;mS_full(end,:)=0;
        cB(1,:)=0;cB(end,:)=0;
        cF(1,:)=0;cF(end,:)=0;
        cS(1,:)=0;cS(end,:)=0;
        
        % MALIFOLIA ===============================================================
        figure;
        subplot(3,1,1);fill([(1:(dT*T))';((1:(dT*T))')],...
            [mB_full(:,1);cB(:,1)],[.7 .7 .7]);hold on;
        subplot(3,1,1);plot((1:(dT*T)),[mB_full(:,1),(cB(:,1))],...
            'linewidth',2);hold off;set(gca,'XTick',0:48:(dT*T))
        title('Malifolia floral buds error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        legend('Malifolia','Simulation','Mean field Data','location','northeast')
        
        subplot(3,1,2);fill([(1:(dT*T))';((1:(dT*T))')],...
            [mF_full(:,1);cF(:,1)],[.7 .7 .7]);hold on;
        subplot(3,1,2);plot((1:(dT*T)),[mF_full(:,1),(cF(:,1))],...
            'linewidth',2);hold off;set(gca,'XTick',0:48:(dT*T))
        title('Malifolia flowers error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        subplot(3,1,3);fill([(1:(dT*T))';((1:(dT*T))')],...
            [mS_full(:,1);cS(:,1)],[.7 .7 .7]);hold on;
        subplot(3,1,3);plot((1:(dT*T)),[mS_full(:,1),(cS(:,1))],...
            'linewidth',2);hold off;set(gca,'XTick',0:48:(dT*T))
        title('Malifolia fruits error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        % PEIXOTOA ================================================================
        figure;
        subplot(3,1,1);fill([(1:(dT*T))';((1:(dT*T))')],...
            [mB_full(:,2);cB(:,2)],[.7 .7 .7]);hold on;
        subplot(3,1,1);plot((1:(dT*T)),[mB_full(:,2),(cB(:,2))],...
            'linewidth',2);hold off;set(gca,'XTick',0:48:(dT*T))
        title('Peixotoa floral buds error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        legend('Peixotoa','Simulation','Mean field Data','location','northeast')
        
        subplot(3,1,2);fill([(1:(dT*T))';((1:(dT*T))')],...
            [mF_full(:,2);cF(:,2)],[.7 .7 .7]);hold on;
        subplot(3,1,2);plot((1:(dT*T)),[mF_full(:,2),(cF(:,2))],...
            'linewidth',2);hold off;set(gca,'XTick',0:48:(dT*T))
        title('Peixotoa flowers error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        subplot(3,1,3);fill([(1:(dT*T))';((1:(dT*T))')],...
            [mS_full(:,2);cS(:,2)],[.7 .7 .7]);hold on;
        subplot(3,1,3);plot((1:(dT*T)),[mS_full(:,2),(cS(:,2))],...
            'linewidth',2);hold off;set(gca,'XTick',0:48:(dT*T))
        title('Peixotoa fruits error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        % LAEVIFOLIA ==============================================================
        figure;
        subplot(3,1,1);fill([(1:(dT*T))';((1:(dT*T))')],...
            [mB_full(:,3);cB(:,3)],[.7 .7 .7]);hold on;
        subplot(3,1,1);plot((1:(dT*T)),[mB_full(:,3),(cB(:,3))],...
            'linewidth',2);hold off;set(gca,'XTick',0:48:(dT*T))
        title('Laevifolia floral buds error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        legend('Laevifolia','Simulation','Mean field Data','location','northeast')
        
        subplot(3,1,2);fill([(1:(dT*T))';((1:(dT*T))')],...
            [mF_full(:,3);cF(:,3)],[.7 .7 .7]);hold on;
        subplot(3,1,2);plot((1:(dT*T)),[mF_full(:,3),(cF(:,3))],...
            'linewidth',2);hold off;set(gca,'XTick',0:48:(dT*T))
        title('Laevifolia flowers error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        subplot(3,1,3);fill([(1:(dT*T))';((1:(dT*T))')],...
            [mS_full(:,3);cS(:,3)],[.7 .7 .7]);hold on;
        subplot(3,1,3);plot((1:(dT*T)),[mS_full(:,3),(cS(:,3))],...
            'linewidth',2);hold off;set(gca,'XTick',0:48:(dT*T))
        title('Laevifolia fruits error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        % CAMPESTRIS ==============================================================
        figure;
        subplot(3,1,1);fill([(1:(dT*T))';((1:(dT*T))')],...
            [mB_full(:,4);cB(:,4)],[.7 .7 .7]);hold on;
        subplot(3,1,1);plot((1:(dT*T)),[mB_full(:,4),(cB(:,4))],...
            'linewidth',2);hold off;set(gca,'XTick',0:48:(dT*T))
        title('Campestris floral buds error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        legend('Campestris','Simulation','Mean field Data','location','northeast')
        
        subplot(3,1,2);fill([(1:(dT*T))';((1:(dT*T))')],...
            [mF_full(:,4);cF(:,4)],[.7 .7 .7]);hold on;
        subplot(3,1,2);plot((1:(dT*T)),[mF_full(:,4),(cF(:,4))],...
            'linewidth',2);hold off;set(gca,'XTick',0:48:(dT*T))
        title('Campestris flowers error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
        subplot(3,1,3);fill([(1:(dT*T))';((1:(dT*T))')],...
            [mS_full(:,4);cS(:,4)],[.7 .7 .7]);hold on;
        subplot(3,1,3);plot((1:(dT*T)),[mS_full(:,4),(cS(:,4))],...
            'linewidth',2);hold off;set(gca,'XTick',0:48:(dT*T))
        title('Campestris fruits error','fontweight','bold',...
            'fontname','Calibri','fontangle','italic','fontsize',12);grid on;
        
    end
    
end






