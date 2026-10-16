function resposta_export(mV,mB,mF,mS,cV,cB,cF,cS,nex,ney,...
        Erro,Erro_Quad,Rms2,Rsk2,Rku2,INT2,INT_EQ2,Eperc2,T,dT,plantas)
% Exporta os dados simulados e reais para um arquivo externo tipo .xls

%% Startup
warning off all
[linhas,~]=size(mV);


%% Monta as integrais no formato certo
INT=cell(5,4);
INT(1,:)={'Leafs','Buttons','Flowers','Frutos'};
INT(2:5,:)=num2cell(INT2);


%% Monta RMS
Rms=cell(5,4);
Rms(1,:)={'Leafs','Buttons','Flowers','Frutos'};
Rms(2:5,:)=num2cell(Rms2);


%% Monta RSK
Rsk=cell(5,4);
Rsk(1,:)={'Leafs','Buttons','Flowers','Frutos'};
Rsk(2:5,:)=num2cell(Rsk2);


%% Monta RKU
Rku=cell(5,4);
Rku(1,:)={'Leafs','Buttons','Flowers','Frutos'};
Rku(2:5,:)=num2cell(Rku2);


%% Monta as integrais do erro quadrático no formato certo
INT_EQ=cell(5,4);
INT_EQ(1,:)={'Leafs','Buttons','Flowers','Frutos'};
INT_EQ(2:5,:)=num2cell(INT_EQ2);


%% Monta o erro percentual no formato certo
Eperc=cell(5,4);
Eperc(1,:)={'Leafs','Buttons','Flowers','Frutos'};
Eperc(2:5,:)=num2cell(Eperc2);

%% Monta os desvios entre a simulação e o real

%Folhas
EFOLHAS=cell(linhas+1,4);
EFOLHAS(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
EFOLHAS(2:end,:)=num2cell((Erro(1:4,:))');

%Botoes
EBOTOES=cell(linhas+1,4);
EBOTOES(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
EBOTOES(2:end,:)=num2cell((Erro(5:8,:))');

%Flores
EFLORES=cell(linhas+1,4);
EFLORES(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
EFLORES(2:end,:)=num2cell((Erro(9:12,:))');

%Frutos
EFRUTOS=cell(linhas+1,4);
EFRUTOS(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
EFRUTOS(2:end,:)=num2cell((Erro(13:16,:))');

%% Monta os desvios quadráticos entre a simulação e o real

%Folhas
QFOLHAS=cell(linhas+1,4);
QFOLHAS(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
QFOLHAS(2:end,:)=num2cell((Erro_Quad(1:4,:))');

%Botoes
QBOTOES=cell(linhas+1,4);
QBOTOES(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
QBOTOES(2:end,:)=num2cell((Erro_Quad(5:8,:))');

%Flores
QFLORES=cell(linhas+1,4);
QFLORES(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
QFLORES(2:end,:)=num2cell((Erro_Quad(9:12,:))');

%Frutos
QFRUTOS=cell(linhas+1,4);
QFRUTOS(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
QFRUTOS(2:end,:)=num2cell((Erro_Quad(13:16,:))');


%% Monta as respostas temporais SIMULADAS

%Folhas
FOLHAS=cell(linhas+1,4);
FOLHAS(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
FOLHAS(2:end,:)=num2cell(mV);

%Botoes
BOTOES=cell(linhas+1,4);
BOTOES(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
BOTOES(2:end,:)=num2cell(mB);

%Flores
FLORES=cell(linhas+1,4);
FLORES(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
FLORES(2:end,:)=num2cell(mF);

%Frutos
FRUTOS=cell(linhas+1,4);
FRUTOS(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
FRUTOS(2:end,:)=num2cell(mS);


%% Monta as respostas temporais DO CAMPO

%Folhas
RFOLHAS=cell(linhas+1,4);
RFOLHAS(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
RFOLHAS(2:end,:)=num2cell(cV);

%Botoes
RBOTOES=cell(linhas+1,4);
RBOTOES(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
RBOTOES(2:end,:)=num2cell(cB);

%Flores
RFLORES=cell(linhas+1,4);
RFLORES(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
RFLORES(2:end,:)=num2cell(cF);

%Frutos
RFRUTOS=cell(linhas+1,4);
RFRUTOS(1,:)={'Malifolia','Peixotoa','Laevifolia','Campestris'};
RFRUTOS(2:end,:)=num2cell(cS);


%% Monta os parâmetros da simulação

PARAMETROS=cell(5,8);
PARAMETROS(1,:)={'Nº_E_X','Nº_E_Y','Total Time','Nº Delta Time',...
    'Size_X','Size_Y','Dens','Nº'};
PARAMETROS(2,1)=num2cell(nex);
PARAMETROS(2,2)=num2cell(ney);
PARAMETROS(2,3)=num2cell(T);
PARAMETROS(2,4)=num2cell(dT);
PARAMETROS(2:5,5:8)=num2cell(plantas);


%% Exporta para arquivo "MICROSOFT EXCEL (Registered)" (.xls)

xlswrite('CSV_Method_Data.xls',PARAMETROS,'Sym_Parameters')

xlswrite('CSV_Method_Data.xls',INT,'Int')
xlswrite('CSV_Method_Data.xls',INT_EQ,'E.Int')
xlswrite('CSV_Method_Data.xls',Eperc,'E.%')

xlswrite('CSV_Method_Data.xls',Rms,'Rms')
xlswrite('CSV_Method_Data.xls',Rsk,'Rsk')
xlswrite('CSV_Method_Data.xls',Rku,'Rku')

xlswrite('CSV_Method_Data.xls',FOLHAS,'Sim.Leafs')
xlswrite('CSV_Method_Data.xls',BOTOES,'Sim.Buttons')
xlswrite('CSV_Method_Data.xls',FLORES,'Sim.Flowers')
xlswrite('CSV_Method_Data.xls',FRUTOS,'Sim.Fruits')

xlswrite('CSV_Method_Data.xls',RFOLHAS,'Real.Leafs')
xlswrite('CSV_Method_Data.xls',RBOTOES,'Real.Buttons')
xlswrite('CSV_Method_Data.xls',RFLORES,'Real.Flowers')
xlswrite('CSV_Method_Data.xls',RFRUTOS,'Real.Fruits')

xlswrite('CSV_Method_Data.xls',EFOLHAS,'Error.Leafs')
xlswrite('CSV_Method_Data.xls',EBOTOES,'Error.Buttons')
xlswrite('CSV_Method_Data.xls',EFLORES,'Error.Flowers')
xlswrite('CSV_Method_Data.xls',EFRUTOS,'Error.Fruits')

xlswrite('CSV_Method_Data.xls',QFOLHAS,'QuadE.Leafs')
xlswrite('CSV_Method_Data.xls',QBOTOES,'QuadE.Buttons')
xlswrite('CSV_Method_Data.xls',QFLORES,'QuadE.Flowers')
xlswrite('CSV_Method_Data.xls',QFRUTOS,'QuadE.Fruits')











