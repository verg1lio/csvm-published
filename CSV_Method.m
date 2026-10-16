% function [sim_ans1,sim_ans2,sim_ans3,sim_ans4] = CSV_Method (step)
% function [sim_ans] = CSV_Method (X1)

%%
% 
%                     >>>>>  Programa CSVM  <<<<<
% 
% Programa para estimar cenários de herbivoria e sobrevivência de espécies
% de plantas Angiospermas. Este código é desenvolvido se baseando em
% métodos matriciais e funções explícitas, dotadas de incerteza nos
% parâmetros, para representar a evolução temporal de populações de plantas
% específicas. O programa deve receber como entrada os dados necessários,
% medidos em campo (chuvas, herbivoria, épocas de florada e brotamento de
% folhas novas, polinizadores, etc.), e deve ser ajustado via procedimento
% de otimização híbrido, descrito em artigo (Inicialmente por Evolução
% Diferencial e Localmente por Programação Quadrática Sequencial). O
% programa gera como resposta dados e estatísticas diversas, estimadas para
% a produtividade de botões florais, flores e frutos das espécies em
% questão. (Comentários internos do código são escritos em Português e
% relatórios expostos em tela são escritos em Inglês.)
% 
% Inicialmente este código foi desenvolvido utilizando 4 espécies
% de plantas típicas do cerrado brasileiro, listadas a seguir:
% 
% 'B. malifolia','P. tomentosa','B. laevifolia','B. campestris'
% 
% Este programa é desenvolvido por:
% 
% Eng. Vergílio T. S. Del Claro -------- vergiliotorezan@gmail.com -- (1,3)
% 
% Contando com auxílio/suporte teórico de:
% 
% Msc. Andréa Andrade Vilela ----------- andreaufu@yahoo.com.br ----- (1,2)
% Profa. Dra. Helena Maura T. Silingardi - hmtsilingardi@gmail.com -- (1,2)
% Prof. Dr. Kleber Del Claro ----------- delclaro@ufu.com.br -------- (1,2)
% 
% 1 - UFU  -- Universidade Federal de Uberlândia;
% 2 - LECI/INBIO -- Laboratório de Ecologia Comportamental e de Interações
% do Instituto de Biologia;
% 3 - LMEst/FEMEC - Laboratório de Mecânica de Estruturas da Faculdade de
% Engenharia Mecânica;
% 
%% >>>>> ÚLTIMA ATUALIZAÇÃO NO DIA: 10/07/2015 <<<<<

%% INICIALIZAÇÃO ==========================================================
clear all; close all; clc;   % inicializa o programa
global MV MB MF MS C nex ney T dT
 
%% ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

% OPÇÕES GERAIS DO CENÁRIO SIMULADO =======================================
nex=100;     % número de elementos em x (quadrados de 0,5 m de lado)
ney=100;     % número de elementos em y (quadrados de 0,5 m de lado)
T=05;        % tempo total da simulação (anos)
dT=48;       % número de iteraçoes por ano (1.0863 por semana)
CIM=0.15;    % intervalo de confiança percentuais dos dados de campo

% OPÇÕES DE SAÍDA DO PROGRAMA =============================================
pts   = 2;   % monitorar processamento? (0=não, 1=video, 2=inicial)
flag1 = 0;   % plotar individual ou em grupo?        (0=ind, 1=gru)
flag2 = 0;   % exportar para EXCEL?                  (0=não, 1=sim)
flag3 = 1;   % plotar gráficos de erros?             (0=não, 1=sim)
flag4 = 0;   % plotar gráficos comparativos?         (0=não, 1=sim)
flag5 = 1;   % plotar intervalos de confiança?       (0=não, 1=sim)
flag6 = 1;   % plotar resposta gráfica final?        (0=não, 1=sim)
flag7 = 0;   % mostrar timer?                        (0=não, 1=sim)
flag8 = 1;   % mostrar program output?               (0=não, 1=sim)
flag9 = 0;   % plotar somente um ciclo típico?       (0=não, 1=sim)
LF    = 1;   % mostrar o log file?                   (0=não, 1=sim)

% OPÇÕES DE EXECUÇÃO DO PROGRAMA ==========================================
RorN  = 1;   % usar inputs random ou normais?        (0=NRM, 1=RND)

% VARIAÇÃO DE FENOLOGIA ( (+) ou (-) n, onde n = TIME_STEP) ===============
V1C  = 0;    % adiantamento/atraso das chuvas
V1Em = 0;    % adiantamento/atraso da florada de malifolia
V1Ep = 0;    % adiantamento/atraso da florada de peixotoa
V1El = 0;    % adiantamento/atraso da florada de laevifolia
V1Ec = 0;    % adiantamento/atraso da florada de campestris

%VARIAÇÃO DE INTENSIDADE (1 = 100%, tendência real) =======================
V2C  = 1;    % multiplicador das chuvas

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%% ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| %%

%% INPUTS - LOG FILE INITIALIZATION =======================================
if LF==1;
    fprintf('\n   ----- CSV Method Simulator - CSVM -----\n');
    if flag7==1;tic;end
    fprintf('\n>> Initializing the program ............ ');
    fprintf('OK!\n\n');fprintf('>> Log file:\n\n');
end

%% OPTIMUM VALUES OBTAINED AFTER HYBRID METHOD OPTIMIZATION, MADE WITH
%% DIFFERENCIAL EVOLUTION FOLLOWED BY SEQUENTIAL QUADRATIC PROGRAMMING

% =====================||==================================================
% 4th OPTIMIZED VALUES || NON-ROBUST - use only in non random case
% =====================||==================================================
% [X1]=entry_tester(1,17);
% [X2]=entry_tester(2,25);
% [X3]=entry_tester(3,14);
% [X4]=entry_tester(4,11);
% 
% Squared error results obtained for default case listed below
% 
%     'Sim Data'    'F. Buds'    'Flowers'    'Fruits'
%     'B. mali.'    [ 1.1282]    [ 1.6486]    [1.7637]
%     'P. tome.'    [ 4.1475]    [ 3.2409]    [8.6177]
%     'B. laev.'    [ 2.3705]    [ 3.3421]    [2.9362]
%     'B. camp.'    [ 1.3448]    [ 5.6614]    [8.8956]
% 
%     'Mean squared error'    [3.7581]



% =====================||==================================================
% 5th OPTIMIZED VALUES || ROBUST - use always!!
% =====================||==================================================
% [X1]=entry_tester(1,18);
% [X2]=entry_tester(2,13)';
% [X3]=entry_tester(3,20)';
% [X4]=entry_tester(4,19)';
% 
% Squared error results obtained for default case listed below
% 
%     'Sim Data'    'F. Buds'    'Flowers'    'Fruits'
%     'B. mali.'    [ 1.2162]    [ 1.7085]    [1.6313]
%     'P. tome.'    [ 4.1033]    [ 3.5022]    [8.7187]
%     'B. laev.'    [ 2.4531]    [ 3.8978]    [3.1011]
%     'B. camp.'    [ 1.0901]    [ 5.5339]    [9.5090]
% 
%     'Mean squared error'    [3.8721]

X1 = [0.0265  
      0.0395  
      0.1282  
      0.0300  
      0.6345  
      0.4017  
      0.9038  
      0.4807  
      0.4355  
      0.0886  
      0.1225];
  
X2 = [0.0346
      0.1051
      0.2704
      0.0639
      1.2799
      1.8157
      1.0358
      1.0896
      0.8610
      0.1498
      0.1654];
  
X3 = [0.0270
      0.0871
      0.2853
      0.0265
      1.0360
      1.3047
      1.8455
      0.8688
      0.5031
      0.1211
      0.1354];
  
X4 = [0.0552
      0.0379
      0.2376
      0.0224
      0.7427
      0.3206
      0.5040
      0.3797
      0.4884
      0.0782
      0.0932];

%% INPUTS - TAXAS DE HERBIVORIA ===========================================
if LF==1;fprintf('>> Variables startup ................... ');end
%  [Mali ,Peix ,Levi ,Camp]
H =[X1(1),X2(1),X3(1),X4(1)]; % herbivoria média por iteração nas folhas
Hb=[X1(2),X2(2),X3(2),X4(2)]; % herbivoria média por iteração nos botões
Hf=[X1(3),X2(3),X3(3),X4(3)]; % herbivoria média por iteração nas flores
Hs=[X1(4),X2(4),X3(4),X4(4)]; % herbivoria média por iteração nos frutos

%% INPUTS - TAXAS DE BOTÕES => FLORES =====================================
M_tmb(1)=X1(5); % multiplicador da TRANSFER_MB de malifolia
M_tmb(2)=X2(5); % multiplicador da TRANSFER_MB de peixotoa
M_tmb(3)=X3(5); % multiplicador da TRANSFER_MB de laevifolia
M_tmb(4)=X4(5); % multiplicador da TRANSFER_MB de campestris

%% INPUTS - TAXAS DE FLORES => FRUTOS =====================================
%  [Mali,Peix,Laev,Camp], valores percentuais
V1=[29.3,43.5,1.8 ,1.7 ]/100;  % taxa de (flores -> frutos) SEM polinizador
V2=[31.9,22.0,30.1,51.9]/100;  % taxa de (flores -> frutos) COM polinizador
dV=[1.00,1.00,1.00,1.00]/100;  % desvio simétrico da média

%        [Mali,Peix,Laev,Camp], valores percentuais
% mod_POLI=[-4.0,+0.0,-17 ,+7.0]/100;     V2=V2+mod_POLI;
% mod_HERB=[-1.0,-10 ,-4.0,+3.0]/100;     H = H+mod_HERB;

% Correção dos valores para otimização
Ms=[X1(6),X2(6),X3(6),X4(6)];      % multiplicador SEM polinizador
Mc=[X1(7),X2(7),X3(7),X4(7)];      % multiplicador COM polinizador

%% INPUTS - TAXAS DE FRUTOS VIÁVEIS =======================================
M_tmf(1)=X1(8); % multiplicador da TRANSFER_FRUTOS de malifolia
M_tmf(2)=X2(8); % multiplicador da TRANSFER_FRUTOS de peixotoa
M_tmf(3)=X3(8); % multiplicador da TRANSFER_FRUTOS de laevifolia
M_tmf(4)=X4(8); % multiplicador da TRANSFER_FRUTOS de campestris

%% INPUTS - DESVIOS SIMÉTRICOS IMPOSTOS ÀS CONSTANTES =====================
if RorN==0
    V2Hv=0.000;     % desvio simétrico de herbivoria nas folhas
    V2Hb=0.000;     % desvio simétrico de herbivoria nos botões
    V2Hf=0.000;     % desvio simétrico de herbivoria nas flores
    V2Hs=0.000;     % desvio simétrico de herbivoria nos frutos
elseif RorN==1
    V2Hv=0.030;     % desvio simétrico de herbivoria nas folhas
    V2Hb=0.030;     % desvio simétrico de herbivoria nos botões
    V2Hf=0.030;     % desvio simétrico de herbivoria nas flores
    V2Hs=0.030;     % desvio simétrico de herbivoria nos frutos
end

%% INPUTS - TAXAS PERCENTUAIS DE VARIAÇÃO ALEATÓRIA NAS BASELINES =========
if RorN==0
    TR1=0.00;   	% taxa de variação randômica das chuvas
    TR2=0.00;       % taxa da variação randômica das floradas
    TR3=0.00;       % taxa de variação randômica dos brotamentos
elseif RorN==1
    TR1=0.130;      % taxa de variação randômica das chuvas
    TR2=0.130;      % STD da variação randômica das floradas
    TR3=0.130;      % taxa de variação randômica dos brotamentos
end

%% INPUTS - PORCENTAGEM DOS ELEMENTOS DA MATRIZ ATINGIDOS POR ITERAÇÃO ====
if RorN==0
    pH=1;       % '%' de elementos atingidos por herbivoria
    pP=1;       % '%' de elementos polinizados/autofecundados por iteração
elseif RorN==1
    pH=0.90;    % '%' de elementos atingidos por herbivoria
    pP=0.90;    % '%' de elementos polinizados/autofecundados por iteração
end

%% INPUTS - VARIAÇÕES DA INFLUÊNCIA DA FLORADA POR ESPÉCIE ================
V2Em=X1(9);  % multiplicador da florada (botões) de malifolia
V2Ep=X2(9);  % multiplicador da florada (botões) de peixotoa
V2El=X3(9);  % multiplicador da florada (botões) de laevifolia
V2Ec=X4(9);  % multiplicador da florada (botões) de campestris

%% INPUTS - VARIAÇÕES DA INFLUÊNCIA DAS CHUVAS POR ESPÉCIE ================
IC(1)=X1(10); % influência das chuvas na malifolia
IC(2)=X2(10); % influência das chuvas na peixotoa
IC(3)=X3(10); % influência das chuvas na laevifolia
IC(4)=X4(10); % influência das chuvas na campestris

%% INPUTS - VARIAÇÕES DA INFLUÊNCIA DO BROTAMENTO FOLIAR POR ESPÉCIE ======
IE(1)=X1(11); % influência do brotamento na malifolia
IE(2)=X2(11); % influência do brotamento na peixotoa
IE(3)=X3(11); % influência do brotamento na laevifolia
IE(4)=X4(11); % influência do brotamento na campestris

%% INPUTS - BASELINES =====================================================
% Valores de máximo medidos em campo!
% Considerando os valores medidos em campo como baseline, tomamos esta
% referência como valendo "1", após parametrização, e tomamos o valor de
% máximo durante as medidas como referência. Após a simulação,
% multiplica-se o valor percentual de cada espécie (1=100%) pelo seu máximo
% para estimar um valor numérico para cada espécie (matriz REF, de valores
% de "referência").

%      bot.  flo.  fru.
FIELD=load('field_data.mat'); % field data are not public, see README.md
REF = FIELD.CSV_Method.REF;  % rows: malifolia, peixotoa, laevifolia, campestris

%% INPUTS - ESPÉCIES DE PLANTA ============================================
% Propriedades de cada espécie medidas no campo e/ou estimadas por meio de
% observações de campo. X e Y são o tamanho de cada planta, RO é a
% densidade foliar (volume de folhas por volume ocupado) e Nº de plantas 
% de cada espécie no cenário.
%        (x,    y,    ro,   nº)
plantas= [3,    3,    1,    50;     % MALIFOLIA
          1,    2,    1,    50;     % PEIXOTOA
          2,    2,    1,    30;     % LEVIFOLIA
          1,    1,    1,    40];    % CAMPESTRIS

%% INICIALIZAÇÃO DAS MATRIZES DAS VARIÁVEIS DE CAMPO ======================
MV = zeros(nex,ney,4);          % matriz de folhas
MB = zeros(nex,ney,4);          % matriz de botões
MF = zeros(nex,ney,4);          % matriz de flores
MS = zeros(nex,ney,4);          % matriz de frutos
if LF==1;fprintf('OK!\n');end

%% ------------------------------------------------------------------------
%% PRÉ-PROCESSAMENTO
%% ------------------------------------------------------------------------

%% GERAÇÃO DA POPULAÇÃO INICIAL DE PLANTAS (pré-processamento) ============
if LF==1;fprintf('>> Scenario startup .................... ');end
[MV]=cenario_plantas(MV,plantas,nex,ney);
if LF==1;fprintf('OK!\n');end

%% GERAÇÃO DAS CHUVAS (pré-processamento) =================================
if LF==1;fprintf('>> Rain baseline creation .............. ');end
[C]=chuvas(T,dT,TR1,V1C,V2C);
if LF==1;fprintf('OK!\n');end

%% GERAÇÃO DAS ESTAÇÕES DE FLORADA - BOTÕES (pré-processamento) ===========
if LF==1;fprintf('>> Flowering baseline creation ......... ');end
[F]=botoes(T,dT,TR2,V1Em,V1Ep,V1El,V1Ec,V2Em,V2Ep,V2El,V2Ec);
if LF==1;fprintf('OK!\n');end

%% GERAÇÃO DAS ESTAÇÕES DE BROTAÇÃO FOLIAR (pré-processamento) ============
if LF==1;fprintf('>> Leaf sprouting baseline creation .... ');end
[E]=brotamentos(T,dT,TR3);
if LF==1;fprintf('OK!\n');end

%% GERAÇÃO DAS POPULAÇÕES INICIAIS DE BOTÕES, FLORES E FRUTOS (startup) ===
if LF==1;fprintf('>> Scenario initialization ............. ');end
[MV,MB,MF,MS]=cenario_global(MV,MB,MF,MS,C,V1,E,F);
if LF==1;fprintf('OK!\n');end

%% PLOTA CENÁRIO INICIAL E ITRERAÇÕES (exporta cenário inicial) ===========
if pts==2;
    if LF==1;fprintf('>> Exporting initial scenario .......... ');end
    cenario_plot(MV,MB,MF,MS); figure;
    if LF==1;fprintf('OK!\n');end
end

%% ------------------------------------------------------------------------
%% SOLVER
%% ------------------------------------------------------------------------

%% EVOLUÇÃO DO MODELO NO TEMPO (solver) ===================================
if LF==1;fprintf('>> Solving the model ................... ');end
[mV,mB,mF,mS]=evolucao(MV,MB,MF,MS,C,T,IC,dT,H,pH,pP,E,F,nex,ney,pts,...
    V2Hv,V2Hb,V2Hf,V2Hs,V1,V2,dV,Hb,Hf,Hs,IE,Ms,Mc,M_tmb,M_tmf);
if LF==1;fprintf('OK!\n');end

%% PREPARAÇÃO DOS DADOS DE CAMPO PARA COMPARAÇÃO ==========================
if LF==1;fprintf('>> Preparing real field data ........... ');end
[cV,cB,cF,cS]=campo_real(T,dT);
if LF==1;fprintf('OK!\n');end

%% ------------------------------------------------------------------------
%% PÓS-PROCESSAMENTO
%% ------------------------------------------------------------------------

%% CÁLCULO DAS ESTATÍSTICAS DAS CURVAS E ENTRE AS CURVAS ==================
if LF==1;fprintf('>> Computing data statistics ........... ');end
[Erro,Erro_Quad,Rms,Rsk,Rku,RmsE,RskE,RkuE,INT,INT_EQ,Eperc,...
    E_Rms,E_Rsk,E_Rku]=resposta_stat(mV,mB,mF,mS,cV,cB,cF,cS,T,dT,...
    flag3,flag4,flag9);
if LF==1;fprintf('OK!\n');end

%% EXPORTAÇÃO DE RESULTADOS ===============================================
if flag2==1
    if LF==1;fprintf('>> Exporting results ................... ');end
    resposta_export(mV,mB,mF,mS,cV,cB,cF,cS,nex,ney,...
        Erro,Erro_Quad,Rms,Rsk,Rku,INT,INT_EQ,Eperc,T,dT,plantas)
    if LF==1;fprintf('OK!\n');end
end

%% DISPLAY DO INTERVALO DE CONFIANÇA DA RESPOSTA ==========================
if flag5==1
    if LF==1;fprintf('>> Confidence interval display ......... ');end
    confidence_interval(mB,mF,mS,cB,cF,cS,T,dT,CIM,flag9)
    if LF==1;fprintf('OK!\n');end
end

%% DISPLAY DE RESULTADOS GRÁFICOS =========================================
if flag6==1
    if LF==1;fprintf('>> Result display ...................... ');end
    resposta_plot(mV,mB,mF,mS,REF,flag1)
    if LF==1;fprintf('OK!\n');end
end

%% DISPLAY DE RESULTADOS NUMÉRICOS NORMALIZADOS ===========================
if LF==1 && flag8==1;
fprintf('>> Squared simulation errors ........... OK!\n\n');end
if LF==1 && flag8==1;   saida=cell(4,5);
saida(1,1)={'Sim Data'};saida(1,2)={'B. mali.'};saida(1,3)={'P. tome.'};
saida(1,4)={'B. laev.'};saida(1,5)={'B. camp.'};saida(2,1)={'F. Buds'};
saida(3,1)={'Flowers'}; saida(4,1)={'Fruits'};
saida(2,2)={INT_EQ(2,1)};saida(3,2)={INT_EQ(3,1)};saida(4,2)={INT_EQ(4,1)};
saida(2,3)={INT_EQ(2,2)};saida(3,3)={INT_EQ(3,2)};saida(4,3)={INT_EQ(4,2)};
saida(2,4)={INT_EQ(2,3)};saida(3,4)={INT_EQ(3,3)};saida(4,4)={INT_EQ(4,3)};
saida(2,5)={INT_EQ(2,4)};saida(3,5)={INT_EQ(3,4)};saida(4,5)={INT_EQ(4,4)};
mse=(INT_EQ(2,1)+INT_EQ(3,1)+INT_EQ(4,1)+INT_EQ(2,2)+INT_EQ(3,2)+...
    INT_EQ(4,2)+INT_EQ(2,3)+INT_EQ(3,3)+INT_EQ(4,3)+INT_EQ(2,4)+...
    INT_EQ(3,4)+INT_EQ(4,4)) / 12;
saida2=cell(1,2);saida2(1,1)={'Mean squared error'};saida2(1,2)={mse};
disp(saida');disp(saida2);
end

%% DISPLAY DO TIMER DE EXECUÇÃO ===========================================
if flag7==1;tempo=toc;end
if LF==1 && flag7==1;fprintf(strcat('>> Elapsed time is:\t',...
        num2str(tempo),' seconds ..... OK!\n'));end

%% EXPORTAÇÃO DE PARAMETROS PARA OTIMIZADOR EXTERNO =======================
% sim_ans1=sum(INT_EQ(2:4,1));
% sim_ans2=sum(INT_EQ(2:4,2));
% sim_ans3=sum(INT_EQ(2:4,3));
% sim_ans4=sum(INT_EQ(2:4,4));
% 
% 
% mali_f=sum(mF(:,1))%*REF(1,2)
% peix_f=sum(mF(:,2))%*REF(2,2)
% laev_f=sum(mF(:,3))%*REF(3,2)
% camp_f=sum(mF(:,4))%*REF(4,2)
% 
% mali_s=sum(mS(:,1))%*REF(1,2)
% peix_s=sum(mS(:,2))%*REF(2,2)
% laev_s=sum(mS(:,3))%*REF(3,2)
% camp_s=sum(mS(:,4))%*REF(4,2)
% 
% 
% xlswrite('Data6.xls',mF,'Flores')
% xlswrite('Data6.xls',mS,'Sementes')


%% FINALIZAÇÃO DO PROGRAMA E DO LOG FILE ==================================
if LF==1;fprintf('>> Finishing ........................... ');end
if LF==1;fprintf('OK!\n\n');end

%% ------------------------------------------------------------------------
%% FIM DO CÓDIGO
%% ------------------------------------------------------------------------



