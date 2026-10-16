function [C]=chuvas(T,dT,TR,V1C,V2C)
% Função para criar o vetor de chuvas histórico da região de Uberlândia
% durante 5 anos, indo de 2008 até 2012. O padrão medido foi extrapolado
% para todos os anos da simulação, acrescidos de variações aleatórias
% durante todo o período, como é comum num clima tropical quente. Estas
% variações aleatórias também se justificam devido à dificuldade de prever
% qual será o comportamento do clima nos próximos anos, e tem a intenção de
% tornar o modelo mais robusto.
% 
% Note que todas as entradas do programa são dadas em percentagens, onde 1
% vale 100% e 0 vale 0%. Isto vale também para as chuvas, que são
% parametrizadas para 1 sendo o valor máximo de chuva em um ano comum,
% padrão atual (2008 - 2012), medido em Uberlândia. Para se variar o efeito
% das chuvas deve-se alterar o valor do máximo em percentagem.

%% PLUVIOSIDADE MENSAL MEDIDA NA UFU - INSTITUTO DE GEOGRAFIA =============
FIELD=load('field_data.mat'); % field data are not public, see README.md
a2008=FIELD.chuvas.a2008;

a2009=FIELD.chuvas.a2009;

a2010=FIELD.chuvas.a2010;

a2011=FIELD.chuvas.a2011;

a2012=FIELD.chuvas.a2012;

%% CRIAÇÃO DO VETOR CLIMA "C" =============================================

%definição da tendência
C=(a2008+a2009+a2010+a2011+a2012)/5;
intermediario=zeros(T*length(C),1);

%% Introdução da aleatoriedade de TR percento =============================

% Parametrização
C=C/max(C); 

%extrapolação para T anos
for i=1:T; 
    ra=randn(length(C),1)*TR;
    C2=C+ra;
    intermediario(length(C)*(i-1)+1:length(C)*i,1)=C2;
end

%% Ajustes finais =========================================================

%ajuste no início e final da curva
intermediario(1,1)=intermediario(2,1);
intermediario(end,1)=intermediario(end-1,1);

%interpolação
fator=dT/length(C);
intermediario=interp(intermediario,fator);
C=intermediario;

%eliminação de discrepâncias
for i=1:T*dT
    if isnan(C(i))
        C(i)=C(i-1);
    end
end

%normalização
C=C/max(C); 

%% Adiantamento, atraso e multiplicador das chuvas ========================

temp1=C;
if V1C>0 %adianta
    C(1+V1C:end)=C(1:end-V1C);
    C(1:V1C)=temp1(end-V1C+1:end);
elseif V1C<0 %atrasa
    C(1:end+V1C)=C(1-V1C:end);
    C(end+V1C+1:end)=temp1(1:-V1C);
end
C=C*V2C; %multiplica

%% Remoção de pontos negativos ============================================

C(C<0)=0;

%% Limpeza de memória e plots =============================================

figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(C,'linewidth',2,'color','k');
set(gca,'XTick',0:48:length(C));grid on;
xlabel('Timesteps (48 divisions/year) [time]');xlim([0 240]);
ylabel('Percentual amplitude [%]')
title('Averaged rainfall baseline - 5ys','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
print(gcf, 'RAINFALL_BASELINE_5y.png', '-dpng', '-r300');


figure('Units', 'pixels', 'Position', [100, 100, 800, 250]);
plot(C,'linewidth',2,'color','k');
set(gca,'XTick',0:12:length(C));grid on;
xlabel('Timesteps (48 divisions/year) [time]');xlim([0 48]);
ylabel('Percentual amplitude [%]')
title('Averaged rainfall baseline','fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
print(gcf, 'RAINFALL_BASELINE.png', '-dpng', '-r300');



