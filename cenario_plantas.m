function [MV]=cenario_plantas(MV,plantas,nex,ney)
% Sub-rotina do programa de evolução temporal do cerrado para gerar a
% região de maneira confiável. Todos os dados são entrados pelo programa
% principal e retirados de medidas experimentais e dados históricos.
% A distribuição adotada para os indivíduos é aleatória, e o fundo é
% considerado como 'cerrado típico', ou seja, repleto de vegetação. É
% permitida a sobreposição de uma planta sobre outra, visto que no campo é
% comum que se encontrem entrelaçadas ou muito próximas.
%
% Vale notar que a distribuição é aleatória, usando um algoritmo que
% favorece a formação de 'clusters' ou aglomerados interligados, devido à
% formulação matemática usada pelo método. É ressaltado também que a altura
% das plantas não é considerada, e que há na prática uma grande diferença
% entre a altura média das espécies em questão.

%% GERAÇÃO DAS POSIÇÕES ALEATÓRIAS PARA AS ESPÉCIES

%malifolia
chute_mali=[rand(1,plantas(1,4));rand(1,plantas(1,4))]';
chute_mali(:,1)=chute_mali(:,1)*(nex-4);
chute_mali(:,2)=chute_mali(:,2)*(ney-4);
chute_mali=round(chute_mali)+2;

%peixotoa
chute_peix=[rand(1,plantas(2,4));rand(1,plantas(2,4))]';
chute_peix(:,1)=chute_peix(:,1)*(nex-4);
chute_peix(:,2)=chute_peix(:,2)*(ney-4);
chute_peix=round(chute_peix)+2;

%laevifolia
chute_levi=[rand(1,plantas(3,4));rand(1,plantas(3,4))]';
chute_levi(:,1)=chute_levi(:,1)*(nex-4);
chute_levi(:,2)=chute_levi(:,2)*(ney-4);
chute_levi=round(chute_levi)+2;

%campestris
chute_camp=[rand(1,plantas(4,4));rand(1,plantas(4,4))]';
chute_camp(:,1)=chute_camp(:,1)*(nex-4);
chute_camp(:,2)=chute_camp(:,2)*(ney-4);
chute_camp=round(chute_camp)+2;


%% PREENCHIMENTO ALEATÓRIO DA MATRIZ DE VEGETAÇÃO COM AS 4 ESPÉCIES

%malifolia (3 x 3 elementos, ou 1.5 x 1.5 metros)
for i=1:plantas(1,4)
    MV(chute_mali(i,1)   ,chute_mali(i,2)   ,1)=1;
    MV(chute_mali(i,1)+1 ,chute_mali(i,2)+1 ,1)=1;
    MV(chute_mali(i,1)+1 ,chute_mali(i,2)   ,1)=1;
    MV(chute_mali(i,1)+1 ,chute_mali(i,2)-1 ,1)=1;
    MV(chute_mali(i,1)-1 ,chute_mali(i,2)+1 ,1)=1;
    MV(chute_mali(i,1)-1 ,chute_mali(i,2)   ,1)=1;
    MV(chute_mali(i,1)-1 ,chute_mali(i,2)-1 ,1)=1;
    MV(chute_mali(i,1)   ,chute_mali(i,2)+1 ,1)=1;
    MV(chute_mali(i,1)   ,chute_mali(i,2)-1 ,1)=1;
end

%peixotoa (2 x 1 elementos, ou 1 x 0.5 metros)
for i=1:plantas(2,4)
    MV(chute_peix(i,1)   ,chute_peix(i,2)   ,2)=1;
%     MV(chute_peix(i,1)+1 ,chute_peix(i,2)+1 ,2)=1;
    MV(chute_peix(i,1)   ,chute_peix(i,2)+1 ,2)=1;
%     MV(chute_peix(i,1)+1 ,chute_peix(i,2)   ,2)=1;
end
    
%laevifolia (2 x 2 elementos, ou 1 x 1 metros)
for i=1:plantas(3,4)
    MV(chute_levi(i,1)   ,chute_levi(i,2)   ,3)=1;
    MV(chute_levi(i,1)+1 ,chute_levi(i,2)+1 ,3)=1;
    MV(chute_levi(i,1)   ,chute_levi(i,2)+1 ,3)=1;
    MV(chute_levi(i,1)+1 ,chute_levi(i,2)   ,3)=1;
end
    
%campestris (1 x 1 elementos, ou 0.5 x 0.5 metros)
for i=1:plantas(4,4)
    MV(chute_camp(i,1)   ,chute_camp(i,2)   ,4)=1;
end


