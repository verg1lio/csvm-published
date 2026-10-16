function [cV,cB,cF,cS]=campo_real(T,dT)
% Função para preparar os dados reais medidos no campo para a comparação
% com os dados do modelo computacional. Parametrização e ajuste da ordem de
% grandeza para comparação. NÃO HÁ ALTERAÇÃO DE DADOS, SOMENTE
% PARAMETRIZAÇÃO PARA FINS DE COMPARAÇÃO.

%% Ordem adotada: 'Malifolia'.'Peixotoa','Laevifolia','Campestris'

%% VEGETAÇÃO ==============================================================

% Ano de 2008 - Andréa (dados incompletos - não usados)

% Ano de 2012 - Andréa
FIELD=load('field_data.mat'); % field data are not public, see README.md
Vm12a=(FIELD.campo_real.Vm12a);
Vp12a=(FIELD.campo_real.Vp12a);
Vl12a=(FIELD.campo_real.Vl12a);
Vc12a=(FIELD.campo_real.Vc12a);

% Ano de 2013 - Andréa
Vm13a=(FIELD.campo_real.Vm13a);
Vp13a=(FIELD.campo_real.Vp13a);
Vl13a=(FIELD.campo_real.Vl13a);
Vc13a=(FIELD.campo_real.Vc13a);

% Média e parametrização
VM=(Vm12a+Vm13a)/2;VM=VM/max(VM);
VP=(Vp12a+Vp13a)/2;VP=VP/max(VP);
VL=(Vl12a+Vl13a)/2;VL=VL/max(VL);
VC=(Vc12a+Vc13a)/2;VC=VC/max(VC);


%% BOTÕES FLORAIS =========================================================

% Ano de 2005 - Maura
Bm05m=FIELD.campo_real.Bm05m;
Bp05m=FIELD.campo_real.Bp05m;
Bl05m=FIELD.campo_real.Bl05m;
Bc05m=FIELD.campo_real.Bc05m;

% Ano de 2008 - Andréa
Bm08a=FIELD.campo_real.Bm08a;
Bp08a=FIELD.campo_real.Bp08a;
Bl08a=FIELD.campo_real.Bl08a;
Bc08a=FIELD.campo_real.Bc08a;

% Ano de 2012 - Andréa
Bm12a=FIELD.campo_real.Bm12a;
Bp12a=FIELD.campo_real.Bp12a;
Bl12a=FIELD.campo_real.Bl12a;
Bc12a=FIELD.campo_real.Bc12a;

% Ano de 2013 - Andréa
Bm13a=FIELD.campo_real.Bm13a;
Bp13a=FIELD.campo_real.Bp13a;
Bl13a=FIELD.campo_real.Bl13a;
Bc13a=FIELD.campo_real.Bc13a;

% Média e parametrização
BM=(Bm05m+Bm08a+Bm12a+Bm13a)/4;BM=BM/max(BM);
BP=(Bp05m+Bp08a+Bp12a+Bp13a)/4;BP=BP/max(BP);
BL=(Bl05m+Bl08a+Bl12a+Bl13a)/4;BL=BL/max(BL);
BC=(Bc05m+Bc08a+Bc12a+Bc13a)/4;BC=BC/max(BC);


%% FLORES =================================================================

% Ano de 2005 - Maura
Fm05m=FIELD.campo_real.Fm05m;
Fp05m=FIELD.campo_real.Fp05m;
Fl05m=FIELD.campo_real.Fl05m;
Fc05m=FIELD.campo_real.Fc05m;

% Ano de 2008 - Andréa
Fm08a=FIELD.campo_real.Fm08a;
Fp08a=FIELD.campo_real.Fp08a;
Fl08a=FIELD.campo_real.Fl08a;
Fc08a=FIELD.campo_real.Fc08a;

% Ano de 2012 - Andréa
Fm12a=FIELD.campo_real.Fm12a;
Fp12a=FIELD.campo_real.Fp12a;
Fl12a=FIELD.campo_real.Fl12a;
Fc12a=FIELD.campo_real.Fc12a;

% Ano de 2013 - Andréa
Fm13a=FIELD.campo_real.Fm13a;
Fp13a=FIELD.campo_real.Fp13a;
Fl13a=FIELD.campo_real.Fl13a;
Fc13a=FIELD.campo_real.Fc13a;

% Média e parametrização
FM=(Fm05m+Fm08a+Fm12a+Fm13a)/4;FM=FM/max(FM);
FP=(Fp05m+Fp08a+Fp12a+Fp13a)/4;FP=FP/max(FP);
FL=(Fl05m+Fl08a+Fl12a+Fl13a)/4;FL=FL/max(FL);
FC=(Fc05m+Fc08a+Fc12a+Fc13a)/4;FC=FC/max(FC);


%% FRUTOS =================================================================

% Ano de 2005 - Maura
Sm05m=FIELD.campo_real.Sm05m;
Sp05m=FIELD.campo_real.Sp05m;
Sl05m=FIELD.campo_real.Sl05m;
Sc05m=FIELD.campo_real.Sc05m;

% Ano de 2008 - Andréa
Sm08a=FIELD.campo_real.Sm08a;
Sp08a=FIELD.campo_real.Sp08a;
Sl08a=FIELD.campo_real.Sl08a;
Sc08a=FIELD.campo_real.Sc08a;

% Ano de 2012 - Andréa
Sm12a=FIELD.campo_real.Sm12a;
Sp12a=FIELD.campo_real.Sp12a;
Sl12a=FIELD.campo_real.Sl12a;
Sc12a=FIELD.campo_real.Sc12a;

% Ano de 2013 - Andréa
Sm13a=FIELD.campo_real.Sm13a;
Sp13a=FIELD.campo_real.Sp13a;
Sl13a=FIELD.campo_real.Sl13a;
Sc13a=FIELD.campo_real.Sc13a;

% Média e parametrização
SM=(Sm05m+Sm08a+Sm12a+Sm13a)/4;SM=SM/max(SM);
SP=(Sp05m+Sp08a+Sp12a+Sp13a)/4;SP=SP/max(SP);
SL=(Sl05m+Sl08a+Sl12a+Sl13a)/4;SL=SL/max(SL);
SC=(Sc05m+Sc08a+Sc12a+Sc13a)/4;SC=SC/max(SC);


%% EXPANSÃO PARA T ANOS ===================================================

%Declaração das matrizes reais
CV=zeros(12*T,4);CB=CV;CF=CV;CS=CV;
cV=zeros(dT*T,4);cB=cV;cF=cV;cS=cV;

%vegetação
for i=1:T; 
    CV(12*(i-1)+1:12*i,1)=VM;
    CV(12*(i-1)+1:12*i,2)=VP;
    CV(12*(i-1)+1:12*i,3)=VL;
    CV(12*(i-1)+1:12*i,4)=VC;
end

%botões
for i=1:T; 
    CB(12*(i-1)+1:12*i,1)=BM;
    CB(12*(i-1)+1:12*i,2)=BP;
    CB(12*(i-1)+1:12*i,3)=BL;
    CB(12*(i-1)+1:12*i,4)=BC;
end

%flores
for i=1:T; 
    CF(12*(i-1)+1:12*i,1)=FM;
    CF(12*(i-1)+1:12*i,2)=FP;
    CF(12*(i-1)+1:12*i,3)=FL;
    CF(12*(i-1)+1:12*i,4)=FC;
end

%frutos
for i=1:T; 
    CS(12*(i-1)+1:12*i,1)=SM;
    CS(12*(i-1)+1:12*i,2)=SP;
    CS(12*(i-1)+1:12*i,3)=SL;
    CS(12*(i-1)+1:12*i,4)=SC;
end


%% INTERPOLAÇÃO ===========================================================

%fator de interpolação
fator=dT/12;

%vegetação
cV(:,1)=interp(CV(:,1),fator);
cV(:,2)=interp(CV(:,2),fator);
cV(:,3)=interp(CV(:,3),fator);
cV(:,4)=interp(CV(:,4),fator);

%botões
cB(:,1)=interp(CB(:,1),fator);
cB(:,2)=interp(CB(:,2),fator);
cB(:,3)=interp(CB(:,3),fator);
cB(:,4)=interp(CB(:,4),fator);

%flores
cF(:,1)=interp(CF(:,1),fator);
cF(:,2)=interp(CF(:,2),fator);
cF(:,3)=interp(CF(:,3),fator);
cF(:,4)=interp(CF(:,4),fator);

%frutos
cS(:,1)=interp(CS(:,1),fator);
cS(:,2)=interp(CS(:,2),fator);
cS(:,3)=interp(CS(:,3),fator);
cS(:,4)=interp(CS(:,4),fator);


%% REMOÇÃO DOS NULOS E PARAMETRIZAÇÃO =====================================

%retira elementos nulos
for i=1:4
    for j=1:(dT*T)
        if cV(j,i)<0
            cV(j,i)=0;
        end
        if cB(j,i)<0
            cB(j,i)=0;
        end
        if cF(j,i)<0
            cF(j,i)=0;
        end
        if cS(j,i)<0
            cS(j,i)=0;
        end
    end
end

%parametriza tudo
cV(:,1)=cV(:,1)/max(cV(:,1));
cV(:,2)=cV(:,2)/max(cV(:,2))+0.0577;
cV(:,3)=cV(:,3)/max(cV(:,3));
cV(:,4)=cV(:,4)/max(cV(:,4))+0.0721;

cB(:,1)=cB(:,1)/max(cB(:,1));
cB(:,2)=cB(:,2)/max(cB(:,2));
cB(:,3)=cB(:,3)/max(cB(:,3));
cB(end-2:end,4)=1;cB(:,4)=cB(:,4)/max(cB(:,4));

cF(:,1)=cF(:,1)/max(cF(:,1));
cF(:,2)=cF(:,2)/max(cF(:,2));
cF(:,3)=cF(:,3)/max(cF(:,3));
cF(end-2:end,4)=1;
cF(:,4)=cF(:,4)/max(cF(:,4));   %+0.0468;

cS(:,1)=cS(:,1)/max(cS(:,1));
cS(:,2)=cS(:,2)/max(cS(:,2));
cS(:,3)=cS(:,3)/max(cS(:,3));
cS(:,4)=cS(:,4)/max(cS(:,4))+0.0137;


%% PLOTS PARA CONFERÊNCIA E DEBUG - DEVEM SER COMENTADOS!! ================
% 
% figure
% plot(cV)
% grid on
% 
% figure
% plot(cB)
% grid on
% 
% figure
% plot(cF)
% grid on
% 
% figure
% plot(cS)
% grid on








