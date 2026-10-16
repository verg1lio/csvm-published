function resposta_plot(mV,mB,mF,mS,REF,flag)
% Mostra as curvas simuladas no tempo, na forma de gráficos individuais
% e/ou conjuntos.

deepBlue = [0, 0, 139] / 255;
darkOran = [230, 159, 0] / 255;
tealGree = [0, 158, 115] / 255;
crimsonR = [213, 94, 0] / 255;

if flag==1
    
% =========================================================================
% SUBPLOT (percentual)
% =========================================================================

%% FOLHAS
figure;
subplot(2,2,1);plot(mV(:,1),'linewidth',2,'color',deepBlue);hold on;
subplot(2,2,1);plot(mV(:,2),'linewidth',2,'color',darkOran);
subplot(2,2,1);plot(mV(:,3),'linewidth',2,'color',tealGree);
subplot(2,2,1);plot(mV(:,4),'linewidth',2,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on
title('Foliage time mean (percentual)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

%% BOTÕES
% figure;
subplot(2,2,2);plot(mB(:,1),'linewidth',2,'color',deepBlue);hold on;
subplot(2,2,2);plot(mB(:,2),'linewidth',2,'color',darkOran);
subplot(2,2,2);plot(mB(:,3),'linewidth',2,'color',tealGree);
subplot(2,2,2);plot(mB(:,4),'linewidth',2,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on
title('Floral buds time mean (percentual)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

%% FLORES
% figure;
subplot(2,2,3);plot(mF(:,1),'linewidth',2,'color',deepBlue);hold on;
subplot(2,2,3);plot(mF(:,2),'linewidth',2,'color',darkOran);
subplot(2,2,3);plot(mF(:,3),'linewidth',2,'color',tealGree);
subplot(2,2,3);plot(mF(:,4),'linewidth',2,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on
title('Flowers time mean (percentual)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

%% SEMENTES
% figure;
subplot(2,2,4);plot(mS(:,1),'linewidth',2,'color',deepBlue);hold on;
subplot(2,2,4);plot(mS(:,2),'linewidth',2,'color',darkOran);
subplot(2,2,4);plot(mS(:,3),'linewidth',2,'color',tealGree);
subplot(2,2,4);plot(mS(:,4),'linewidth',2,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on
title('Fruits time mean (percentual)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')

% =========================================================================
% SUBPLOT (absoluto)
% =========================================================================

%Retorno para valores absolutos
mB(:,1)=mB(:,1)*REF(1,1);
mB(:,2)=mB(:,2)*REF(2,1);
mB(:,3)=mB(:,3)*REF(3,1);
mB(:,4)=mB(:,4)*REF(4,1);

mF(:,1)=mF(:,1)*REF(1,2);
mF(:,2)=mF(:,2)*REF(2,2);
mF(:,3)=mF(:,3)*REF(3,2);
mF(:,4)=mF(:,4)*REF(4,2);

mS(:,1)=mS(:,1)*REF(1,3);
mS(:,2)=mS(:,2)*REF(2,3);
mS(:,3)=mS(:,3)*REF(3,3);
mS(:,4)=mS(:,4)*REF(4,3);

%% FOLHAS
figure;
subplot(2,2,1);plot(mV(:,1),'linewidth',2,'color',deepBlue);hold on;
subplot(2,2,1);plot(mV(:,2),'linewidth',2,'color',darkOran);
subplot(2,2,1);plot(mV(:,3),'linewidth',2,'color',tealGree);
subplot(2,2,1);plot(mV(:,4),'linewidth',2,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on
title('Foliage time mean (absolute)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Absolute amplitude [nº]')

%% BOTÕES
% figure;
subplot(2,2,2);plot(mB(:,1),'linewidth',2,'color',deepBlue);hold on;
subplot(2,2,2);plot(mB(:,2),'linewidth',2,'color',darkOran);
subplot(2,2,2);plot(mB(:,3),'linewidth',2,'color',tealGree);
subplot(2,2,2);plot(mB(:,4),'linewidth',2,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on
title('Floral buds time mean (absolute)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Absolute amplitude [nº]')

%% FLORES
% figure;
subplot(2,2,3);plot(mF(:,1),'linewidth',2,'color',deepBlue);hold on;
subplot(2,2,3);plot(mF(:,2),'linewidth',2,'color',darkOran);
subplot(2,2,3);plot(mF(:,3),'linewidth',2,'color',tealGree);
subplot(2,2,3);plot(mF(:,4),'linewidth',2,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on
title('Flowers time mean (absolute)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Absolute amplitude [nº]')

%% SEMENTES
% figure;
subplot(2,2,4);plot(mS(:,1),'linewidth',2,'color',deepBlue);hold on;
subplot(2,2,4);plot(mS(:,2),'linewidth',2,'color',darkOran);
subplot(2,2,4);plot(mS(:,3),'linewidth',2,'color',tealGree);
subplot(2,2,4);plot(mS(:,4),'linewidth',2,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on
title('Fruits time mean (absolute)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Absolute amplitude [nº]')

elseif flag==0

% =========================================================================
% PLOTS INDIVIDUAIS (percentual)
% =========================================================================

%% FOLHAS
figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(mV(:,1),':' ,'linewidth',1,'color',deepBlue);hold on;
plot(mV(:,2),'-' ,'linewidth',1,'color',darkOran);
plot(mV(:,3),'--','linewidth',1,'color',tealGree);
plot(mV(:,4),'-.','linewidth',1,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on;xlim([0,240]);
title('Foliage time mean (percentual)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
print(gcf, 'R1.png', '-dpng', '-r300');

%% BOTÕES
figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(mB(:,1),':' ,'linewidth',1,'color',deepBlue);hold on;
plot(mB(:,2),'-' ,'linewidth',1,'color',darkOran);
plot(mB(:,3),'--','linewidth',1,'color',tealGree);
plot(mB(:,4),'-.','linewidth',1,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on;xlim([0,240]);
title('Floral buds time mean (percentual)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
print(gcf, 'R2.png', '-dpng', '-r300');

%% FLORES
figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(mF(:,1),':' ,'linewidth',1,'color',deepBlue);hold on;
plot(mF(:,2),'-' ,'linewidth',1,'color',darkOran);
plot(mF(:,3),'--','linewidth',1,'color',tealGree);
plot(mF(:,4),'-.','linewidth',1,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on;xlim([0,240]);
title('Flowers time mean (percentual)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
print(gcf, 'R3.png', '-dpng', '-r300');

%% SEMENTES
figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(mS(:,1),':' ,'linewidth',1,'color',deepBlue);hold on;
plot(mS(:,2),'-' ,'linewidth',1,'color',darkOran);
plot(mS(:,3),'--','linewidth',1,'color',tealGree);
plot(mS(:,4),'-.','linewidth',1,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on;xlim([0,240]);
title('Fruits time mean (percentual)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Percentual amplitude [%]')
print(gcf, 'R4.png', '-dpng', '-r300');

% =========================================================================
% PLOTS INDIVIDUAIS (absoluto)
% =========================================================================

%Retorno para valores absolutos
mB(:,1)=mB(:,1)*REF(1,1);
mB(:,2)=mB(:,2)*REF(2,1);
mB(:,3)=mB(:,3)*REF(3,1);
mB(:,4)=mB(:,4)*REF(4,1);

mF(:,1)=mF(:,1)*REF(1,2);
mF(:,2)=mF(:,2)*REF(2,2);
mF(:,3)=mF(:,3)*REF(3,2);
mF(:,4)=mF(:,4)*REF(4,2);

mS(:,1)=mS(:,1)*REF(1,3);
mS(:,2)=mS(:,2)*REF(2,3);
mS(:,3)=mS(:,3)*REF(3,3);
mS(:,4)=mS(:,4)*REF(4,3);

%% FOLHAS
figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(mV(:,1),':' ,'linewidth',1,'color',deepBlue);hold on;
plot(mV(:,2),'-' ,'linewidth',1,'color',darkOran);
plot(mV(:,3),'--','linewidth',1,'color',tealGree);
plot(mV(:,4),'-.','linewidth',1,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on;xlim([0,240]);
title('Foliage time mean (absolute)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Absolute amplitude [nº]')
print(gcf, 'A1.png', '-dpng', '-r300');

%% BOTÕES
figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(mB(:,1),':' ,'linewidth',1,'color',deepBlue);hold on;
plot(mB(:,2),'-' ,'linewidth',1,'color',darkOran);
plot(mB(:,3),'--','linewidth',1,'color',tealGree);
plot(mB(:,4),'-.','linewidth',1,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on;xlim([0,240]);
title('Floral buds time mean (absolute)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Absolute amplitude [nº]')
print(gcf, 'A2.png', '-dpng', '-r300');

%% FLORES
figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(mF(:,1),':' ,'linewidth',1,'color',deepBlue);hold on;
plot(mF(:,2),'-' ,'linewidth',1,'color',darkOran);
plot(mF(:,3),'--','linewidth',1,'color',tealGree);
plot(mF(:,4),'-.','linewidth',1,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on;xlim([0,240]);
title('Flowers time mean (absolute)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Absolute amplitude [nº]')
print(gcf, 'A3.png', '-dpng', '-r300');

%% SEMENTES
figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(mS(:,1),':' ,'linewidth',1,'color',deepBlue);hold on;
plot(mS(:,2),'-' ,'linewidth',1,'color',darkOran);
plot(mS(:,3),'--','linewidth',1,'color',tealGree);
plot(mS(:,4),'-.','linewidth',1,'color',crimsonR);hold off;grid on;
set(gca,'XTick',0:48:length(mV(:,1)));grid on;xlim([0,240]);
title('Fruits time mean (absolute)','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Timesteps (48 divisions/year) [time]')
ylabel('Absolute amplitude [nº]')
print(gcf, 'A4.png', '-dpng', '-r300');

end






