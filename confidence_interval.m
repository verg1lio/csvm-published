function confidence_interval(mB,mF,mS,cB,cF,cS,T,dT,CIM,flag9)
% Function to plot the confidence interval of the measurede field data, and
% also the program generated response, showing graphically if the response
% is properly fitted or not.

% CIM is the confidence interval margin, given in percentual values, that
% is calculated separately, and used here to define the superior and
% inferior tolerance margins to the comparison.

deepBlue = [0, 0, 139] / 255;
darkOran = [230, 159, 0] / 255;
tealGree = [0, 158, 115] / 255;
crimsonR = [213, 94, 0] / 255;

%% CASO DE UM CICLO TÍPICO ================================================
if flag9==1
    
% =========================================================================
% SUBPLOT - Plota o intervalo de confiança da curva real para comparação
% =========================================================================

%criação dos limites superior e inferior
cbl_tip=cB(dT+1:2*dT,:)-cB(dT+1:2*dT,:)*CIM;
cfl_tip=cF(dT+1:2*dT,:)-cF(dT+1:2*dT,:)*CIM;
csl_tip=cS(dT+1:2*dT,:)-cS(dT+1:2*dT,:)*CIM;

cbu_tip=cB(dT+1:2*dT,:)+cB(dT+1:2*dT,:)*CIM;
cfu_tip=cF(dT+1:2*dT,:)+cF(dT+1:2*dT,:)*CIM;
csu_tip=cS(dT+1:2*dT,:)+cS(dT+1:2*dT,:)*CIM;

%correção dos pontos final e inicial
mB(1,:)=0;mB(end,:)=0;mF(1,:)=0;mF(end,:)=0;mS(1,:)=0;mS(end,:)=0;
cbl_tip(1,:)=0;cbl_tip(end,:)=0;
cfl_tip(1,:)=0;cfl_tip(end,:)=0;
csl_tip(1,:)=0;csl_tip(end,:)=0;
cbu_tip(1,:)=0;cbu_tip(end,:)=0;
cfu_tip(1,:)=0;cfu_tip(end,:)=0;
csu_tip(1,:)=0;csu_tip(end,:)=0;

% MALIFOLIA ===============================================================
figure;
subplot(3,1,1);fill([(1:dT)';((1:dT)')],...
    [cbl_tip(:,1);cbu_tip(:,1)],[.7 .7 .7]);hold on;
subplot(3,1,1);plot((1:dT),[cbl_tip(:,1),(cbu_tip(:,1))],'linewidth',2,'color','k');
subplot(3,1,1);plot((1:dT),mB(dT+1:2*dT,1),'linewidth',2,'color',deepBlue);
hold off;set(gca,'XTick',0:dT:dT)
title('\itB. Malifolia\rm floral buds confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

subplot(3,1,2);fill([(1:dT)';((1:dT)')],...
    [cfl_tip(:,1);cfu_tip(:,1)],[.7 .7 .7]);hold on;
subplot(3,1,2);plot((1:dT),[cfl_tip(:,1),(cfu_tip(:,1))],'linewidth',2,'color','k');
subplot(3,1,2);plot((1:dT),mF(dT+1:2*dT,1),'linewidth',2,'color',deepBlue);
hold off;set(gca,'XTick',0:dT:dT)
title('\itB. Malifolia\rm flowers confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

subplot(3,1,3);fill([(1:dT)';((1:dT)')],...
    [csl_tip(:,1);csu_tip(:,1)],[.7 .7 .7]);hold on;
subplot(3,1,3);plot((1:dT),[csl_tip(:,1),(csu_tip(:,1))],'linewidth',2,'color','k');
subplot(3,1,3);plot((1:dT),mS(dT+1:2*dT,1),'linewidth',2,'color',deepBlue);
hold off;set(gca,'XTick',0:dT:dT)
title('\itB. Malifolia\rm fruits confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

% PEIXOTOA ================================================================
figure;
subplot(3,1,1);fill([(1:dT)';((1:dT)')],...
    [cbl_tip(:,2);cbu_tip(:,2)],[.7 .7 .7]);hold on;
subplot(3,1,1);plot((1:dT),[cbl_tip(:,2),(cbu_tip(:,2))],'linewidth',2,'color','k');
subplot(3,1,1);plot((1:dT),mB(dT+1:2*dT,2),'linewidth',2,'color',darkOran);
hold off;set(gca,'XTick',0:dT:dT)
title('\itP. Tomentosa\rm floral buds confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

subplot(3,1,2);fill([(1:dT)';((1:dT)')],...
    [cfl_tip(:,2);cfu_tip(:,2)],[.7 .7 .7]);hold on;
subplot(3,1,2);plot((1:dT),[cfl_tip(:,2),(cfu_tip(:,2))],'linewidth',2,'color','k');
subplot(3,1,2);plot((1:dT),mF(dT+1:2*dT,2),'linewidth',2,'color',darkOran);
hold off;set(gca,'XTick',0:dT:dT)
title('\itP. Tomentosa\rm flowers confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

subplot(3,1,3);fill([(1:dT)';((1:dT)')],...
    [csl_tip(:,2);csu_tip(:,2)],[.7 .7 .7]);hold on;
subplot(3,1,3);plot((1:dT),[csl_tip(:,2),(csu_tip(:,2))],'linewidth',2,'color','k');
subplot(3,1,3);plot((1:dT),mS(dT+1:2*dT,2),'linewidth',2,'color',darkOran);
hold off;set(gca,'XTick',0:dT:dT)
title('\itP. Tomentosa\rm fruits confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

% LAEVIFOLIA ==============================================================
figure;
subplot(3,1,1);fill([(1:dT)';((1:dT)')],...
    [cbl_tip(:,3);cbu_tip(:,3)],[.7 .7 .7]);hold on;
subplot(3,1,1);plot((1:dT),[cbl_tip(:,3),(cbu_tip(:,3))],'linewidth',2,'color','k');
subplot(3,1,1);plot((1:dT),mB(dT+1:2*dT,3),'linewidth',2,'color',tealGree);
hold off;set(gca,'XTick',0:dT:dT)
title('\itB. Laevifolia\rm floral buds confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

subplot(3,1,2);fill([(1:dT)';((1:dT)')],...
    [cfl_tip(:,3);cfu_tip(:,3)],[.7 .7 .7]);hold on;
subplot(3,1,2);plot((1:dT),[cfl_tip(:,3),(cfu_tip(:,3))],'linewidth',2,'color','k');
subplot(3,1,2);plot((1:dT),mF(dT+1:2*dT,3),'linewidth',2,'color',tealGree);
hold off;set(gca,'XTick',0:dT:dT)
title('\itB. Laevifolia\rm flowers confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

subplot(3,1,3);fill([(1:dT)';((1:dT)')],...
    [csl_tip(:,3);csu_tip(:,3)],[.7 .7 .7]);hold on;
subplot(3,1,3);plot((1:dT),[csl_tip(:,3),(csu_tip(:,3))],'linewidth',2,'color','k');
subplot(3,1,3);plot((1:dT),mS(dT+1:2*dT,3),'linewidth',2,'color',tealGree);
hold off;set(gca,'XTick',0:dT:dT)
title('\itB. Laevifolia\rm fruits confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

% CAMPESTRIS ==============================================================
figure;
subplot(3,1,1);fill([(1:dT)';((1:dT)')],...
    [cbl_tip(:,4);cbu_tip(:,4)],[.7 .7 .7]);hold on;
subplot(3,1,1);plot((1:dT),[cbl_tip(:,4),(cbu_tip(:,4))],'linewidth',2,'color','k');
subplot(3,1,1);plot((1:dT),mB(dT+1:2*dT,4),'linewidth',2,'color',crimsonR);
hold off;set(gca,'XTick',0:dT:dT)
title('\itB. Campestris\rm floral buds confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

subplot(3,1,2);fill([(1:dT)';((1:dT)')],...
    [cfl_tip(:,4);cfu_tip(:,4)],[.7 .7 .7]);hold on;
subplot(3,1,2);plot((1:dT),[cfl_tip(:,4),(cfu_tip(:,4))],'linewidth',2,'color','k');
subplot(3,1,2);plot((1:dT),mF(dT+1:2*dT,4),'linewidth',2,'color',crimsonR);
hold off;set(gca,'XTick',0:dT:dT)
title('\itB. Campestris\rm flowers confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

subplot(3,1,3);fill([(1:dT)';((1:dT)')],...
    [csl_tip(:,4);csu_tip(:,4)],[.7 .7 .7]);hold on;
subplot(3,1,3);plot((1:dT),[csl_tip(:,4),(csu_tip(:,4))],'linewidth',2,'color','k');
subplot(3,1,3);plot((1:dT),mS(dT+1:2*dT,4),'linewidth',2,'color',crimsonR);
hold off;set(gca,'XTick',0:dT:dT)
title('\itB. Campestris\rm fruits confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')



%% CASO DE TODOS OS CICLOS COMPLETOS ======================================
elseif flag9==0
    
% =========================================================================
% SUBPLOT - Plota o intervalo de confiança da curva real para comparação
% =========================================================================

%criação dos limites superior e inferior
cbl=cB-cB*CIM;
cfl=cF-cF*CIM;
csl=cS-cS*CIM;
cbu=cB+cB*CIM;
cfu=cF+cF*CIM;
csu=cS+cS*CIM;

%correção dos pontos final e inicial
mB(1,:)=0;mB(end,:)=0;mF(1,:)=0;mF(end,:)=0;mS(1,:)=0;mS(end,:)=0;
cbl(1,:)=0;cbl(end,:)=0;
cfl(1,:)=0;cfl(end,:)=0;
csl(1,:)=0;csl(end,:)=0;
cbu(1,:)=0;cbu(end,:)=0;
cfu(1,:)=0;cfu(end,:)=0;
csu(1,:)=0;csu(end,:)=0;

% MALIFOLIA ===============================================================
figure('Units', 'pixels', 'Position', [100, 100, 800, 800]);
subplot(3,1,1);plot((1:(dT*T)),mB(:,1),'--','linewidth',2,'color',deepBlue);hold on;
subplot(3,1,1);plot((1:(dT*T)),[cbl(:,1),(cbu(:,1))],'linewidth',2,'color','k');
subplot(3,1,1);fill([(1:(dT*T))'; flipud((1:(dT*T))')],...
    [cbl(:,1); flipud(cbu(:,1))],[.7 .7 .7]);
subplot(3,1,1);plot((1:(dT*T)),mB(:,1),'--','linewidth',2,'color',deepBlue);
hold off;set(gca,'XTick',0:dT:(dT*T))
title('Floral buds confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
legend('\itB. Malifolia\rm Buds','Confidence interval',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
xlim([0,240])

subplot(3,1,2);plot((1:(dT*T)),mF(:,1),'--','linewidth',2,'color',deepBlue);hold on;
subplot(3,1,2);plot((1:(dT*T)),[cfl(:,1),(cfu(:,1))],'linewidth',2,'color','k');
subplot(3,1,2);fill([(1:(dT*T))'; flipud((1:(dT*T))')],...
    [cfl(:,1); flipud(cfu(:,1))],[.7 .7 .7]);
subplot(3,1,2);plot((1:(dT*T)),mF(:,1),'--','linewidth',2,'color',deepBlue);
hold off;set(gca,'XTick',0:dT:(dT*T))
title('Flowers confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
legend('\itB. Malifolia\rm Flowers','Confidence interval',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
xlim([0,240])

subplot(3,1,3);plot((1:(dT*T)),mS(:,1),'--','linewidth',2,'color',deepBlue);hold on;
subplot(3,1,3);plot((1:(dT*T)),[csl(:,1),(csu(:,1))],'linewidth',2,'color','k');
subplot(3,1,3);fill([(1:(dT*T))'; flipud((1:(dT*T))')],...
    [csl(:,1); flipud(csu(:,1))],[.7 .7 .7]);
subplot(3,1,3);plot((1:(dT*T)),mS(:,1),'--','linewidth',2,'color',deepBlue);
hold off;set(gca,'XTick',0:dT:(dT*T))
title('Fruits confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
legend('\itB. Malifolia\rm Fruits','Confidence interval',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
xlim([0,240])

print(gcf, 'CI1.png', '-dpng', '-r300');

% PEIXOTOA ================================================================
figure('Units', 'pixels', 'Position', [100, 100, 800, 800]);
subplot(3,1,1);plot((1:(dT*T)),mB(:,2),'--','linewidth',2,'color',darkOran);hold on;
subplot(3,1,1);plot((1:(dT*T)),[cbl(:,2),(cbu(:,2))],'linewidth',2,'color','k');
subplot(3,1,1);fill([(1:(dT*T))'; flipud((1:(dT*T))')],...
    [cbl(:,2); flipud(cbu(:,2))],[.7 .7 .7]);
subplot(3,1,1);plot((1:(dT*T)),mB(:,2),'--','linewidth',2,'color',darkOran);
hold off;set(gca,'XTick',0:dT:(dT*T))
title('Floral buds confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
legend('\itP. Tomentosa\rm Buds','Confidence interval',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
xlim([0,240])

subplot(3,1,2);plot((1:(dT*T)),mF(:,2),'--','linewidth',2,'color',darkOran);hold on;
subplot(3,1,2);plot((1:(dT*T)),[cfl(:,2),(cfu(:,2))],'linewidth',2,'color','k');
subplot(3,1,2);fill([(1:(dT*T))'; flipud((1:(dT*T))')],...
    [cfl(:,2); flipud(cfu(:,2))],[.7 .7 .7]);
subplot(3,1,2);plot((1:(dT*T)),mF(:,2),'--','linewidth',2,'color',darkOran);
hold off;set(gca,'XTick',0:dT:(dT*T))
title('Flowers confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
legend('\itP. Tomentosa\rm Flowers','Confidence interval',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
xlim([0,240])

subplot(3,1,3);plot((1:(dT*T)),mS(:,2),'--','linewidth',2,'color',darkOran);hold on;
subplot(3,1,3);plot((1:(dT*T)),[csl(:,2),(csu(:,2))],'linewidth',2,'color','k');
subplot(3,1,3);fill([(1:(dT*T))'; flipud((1:(dT*T))')],...
    [csl(:,2); flipud(csu(:,2))],[.7 .7 .7]);
subplot(3,1,3);plot((1:(dT*T)),mS(:,2),'--','linewidth',2,'color',darkOran);
hold off;set(gca,'XTick',0:dT:(dT*T))
title('Fruits confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
legend('\itP. Tomentosa\rm Fruits','Confidence interval',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
xlim([0,240])

print(gcf, 'CI2.png', '-dpng', '-r300');

% LAEVIFOLIA ==============================================================
figure('Units', 'pixels', 'Position', [100, 100, 800, 800]);
subplot(3,1,1);plot((1:(dT*T)),mB(:,3),'--','linewidth',2,'color',tealGree);hold on;
subplot(3,1,1);plot((1:(dT*T)),[cbl(:,3),(cbu(:,3))],'linewidth',2,'color','k');
subplot(3,1,1);fill([(1:(dT*T))'; flipud((1:(dT*T))')],...
    [cbl(:,3); flipud(cbu(:,3))],[.7 .7 .7]);
subplot(3,1,1);plot((1:(dT*T)),mB(:,3),'--','linewidth',2,'color',tealGree);
hold off;set(gca,'XTick',0:dT:(dT*T))
title('Floral buds confidence interval', ...
    'FontName','Arial', 'FontSize',12);grid on;
legend('\itB. Laevifolia\rm Buds','Confidence interval',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
xlim([0,240])

subplot(3,1,2);plot((1:(dT*T)),mF(:,3),'--','linewidth',2,'color',tealGree);hold on;
subplot(3,1,2);plot((1:(dT*T)),[cfl(:,3),(cfu(:,3))],'linewidth',2,'color','k');
subplot(3,1,2);fill([(1:(dT*T))'; flipud((1:(dT*T))')],...
    [cfl(:,3); flipud(cfu(:,3))],[.7 .7 .7]);
subplot(3,1,2);plot((1:(dT*T)),mF(:,3),'--','linewidth',2,'color',tealGree);
hold off;set(gca,'XTick',0:dT:(dT*T))
title('Flowers confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
legend('\itB. Laevifolia\rm Flowers','Confidence interval',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
xlim([0,240])

subplot(3,1,3);plot((1:(dT*T)),mS(:,3),'--','linewidth',2,'color',tealGree);hold on;
subplot(3,1,3);plot((1:(dT*T)),[csl(:,3),(csu(:,3))],'linewidth',2,'color','k');
subplot(3,1,3);fill([(1:(dT*T))'; flipud((1:(dT*T))')],...
    [csl(:,3); flipud(csu(:,3))],[.7 .7 .7]);
subplot(3,1,3);plot((1:(dT*T)),mS(:,3),'--','linewidth',2,'color',tealGree);
hold off;set(gca,'XTick',0:dT:(dT*T))
title('Fruits confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
legend('\itB. Laevifolia\rm Fruits','Confidence interval',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
xlim([0,240])

print(gcf, 'CI3.png', '-dpng', '-r300');

% CAMPESTRIS ==============================================================
figure('Units', 'pixels', 'Position', [100, 100, 800, 800]);
subplot(3,1,1);plot((1:(dT*T)),mB(:,4),'--','linewidth',2,'color',crimsonR);hold on;
subplot(3,1,1);plot((1:(dT*T)),[cbl(:,4),(cbu(:,4))],'linewidth',2,'color','k');
subplot(3,1,1);fill([(1:(dT*T))'; flipud((1:(dT*T))')],...
    [cbl(:,4); flipud(cbu(:,4))],[.7 .7 .7]);
subplot(3,1,1);plot((1:(dT*T)),mB(:,4),'--','linewidth',2,'color',crimsonR);
hold off;set(gca,'XTick',0:dT:(dT*T))
title('Floral buds confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
legend('\itB. Campestris\rm Buds','Confidence interval',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
xlim([0,240])

subplot(3,1,2);plot((1:(dT*T)),mF(:,4),'--','linewidth',2,'color',crimsonR);hold on;
subplot(3,1,2);plot((1:(dT*T)),[cfl(:,4),(cfu(:,4))],'linewidth',2,'color','k');
subplot(3,1,2);fill([(1:(dT*T))'; flipud((1:(dT*T))')],...
    [cfl(:,4); flipud(cfu(:,4))],[.7 .7 .7]);
subplot(3,1,2);plot((1:(dT*T)),mF(:,4),'--','linewidth',2,'color',crimsonR);
hold off;set(gca,'XTick',0:dT:(dT*T))
title('Flowers confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
legend('\itB. Campestris\rm Flowers','Confidence interval',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
xlim([0,240])

subplot(3,1,3);plot((1:(dT*T)),mS(:,4),'--','linewidth',2,'color',crimsonR);hold on;
subplot(3,1,3);plot((1:(dT*T)),[csl(:,4),(csu(:,4))],'linewidth',2,'color','k');
subplot(3,1,3);fill([(1:(dT*T))'; flipud((1:(dT*T))')],...
    [csl(:,4); flipud(csu(:,4))],[.7 .7 .7]);
subplot(3,1,3);plot((1:(dT*T)),mS(:,4),'--','linewidth',2,'color',crimsonR);
hold off;set(gca,'XTick',0:dT:(dT*T))
title('Fruits confidence interval',...
    'fontname','Arial','fontsize',12);grid on;
legend('\itB. Campestris\rm Fruits','Confidence interval',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
xlim([0,240])

print(gcf, 'CI4.png', '-dpng', '-r300');

end






