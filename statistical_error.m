% function statistical_error

%% startup
clear all; close all; clc;   % inicializa o programa
ncalc=200; % número de pontos usados na média


%% estatística nas respostas
point=zeros(3,4,ncalc);
for i=1:ncalc
    point(:,:,i)=CSV_Method;
end



med=sum(point,3)/ncalc
dev=std(point,0,3)



% med =
% 
%     2.8741    4.9417    4.2226    1.9210
%     2.3893    4.0228   11.0042    7.5773
%     3.5200    9.6201    5.4678   12.6137
% 
% 
% dev =
% 
%     0.4661    0.5530    0.4529    0.5412
%     0.2364    0.4263    1.2575    1.0116
%     0.3810    0.6991    0.3311    0.6720
















%% old stuff
% r =[2.9359    	4.8692    	4.1884    	1.8701
%     2.4682    	3.9759   	11.0367    	7.5556
%     3.6341    	9.5074    	5.4008   	12.6459];
% 
% n =[1.3560	4.1019	2.6823	1.1411
%     1.6492	3.6625	12.6163	6.7624
%     3.5309	8.8821	3.9262	12.8551];
% 
% ans=r-n










