function [MV,MB,MF,MS]=cenario_global(MV,MB,MF,MS,C,V,E,F)
% Função para populacionar as outras variáveis dependentes das folhas e
% posição de cada planta no cenário. É somente um 'startup' da simulação.

% Ordem adotada: 'Malifolia','Peixotoa','Levifolia','Campestris'

%% Matrizes de botões
MB(:,:,1)=MV(:,:,1)*F(1,1);
MB(:,:,2)=MV(:,:,2)*F(1,2);
MB(:,:,3)=MV(:,:,3)*F(1,3);
MB(:,:,4)=MV(:,:,4)*F(1,4);
% MB(:,:,1)=MV(:,:,1)*0.1;
% MB(:,:,2)=MV(:,:,2)*0.1;
% MB(:,:,3)=MV(:,:,3)*0.1;
% MB(:,:,4)=MV(:,:,4)*0.1;

%% Matrizes de flores
MF(:,:,1)=MB(:,:,1)*E(1,1)*C(1)*V(1)/100;
MF(:,:,2)=MB(:,:,2)*E(1,2)*C(1)*V(2)/100;
MF(:,:,3)=MB(:,:,3)*E(1,3)*C(1)*V(3)/100;
MF(:,:,4)=MB(:,:,4)*E(1,4)*C(1)*V(4)/100;
% MF(:,:,1)=MB(:,:,1);
% MF(:,:,2)=MB(:,:,2);
% MF(:,:,3)=MB(:,:,3);
% MF(:,:,4)=MB(:,:,4);

%% Matrizes de frutos
MS(:,:,1)=MF(:,:,1);
MS(:,:,2)=MF(:,:,2);
MS(:,:,3)=MF(:,:,3);
MS(:,:,4)=MF(:,:,4);




