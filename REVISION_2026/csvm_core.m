function out = csvm_core(opt)
% CSVM_CORE - batch version of the CSV Method simulator (CSV_Method.m)
%
% Runs the published CSVM model with no figures and no files written, so
% it can be called many times (replicates, scenarios, sensitivity runs).
% Model equations, field data and default parameters are the ones of
% CSV_Method.m (5th optimized values - robust). For the same random state
% the outputs are identical to the original script. Original files are
% not modified: cenario_plantas, cenario_global, campo_real and
% resposta_stat are called as they are; the computations of chuvas,
% botoes, brotamentos and evolucao are copied below as local functions,
% without the plots (those files print PNGs on every call).
%
% Additions to the original solver (they do not change the model):
%   - stage fluxes recorded at each step (grid sums, see 'flux' below)
%   - switches to remove the community flowering modifier from flower
%     herbivory and/or from cross pollination (scenario analysis only)
%   - optional per-cell maps
%
% USAGE
%   out = csvm_core;          % published defaults, current RNG state
%   out = csvm_core(opt);     % opt is a struct, every field is optional
%
% OPTIONS (opt.<field>, default in brackets)
%   seed      seed for rng(seed,twister'); [] keeps current state   [ [] ]
%   X         11x4 parameters, columns = [X1 X2 X3 X4]      [published]
%   T, dT     years and steps per year                       [05, 48]
%   nex, ney  grid elements in x and y                       [100, 100]
%   RorN      0 = normal inputs, 1 = random inputs           [1]
%   V1C       rainfall advance(+)/delay(-), in steps         [0]
%   V1E       1x4 flowering advance(+)/delay(-) per species  [0 0 0 0]
%   V2C       rainfall multiplier                            [1]
%   V1, V2    1x4 flower->fruit rates without/with pollinator [published]
%   dV        1x4 symmetric deviation of fruit set           [0.01]
%   TR        1x3 baseline noise [rain flowering sprouting]  [by RorN]
%   V2H       1x4 herbivory deviation [leaf bud flower fruit] [by RorN]
%   pH, pP    fraction of hits, herbivory / pollination      [by RorN]
%   phi_herb  community modifier divides flower herbivory    [true]
%   phi_poll  community modifier divides cross pollination   [true]
%   fluxes    record stage fluxes                            [true]
%   maps      return initial/final grids and cumulative maps [false]
%   plantas   4x4 plant table [x y ro n] per species       [published]
%
% OUTPUT (struct)
%   mV,mB,mF,mS  (dT*T)x4 mean state per occupied cell, as CSV_Method
%   cV,cB,cF,cS  field data prepared by campo_real
%   C, F, E      rainfall, flowering and leaf sprouting baselines
%   Erro, Erro_Quad, Rms, Rsk, Rku, RmsE, RskE, RkuE, INT, INT_EQ, Eperc,
%   E_Rms, E_Rsk, E_Rku   from resposta_stat (same as CSV_Method)
%   mse          mean of the 12 squared error integrals (buds to fruits),
%                the 'Mean squared error' printed by CSV_Method
%   REF, plantas reference maxima and plant table of CSV_Method
%   flux         grid sums per step (rows) and species (columns):
%                nocc (occupied cells), V B F S (stocks at step start),
%                Phi (total community flowering, before the max(1,.)),
%                B_in B_herb B_to_F B_clamp, F_herb F_to_S F_rand F_poll
%                F_self F_clamp, S_herb S_out S_clamp
%                Budgets: B(i+1)=B(i)+B_in-B_herb-B_to_F+B_clamp
%                         F(i+1)=F(i)+B_to_F-F_herb-F_to_S+F_clamp
%                         S(i+1)=S(i)+F_to_S-S_herb-S_out+S_clamp
%   maps         (if opt.maps) MV0 MB0 MF0 MS0 initial grids, MV MB MF MS
%                final grids, cumBF cumFS cumSout cumulative fluxes
%   opt          options actually used
%
% Species order: 'B. malifolia','P. tomentosa','B. laevifolia',
% 'B. campestris'.

%% OPTIONS ================================================================
if nargin<1 || isempty(opt); opt=struct; end

% 5th optimized values (robust), as in CSV_Method.m
X_pub=[0.0265  0.0346  0.0270  0.0552
       0.0395  0.1051  0.0871  0.0379
       0.1282  0.2704  0.2853  0.2376
       0.0300  0.0639  0.0265  0.0224
       0.6345  1.2799  1.0360  0.7427
       0.4017  1.8157  1.3047  0.3206
       0.9038  1.0358  1.8455  0.5040
       0.4807  1.0896  0.8688  0.3797
       0.4355  0.8610  0.5031  0.4884
       0.0886  0.1498  0.1211  0.0782
       0.1225  0.1654  0.1354  0.0932];

seed = getopt(opt,'seed',[]);
X    = getopt(opt,'X',X_pub);
T    = getopt(opt,'T',05);
dT   = getopt(opt,'dT',48);
nex  = getopt(opt,'nex',100);
ney  = getopt(opt,'ney',100);
RorN = getopt(opt,'RorN',1);
V1C  = getopt(opt,'V1C',0);
V1E  = getopt(opt,'V1E',[0 0 0 0]);
V2C  = getopt(opt,'V2C',1);
V1   = getopt(opt,'V1',[29.3,43.5,1.8 ,1.7 ]/100);
V2   = getopt(opt,'V2',[31.9,22.0,30.1,51.9]/100);
dV   = getopt(opt,'dV',[1.00,1.00,1.00,1.00]/100);
if RorN==0
    TR  = getopt(opt,'TR',[0.00 0.00 0.00]);
    V2H = getopt(opt,'V2H',[0.000 0.000 0.000 0.000]);
    pH  = getopt(opt,'pH',1);
    pP  = getopt(opt,'pP',1);
else
    TR  = getopt(opt,'TR',[0.130 0.130 0.130]);
    V2H = getopt(opt,'V2H',[0.030 0.030 0.030 0.030]);
    pH  = getopt(opt,'pH',0.90);
    pP  = getopt(opt,'pP',0.90);
end
phi_herb = getopt(opt,'phi_herb',true);
phi_poll = getopt(opt,'phi_poll',true);
do_flux  = getopt(opt,'fluxes',true);
do_maps  = getopt(opt,'maps',false);

%% PARAMETERS (same mapping as CSV_Method.m) ==============================
H     = X(1,:);    % herbivoria media por iteracao nas folhas
Hb    = X(2,:);    % herbivoria media por iteracao nos botoes
Hf    = X(3,:);    % herbivoria media por iteracao nas flores
Hs    = X(4,:);    % herbivoria media por iteracao nos frutos
M_tmb = X(5,:);    % multiplicador da TRANSFER_MB
Ms    = X(6,:);    % multiplicador SEM polinizador
Mc    = X(7,:);    % multiplicador COM polinizador
M_tmf = X(8,:);    % multiplicador da TRANSFER_FRUTOS
V2E   = X(9,:);    % multiplicador da florada (botoes)
IC    = X(10,:);   % influencia das chuvas
IE    = X(11,:);   % influencia do brotamento

%      bot.  flo.  fru.
FIELD=load('field_data.mat'); % field data are not public, see README.md
REF = FIELD.CSV_Method.REF;  % rows: malifolia, peixotoa, laevifolia, campestris

%        (x,    y,    ro,   n)
plantas= [3,    3,    1,    50;     % MALIFOLIA
          1,    2,    1,    50;     % PEIXOTOA
          2,    2,    1,    30;     % LEVIFOLIA
          1,    1,    1,    40];    % CAMPESTRIS
plantas=getopt(opt,'plantas',plantas);

%% PRE-PROCESSING (same call order as CSV_Method.m) =======================
if ~isempty(seed); rng(seed,'twister'); end

MV = zeros(nex,ney,4);
MB = zeros(nex,ney,4);
MF = zeros(nex,ney,4);
MS = zeros(nex,ney,4);

[MV]=cenario_plantas(MV,plantas,nex,ney);
[C]=csvm_chuvas(T,dT,TR(1),V1C,V2C);
[F]=csvm_botoes(T,dT,TR(2),V1E(1),V1E(2),V1E(3),V1E(4),...
    V2E(1),V2E(2),V2E(3),V2E(4));
[E]=csvm_brotamentos(T,dT,TR(3));
[MV,MB,MF,MS]=cenario_global(MV,MB,MF,MS,C,V1,E,F);

%% SOLVER =================================================================
[mV,mB,mF,mS,flux,maps]=csvm_evolucao(MV,MB,MF,MS,C,T,IC,dT,H,pH,pP,...
    E,F,nex,ney,V2H(1),V2H(2),V2H(3),V2H(4),V1,V2,dV,Hb,Hf,Hs,IE,Ms,...
    Mc,M_tmb,M_tmf,phi_herb,phi_poll,do_flux,do_maps);

%% FIELD DATA AND STATISTICS ==============================================
[cV,cB,cF,cS]=campo_real(T,dT);
[Erro,Erro_Quad,Rms,Rsk,Rku,RmsE,RskE,RkuE,INT,INT_EQ,Eperc,...
    E_Rms,E_Rsk,E_Rku]=resposta_stat(mV,mB,mF,mS,cV,cB,cF,cS,T,dT,...
    0,0,0);
mse=(INT_EQ(2,1)+INT_EQ(3,1)+INT_EQ(4,1)+INT_EQ(2,2)+INT_EQ(3,2)+...
    INT_EQ(4,2)+INT_EQ(2,3)+INT_EQ(3,3)+INT_EQ(4,3)+INT_EQ(2,4)+...
    INT_EQ(3,4)+INT_EQ(4,4)) / 12;

%% OUTPUT =================================================================
out.mV=mV; out.mB=mB; out.mF=mF; out.mS=mS;
out.cV=cV; out.cB=cB; out.cF=cF; out.cS=cS;
out.C=C; out.F=F; out.E=E;
out.Erro=Erro; out.Erro_Quad=Erro_Quad;
out.Rms=Rms; out.Rsk=Rsk; out.Rku=Rku;
out.RmsE=RmsE; out.RskE=RskE; out.RkuE=RkuE;
out.INT=INT; out.INT_EQ=INT_EQ; out.Eperc=Eperc;
out.E_Rms=E_Rms; out.E_Rsk=E_Rsk; out.E_Rku=E_Rku;
out.mse=mse;
out.REF=REF; out.plantas=plantas;
out.flux=flux;
out.maps=maps;
out.opt=struct('seed',seed,'X',X,'T',T,'dT',dT,'nex',nex,'ney',ney,...
    'RorN',RorN,'V1C',V1C,'V1E',V1E,'V2C',V2C,'V1',V1,'V2',V2,'dV',dV,...
    'TR',TR,'V2H',V2H,'pH',pH,'pP',pP,'phi_herb',phi_herb,...
    'phi_poll',phi_poll,'fluxes',do_flux,'maps',do_maps,'plantas',plantas);


%% ========================================================================
function v = getopt(opt,name,default)
% Returns opt.(name) when present and not empty, the default otherwise.
if isfield(opt,name) && ~isempty(opt.(name))
    v = opt.(name);
else
    v = default;
end


%% ========================================================================
function [mV,mB,mF,mS,fx,maps]=csvm_evolucao(MV,MB,MF,MS,C,T,IC,dT,H,...
    pH,pP,E,F,nex,ney,V2Hv,V2Hb,V2Hf,V2Hs,V1,V2,dV,Hb,Hf,Hs,IE,Ms,Mc,...
    M_tmb,M_tmf,phi_herb,phi_poll,do_flux,do_maps)
% Copy of evolucao.m. Same equations and same sequence of random draws;
% the element-by-element limit loops are vectorized (identical results),
% the plot call is removed, and fluxes are recorded without touching the
% state matrices.

%% DECLARACAO DAS VARIAVEIS DE SAIDA
N=dT*T;
mV=zeros(N,4);mB=mV;mF=mV;mS=mV;
tranfer_BF=zeros(nex,ney,4);
tranfer_FS=tranfer_BF;
transfer_frutos=tranfer_BF;
V2_new=V2;

fx=[];
if do_flux
    z=zeros(N,4);
    fx.nocc=z; fx.V=z; fx.B=z; fx.F=z; fx.S=z; fx.Phi=zeros(N,1);
    fx.B_in=z; fx.B_herb=z; fx.B_to_F=z; fx.B_clamp=z;
    fx.F_herb=z; fx.F_to_S=z; fx.F_rand=z; fx.F_poll=z; fx.F_self=z;
    fx.F_clamp=z;
    fx.S_herb=z; fx.S_out=z; fx.S_clamp=z;
end
maps=[];
if do_maps
    maps.MV0=MV; maps.MB0=MB; maps.MF0=MF; maps.MS0=MS;
    maps.cumBF=zeros(nex,ney,4); maps.cumFS=maps.cumBF;
    maps.cumSout=maps.cumBF;
end

%% LOOP PRINCIPAL
for i=1:N

    %% CAPTURA DE RESPOSTA ================================================
    % media nos elementos com folhas (contagem sobre MV, como no original)
    for m=1:4
        nv=nnz(MV(:,:,m));
        mV(i,m)=sum(sum(MV(:,:,m)))/nv;
        mB(i,m)=sum(sum(MB(:,:,m)))/nv;
        mF(i,m)=sum(sum(MF(:,:,m)))/nv;
        mS(i,m)=sum(sum(MS(:,:,m)))/nv;
        if do_flux
            fx.nocc(i,m)=nv;
            fx.V(i,m)=sum(sum(MV(:,:,m)));
            fx.B(i,m)=sum(sum(MB(:,:,m)));
            fx.F(i,m)=sum(sum(MF(:,:,m)));
            fx.S(i,m)=sum(sum(MS(:,:,m)));
        end
    end

    %% HERBIVORIA =========================================================
    naH=round(nex*ney*pH);
    kick=[rand(1,naH);rand(1,naH)]';
    kick(:,1)=kick(:,1)*(nex-1);
    kick(:,2)=kick(:,2)*(ney-1);
    kick=round(kick)+1;
    MH=zeros(nex,ney);
    MH(sub2ind([nex,ney],kick(:,1),kick(:,2)))=1;

    %% POLINIZACAO ========================================================
    naP=round(nex*ney*pP);
    kick=[rand(1,naP);rand(1,naP)]';
    kick(:,1)=kick(:,1)*(nex-1);
    kick(:,2)=kick(:,2)*(ney-1);
    kick=round(kick)+1;
    MP=zeros(nex,ney);
    MP(sub2ind([nex,ney],kick(:,1),kick(:,2)))=1;

    %% FOLHAS =============================================================
    for m=1:4
        MHv=MH.*(H(m) + rand(nex,ney)*V2Hv);
        MV(:,:,m)=MV(:,:,m)+...                         %o que tinha
            MV(:,:,m).*(-MHv+C(i)*IC(m)+E(i,m)*IE(m));  %variacao
        Vm=MV(:,:,m);
        Vm(Vm>1)=1;
        Vm(Vm<1E-9)=0;
        MV(:,:,m)=Vm;
    end

    %% BOTOES =============================================================
    for m=1:4
        MHb=MH.*(Hb(m) + rand(nex,ney)*V2Hb);
        tranfer_BF(:,:,m)=(MB(:,:,m)/2)*M_tmb(m);
        Bm=MB(:,:,m)+...                %o que tinha
            MB(:,:,m).*(-MHb)+...       %o que sai por herbivoria
            F(i,m)*MV(:,:,m)-...        %o que vem da florada
            tranfer_BF(:,:,m);          %o que vira flor
        Bc=Bm;
        Bc(Bc<1E-9)=0;
        if do_flux
            fx.B_in(i,m)=sum(sum(F(i,m)*MV(:,:,m)));
            fx.B_herb(i,m)=sum(sum(MB(:,:,m).*MHb));
            fx.B_to_F(i,m)=sum(sum(tranfer_BF(:,:,m)));
            fx.B_clamp(i,m)=sum(sum(Bc-Bm));
        end
        MB(:,:,m)=Bc;
    end

    %% FLORES =============================================================
    total_flowering=mF(i,1)+mF(i,2)+mF(i,3)+mF(i,4);
    if do_flux; fx.Phi(i)=total_flowering; end
    for m=1:4

        %herbivoria instantanea, CONSIDERANDO INTERACAO
        MHf=MH.*(Hf(m) + rand(nex,ney)*V2Hf);
        if total_flowering > 1 && phi_herb
            MHf=MHf/total_flowering;
        end

        %autofecundacao
        MAi=MP*V1(m)*Ms(m);

        %polinizacao, CONSIDERANDO INTERACAO
        if total_flowering > 1
            if phi_poll
                V2_new(m)=V2(m)/total_flowering;
                MPi=MP*V2_new(m)*Mc(m);
            else
                MPi=MP*V2(m)*Mc(m);
            end
        elseif total_flowering <= 1
            MPi=MP*V2(m)*Mc(m);
        end

        %frutos formados na semana 'i'
        Ur=dV(m)*rand(nex,ney);
        tranfer_FS(:,:,m)=MF(:,:,m).*(Ur + MPi + MAi);

        Fm=MF(:,:,m)+...                              %o que tinha
            MF(:,:,m).*(-MHf)-tranfer_FS(:,:,m)+...   %a variacao
            tranfer_BF(:,:,m);                        %o que vem dos botoes
        Fc=Fm;
        Fc(Fc<1E-9)=0;
        if do_flux
            fx.F_herb(i,m)=sum(sum(MF(:,:,m).*MHf));
            fx.F_to_S(i,m)=sum(sum(tranfer_FS(:,:,m)));
            fx.F_rand(i,m)=sum(sum(MF(:,:,m).*Ur));
            fx.F_poll(i,m)=sum(sum(MF(:,:,m).*MPi));
            fx.F_self(i,m)=sum(sum(MF(:,:,m).*MAi));
            fx.F_clamp(i,m)=sum(sum(Fc-Fm));
        end
        MF(:,:,m)=Fc;
    end

    %% FRUTOS =============================================================
    for m=1:4
        MHs=MH.*(Hs(m) + rand(nex,ney)*V2Hs);
        transfer_frutos(:,:,m)=(MS(:,:,m)/3)*M_tmf(m);
        Sm=MS(:,:,m)+...                 %o que tinha
            MS(:,:,m).*(-MHs)+...        %herbivorado
            tranfer_FS(:,:,m)-...        %o que vem das flores
            transfer_frutos(:,:,m);      %o que cai e nasce
        Sc=Sm;
        Sc(Sc<1E-9)=0;
        if do_flux
            fx.S_herb(i,m)=sum(sum(MS(:,:,m).*MHs));
            fx.S_out(i,m)=sum(sum(transfer_frutos(:,:,m)));
            fx.S_clamp(i,m)=sum(sum(Sc-Sm));
        end
        MS(:,:,m)=Sc;
    end

    if do_maps
        maps.cumBF=maps.cumBF+tranfer_BF;
        maps.cumFS=maps.cumFS+tranfer_FS;
        maps.cumSout=maps.cumSout+transfer_frutos;
    end
end

if do_maps
    maps.MV=MV; maps.MB=MB; maps.MF=MF; maps.MS=MS;
end



%% ========================================================================
function [C]=csvm_chuvas(T,dT,TR,V1C,V2C)
% Copy of the computation in chuvas.m (lines 16-135), figures removed.

%% PLUVIOSIDADE MENSAL MEDIDA NA UFU - INSTITUTO DE GEOGRAFIA =============
FIELD=load('field_data.mat'); % field data are not public, see README.md
a2008=FIELD.chuvas.a2008;

a2009=FIELD.chuvas.a2009;

a2010=FIELD.chuvas.a2010;

a2011=FIELD.chuvas.a2011;

a2012=FIELD.chuvas.a2012;

%% CRIACAO DO VETOR CLIMA "C" =============================================

%definicao da tendencia
C=(a2008+a2009+a2010+a2011+a2012)/5;
intermediario=zeros(T*length(C),1);

%% Introducao da aleatoriedade de TR percento =============================

% Parametrizacao
C=C/max(C); 

%extrapolacao para T anos
for i=1:T; 
    ra=randn(length(C),1)*TR;
    C2=C+ra;
    intermediario(length(C)*(i-1)+1:length(C)*i,1)=C2;
end

%% Ajustes finais =========================================================

%ajuste no inicio e final da curva
intermediario(1,1)=intermediario(2,1);
intermediario(end,1)=intermediario(end-1,1);

%interpolacao
fator=dT/length(C);
intermediario=interp(intermediario,fator);
C=intermediario;

%eliminacao de discrepancias
for i=1:T*dT
    if isnan(C(i))
        C(i)=C(i-1);
    end
end

%normalizacao
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

%% Remocao de pontos negativos ============================================

C(C<0)=0;


%% ========================================================================
function [F]=csvm_botoes(T,dT,TR,V1Em,V1Ep,V1El,V1Ec,V2Em,V2Ep,V2El,V2Ec)
% Copy of the computation in botoes.m (lines 10-172), figures removed.

%% Ajuste dos dados de floradas, parametrizacao ===========================

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


%% Extrapolacao e introducao da aleatoriedade =============================

%fator de interpolacao
fator=dT/length(malifolia);

%extrapolacao para T anos
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

%interpolacoes individuais
malifolia=interp(int1,fator);
peixotoa=interp(int2,fator);
laevifolia=interp(int3,fator);
campestris=interp(int4,fator);

%parametriza entre zero e um
malifolia=malifolia/max(malifolia);
peixotoa=peixotoa/max(peixotoa);
laevifolia=laevifolia/max(laevifolia);
campestris=campestris/max(campestris);


%% Aplicacao das variacoes forcadas nas baselines de floradas =============

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

%matriz de tendencias de floradas reais
F=[malifolia';peixotoa';laevifolia';campestris']';

%retira elementos nulos
for i=1:4
    for j=1:length(campestris)
        if F(j,i)<0
            F(j,i)=0;
        end
    end
end


%% ========================================================================
function [E]=csvm_brotamentos(T,dT,TR)
% Copy of the computation in brotamentos.m (lines 9-145), figures removed.

%% ajuste dos dados de brotamentos, parametrizacao ========================

%2012 / 2013
FIELD=load('field_data.mat'); % field data are not public, see README.md
malifolia=1./FIELD.brotamentos.malifolia;

peixotoa= 1./FIELD.brotamentos.peixotoa;
       
laevifolia=1./FIELD.brotamentos.laevifolia;
       
campestris=1./FIELD.brotamentos.campestris;
       
% int_E=[malifolia';peixotoa';laevifolia';campestris']';

%% Derivando para passar da quantidade de folhas para a taxa de variacao
% 
% %vetor de tempos para serem derivados
% tempo=linspace(0,T,length(malifolia))';
% 
% %derivada numerica
% dmali = diff(malifolia) ./diff(tempo);
% dpeix = diff(peixotoa)  ./diff(tempo);
% dlaev = diff(laevifolia)./diff(tempo);
% dcamp = diff(campestris)./diff(tempo);
% 
% %ajuste do ultimo elemento
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

%% Interpolacao dos dados =================================================
       
%extrapolacao para T anos
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

%fator de interpolacao
fator=dT/length(malifolia);

%interpolacoes individuais
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

%matriz de tendencias de brotamentos reais
E=[malifolia';peixotoa';laevifolia';campestris']';
