function [E]=brotamentos(T,dT,TR)
% Função que cria as baselines para brotamentos das quatro espécies em
% questão, baseado nos dados medidos em campo, e parametrizadas entre 0 e
% 1, com o intuito de uniformizar os cálculos do programa para valores
% percentuais e não absolutos. Os valores de máximo são salvos e
% posteriormente usados para retornar a valores absolutos, uma vez que o
% processamento estiver terminado.

%% ajuste dos dados de brotamentos, parametrização ========================

%2012 / 2013
FIELD=load('field_data.mat'); % field data are not public, see README.md
malifolia=1./FIELD.brotamentos.malifolia;

peixotoa= 1./FIELD.brotamentos.peixotoa;
       
laevifolia=1./FIELD.brotamentos.laevifolia;
       
campestris=1./FIELD.brotamentos.campestris;
       
% int_E=[malifolia';peixotoa';laevifolia';campestris']';

%% Derivando para passar da quantidade de folhas para a taxa de variação
% 
% %vetor de tempos para serem derivados
% tempo=linspace(0,T,length(malifolia))';
% 
% %derivada numérica
% dmali = diff(malifolia) ./diff(tempo);
% dpeix = diff(peixotoa)  ./diff(tempo);
% dlaev = diff(laevifolia)./diff(tempo);
% dcamp = diff(campestris)./diff(tempo);
% 
% %ajuste do último elemento
% dmali(end+1) = dmali(end);
% dpeix(end+1) = dpeix(end);
% dlaev(end+1) = dlaev(end);
% dcamp(end+1) = dcamp(end);
% 
% %voltando aos nomes originais
% malifolia=dmali;
% peixotoa=dpeix;
% laevifolia=dlaev;
% campestris=dcamp;

%% Interpolação dos dados =================================================
       
%extrapolação para T anos
int1=zeros(T*length(malifolia),1);
int2=zeros(T*length(peixotoa),1);
int3=zeros(T*length(laevifolia),1);
int4=zeros(T*length(campestris),1);

%malifolia
for i=1:T; 
    ra=randn(length(malifolia),1)*TR-TR/2;
    M2=malifolia+ra;
    int1(length(malifolia)*(i-1)+1:length(malifolia)*i,1)=M2; 
end

%peixotoa
for i=1:T; 
    ra=randn(length(peixotoa),1)*TR-TR/2;
    P2=peixotoa+ra;
    int2(length(peixotoa)*(i-1)+1:length(peixotoa)*i,1)=P2; 
end

%laevifolia
for i=1:T; 
    ra=randn(length(laevifolia),1)*TR-TR/2;
    L2=laevifolia+ra;
    int3(length(laevifolia)*(i-1)+1:length(laevifolia)*i,1)=L2; 
end

%campestris
for i=1:T; 
    ra=randn(length(campestris),1)*TR-TR/2;
    C2=campestris+ra;
    int4(length(campestris)*(i-1)+1:length(campestris)*i,1)=C2; 
end

%% Ajustes finais

%fator de interpolação
fator=dT/length(malifolia);

%interpolações individuais
malifolia =interp(int1,fator);
peixotoa = interp(int2,fator);
laevifolia=interp(int3,fator);
campestris=interp(int4,fator);

%% Ajustes finais

%Normaliza
malifolia=malifolia/(max(abs(malifolia)));
peixotoa=peixotoa/(max(abs(peixotoa)));
laevifolia=laevifolia/(max(abs(laevifolia)));
campestris=campestris/(max(abs(campestris)));

%matriz de tendências de brotamentos reais
E=[malifolia';peixotoa';laevifolia';campestris']';

%% Exportação dos dados

deepBlue = [0, 0, 139] / 255;
darkOran = [230, 159, 0] / 255;
tealGree = [0, 158, 115] / 255;
crimsonR = [213, 94, 0] / 255;

figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(E(:,1),':' ,'linewidth',1,'color',deepBlue);hold on;
plot(E(:,2),'-' ,'linewidth',1,'color',darkOran);
plot(E(:,3),'--','linewidth',1,'color',tealGree);
plot(E(:,4),'-.','linewidth',1,'color',crimsonR);hold off
set(gca,'XTick',0:48:length(E(:,1)));grid on;
xlabel('Timesteps (48 divisions/year) [time]');
xlim([0 240]);ylim([0,1.1])
ylabel('Percentual amplitude [%]')
title('Experimental leaf sprouting baselines per species - 5ys','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
print(gcf, 'LEAFSPROUT_BASELINE_5y.png', '-dpng', '-r300');


figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(E(:,1),':' ,'linewidth',2,'color',deepBlue);hold on;
plot(E(:,2),'-' ,'linewidth',2,'color',darkOran);
plot(E(:,3),'--','linewidth',2,'color',tealGree);
plot(E(:,4),'-.','linewidth',2,'color',crimsonR);hold off
set(gca,'XTick',0:12:length(E(:,1)));grid on;
xlabel('Timesteps (48 divisions/year) [time]');
xlim([0 48]);ylim([0,1.1])
ylabel('Percentual amplitude [%]')
title('Experimental leaf sprouting baselines per species','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
print(gcf, 'LEAFSPROUT_BASELINE.png', '-dpng', '-r300');


% figure
% plot(int_E);grid on;title('int brotamentos')




