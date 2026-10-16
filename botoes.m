function [F]=botoes(T,dT,TR,V1Em,V1Ep,V1El,V1Ec,V2Em,V2Ep,V2El,V2Ec)
% Função que cria as baselines para floradas das quatro espécies em
% questão, baseado nos dados medidos em campo, e parametrizadas entre 0 e
% 1, com o intuito de uniformizar os cálculos do programa para valores
% percentuais e não absolutos. Os valores de máximo são salvos e
% posteriormente usados para retornar a valores absolutos, uma vez que o
% processamento estiver terminado.


%% Ajuste dos dados de floradas, parametrização ===========================

%2008/9
FIELD=load('field_data.mat'); % field data are not public, see README.md
mali1=FIELD.botoes.mali1;
peix1=FIELD.botoes.peix1;
laev1=FIELD.botoes.laev1;
camp1=FIELD.botoes.camp1;

%2012/13
mali2=FIELD.botoes.mali2;
peix2=FIELD.botoes.peix2;
laev2=FIELD.botoes.laev2;
camp2=FIELD.botoes.camp2;

%2013/14
mali3=FIELD.botoes.mali3;
peix3=FIELD.botoes.peix3;
laev3=FIELD.botoes.laev3;
camp3=FIELD.botoes.camp3;


%% Dados de campo das floradas (j f m a m j j a s o n d) ==================

%MALIFOLIA
malifolia=(mali1+mali2+mali3)/3;

%PEIXOTOA
peixotoa=(peix1+peix2+peix3)/3;

%LAEVIFOLIA
laevifolia=(laev1+laev2+laev3)/3;

%CAMPESTRIS
campestris=(camp1+camp2+camp3)/3;

%parametriza entre zero e um
malifolia=malifolia/max(malifolia);
peixotoa=peixotoa/max(peixotoa);
laevifolia=laevifolia/max(laevifolia);
campestris=campestris/max(campestris);


%% Extrapolação e introdução da aleatoriedade =============================

%fator de interpolação
fator=dT/length(malifolia);

%extrapolação para T anos
int1=zeros(T*length(malifolia),1);
int2=zeros(T*length(peixotoa),1);
int3=zeros(T*length(laevifolia),1);
int4=zeros(T*length(campestris),1);

%malifolia
for i=1:T; 
    ra=(1 + (-1-1).*rand(length(malifolia),1))*(TR);
    M2=malifolia+ra';
    int1(length(malifolia)*(i-1)+1:length(malifolia)*i,1)=M2; 
end

%peixotoa
for i=1:T; 
    ra=(1 + (-1-1).*rand(length(peixotoa),1))*(TR);
    P2=peixotoa+ra';
    int2(length(peixotoa)*(i-1)+1:length(peixotoa)*i,1)=P2; 
end

%laevifolia
for i=1:T; 
    ra=(1 + (-1-1).*rand(length(laevifolia),1))*(TR);
    L2=laevifolia+ra';
    int3(length(laevifolia)*(i-1)+1:length(laevifolia)*i,1)=L2; 
end

%campestris
for i=1:T; 
    ra=(1 + (-1-1).*rand(length(campestris),1))*(TR);
    C2=campestris+ra';
    int4(length(campestris)*(i-1)+1:length(campestris)*i,1)=C2; 
end


%% Ajustes finais =========================================================

%interpolações individuais
malifolia=interp(int1,fator);
peixotoa=interp(int2,fator);
laevifolia=interp(int3,fator);
campestris=interp(int4,fator);

%parametriza entre zero e um
malifolia=malifolia/max(malifolia);
peixotoa=peixotoa/max(peixotoa);
laevifolia=laevifolia/max(laevifolia);
campestris=campestris/max(campestris);


%% Aplicação das variações forçadas nas baselines de floradas =============

% Adiantamento / atraso na florada

temp1=malifolia;
if V1Em>0 %adianta
    malifolia(1+V1Em:end)=malifolia(1:end-V1Em);
    malifolia(1:V1Em)=temp1(end-V1Em+1:end);
elseif V1Em<0 %atrasa
    malifolia(1:end+V1Em)=malifolia(1-V1Em:end);
    malifolia(end+V1Em+1:end)=temp1(1:-V1Em);
end


temp2=peixotoa;
if V1Ep>0 %adianta
    peixotoa(1+V1Ep:end)=peixotoa(1:end-V1Ep);
    peixotoa(1:V1Ep)=temp2(end-V1Ep+1:end);
elseif V1Ep<0 %atrasa
    peixotoa(1:end+V1Ep)=peixotoa(1-V1Ep:end);
    peixotoa(end+V1Ep+1:end)=temp2(1:-V1Ep);
end


temp3=laevifolia;
if V1El>0 %adianta
    laevifolia(1+V1El:end)=laevifolia(1:end-V1El);
    laevifolia(1:V1El)=temp3(end-V1El+1:end);
elseif V1El<0 %atrasa
    laevifolia(1:end+V1El)=laevifolia(1-V1El:end);
    laevifolia(end+V1El+1:end)=temp3(1:-V1El);
end


temp4=campestris;
if V1Ec>0 %adianta
    campestris(1+V1Ec:end)=campestris(1:end-V1Ec);
    campestris(1:V1Ec)=temp4(end-V1Ec+1:end);
elseif V1Ec<0 %atrasa
    campestris(1:end+V1Ec)=campestris(1-V1Ec:end);
    campestris(end+V1Ec+1:end)=temp4(1:-V1Ec);
end

%parametriza entre zero e um
malifolia=malifolia/max(malifolia);
peixotoa=peixotoa/max(peixotoa);
laevifolia=laevifolia/max(laevifolia);
campestris=campestris/max(campestris)*1.1317;

%multiplica pelo fator correto
malifolia=malifolia*V2Em; 
peixotoa=peixotoa*V2Ep; 
laevifolia=laevifolia*V2El; 
campestris=campestris*V2Ec; 

%matriz de tendências de floradas reais
F=[malifolia';peixotoa';laevifolia';campestris']';

%retira elementos nulos
for i=1:4
    for j=1:length(campestris)
        if F(j,i)<0
            F(j,i)=0;
        end
    end
end


%% Limpeza de memória e plots =============================================

deepBlue = [0, 0, 139] / 255;
darkOran = [230, 159, 0] / 255;
tealGree = [0, 158, 115] / 255;
crimsonR = [213, 94, 0] / 255;

figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(F(:,1),':' ,'linewidth',1,'color',deepBlue);hold on;
plot(F(:,2),'-' ,'linewidth',1,'color',darkOran);
plot(F(:,3),'--','linewidth',1,'color',tealGree);
plot(F(:,4),'-.','linewidth',1,'color',crimsonR);hold off
set(gca,'XTick',0:48:length(F(:,1)));grid on;
xlabel('Timesteps (48 divisions/year) [time]');xlim([0 240]);
ylabel('Percentual amplitude [%]')
title('Experimental flowering baselines per species - 5ys','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
print(gcf, 'FLOWERING_BASELINE_5y.png', '-dpng', '-r300');



figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(F(:,1),':' ,'linewidth',2,'color',deepBlue);hold on;
plot(F(:,2),'-' ,'linewidth',2,'color',darkOran);
plot(F(:,3),'--','linewidth',2,'color',tealGree);
plot(F(:,4),'-.','linewidth',2,'color',crimsonR);hold off
set(gca,'XTick',0:12:length(F(:,1)));grid on;
xlabel('Timesteps (48 divisions/year) [time]');xlim([0 48]);
ylabel('Percentual amplitude [%]')
title('Experimental flowering baselines per species','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
print(gcf, 'FLOWERING_BASELINE.png', '-dpng', '-r300');


% figure
% plot(Fp);grid on;title('diff floradas')
% F=Fp;

return



