function main

%% INICIALIZAÇÃO ==========================================================
clear all; close all; clc;format long   % inicializa o programa

%% INPUTS - PARÂMETROS DO CENÁRIO =========================================

%% Nºo de otimizações
n_iter=25;

%% VTR          "Value To Reach" (stop when ofunc < VTR)
VTR = 0;

%% D            number of parameters of the objective function 
D = 11;

%% XVmin,XVmax  vector of lower and bounds of initial population
%               The algorithm seems to work well only if [XVmin,XVmax] 
%               covers the region where the global minimum is expected
%               *** note: these are no bound constraints!! ***

OB=[0.02    0.09    % Leaves        weekly herbivory
    0.03    0.10    % Floral buds   weekly herbivory
    0.05    0.20    % Flowers       weekly herbivory
    0.01    0.10    % Seeds         weekly herbivory
    0.75    1.20    % Transf_MB     weekly multiplier
    0.80    1.20    % Transf_FS     weekly multiplier - WITHOUT POLLINATORS
    0.80    1.20    % Transf_FS     weekly multiplier - WITH POLLINATORS
    0.50    1.10    % Transf_S      weekly multiplier
    0.45    0.75    % Flowering     influence of baselines
    0.06    0.10    % Rainfall      influence of baselines
    0.055   0.12];  % Sprouting     influence of baselines

XVmin=OB(:,1)';     XVmax=OB(:,2)';

%% y             problem data vector (remains fixed during optimization)
y = [];

%% NP            number of population members
NP = 55;

%% itermax       maximum number of iterations (generations)
itermax = 30;

%% F             DE-stepsize F ex [0, 2]
F = 0.8;

%% CR            crossover probabililty constant ex [0, 1]
CR = 0.8;

%% strategy      1 --> DE/best/1/exp           6 --> DE/best/1/bin
%                2 --> DE/rand/1/exp           7 --> DE/rand/1/bin
%                3 --> DE/rand-to-best/1/exp   8 --> DE/rand-to-best/1/bin
%                4 --> DE/best/2/exp           9 --> DE/best/2/bin
%                5 --> DE/rand/2/exp           else  DE/rand/2/bin
strategy = 7;

%% refresh      intermediate output will be produced after "refresh"
%               iterations. No intermediate output will be produced
%               if refresh is < 1
refresh = 1;

%% PROGRAM MAIN LOOP ======================================================
X_DE = zeros(n_iter,D); F_DE = zeros(1,n_iter); NF_DE = zeros(1,n_iter);

figure;
color = get(gca,'ColorOrder');
k = 1;
for ii = 1:n_iter
    
    [X,FO,NF] = differential_evolution('eval_objective',VTR,D,XVmin,...
        XVmax,y,NP,itermax,F,CR,strategy,refresh);
    
    X_DE(ii,:) = X;
    F_DE(ii)   = FO;
    NF_DE(ii)  = NF;
    
    load process.txt;

    stairs(process(:,1),process(:,2),'Color',color(k,:));
    hold on;
    
    k = k + 1;
    if k == 8
        k = 1;
    end
    
    beep;pause(0.5);beep;pause(0.1);beep;pause(0.1);beep;pause(0.6);
    beep;pause(0.3);beep;pause(0.3);
    
end


xlswrite('OPT_mali.xls',X_DE,'X_DE')
xlswrite('OPT_mali.xls',F_DE,'F_DE')
xlswrite('OPT_mali.xls',NF_DE,'NF_DE')

X_DE
F_DE
NF_DE

set(gca,'FontName','Times New Roman');
xlabel('Iteração');
ylabel('Valor ótimo da função objetivo');



