% function program_tester
% Função para dar diversas entradas ao programa principal e testá-las
% comparativamente, avaliando a robustez de cada grupo de parâmetros.
% Este código é o "MAIN", que irá rodar por fora do CSV_Method.
% 
% 'B. malifolia'.'P. tomentosa'.'B. laevifolia'.'B. campestris'

%% INICIALIZAÇÃO ==========================================================
clear all; close all; clc;   % inicializa o programa
n_tryouts=25;
cycles=30;

%% CHAMADA DA FUNÇÃO PRINCIPAL ============================================

F1=zeros(n_tryouts,1);F2=F1;F3=F1;F4=F1;
AB1=zeros(cycles,1);AB2=AB1;AB3=AB1;AB4=AB1;
for counter=1:cycles
    for step=1:n_tryouts
        
        % Chama a função principal
        [sim_ans1,sim_ans2,sim_ans3,sim_ans4] = CSV_Method (step);
        
        counter*step
        
        % Salva as respostas
        F1(step)=sim_ans1;
        F2(step)=sim_ans2;
        F3(step)=sim_ans3;
        F4(step)=sim_ans4;
    end
    
    AB1(counter)=find(F1==min(F1));
    AB2(counter)=find(F2==min(F2));
    AB3(counter)=find(F3==min(F3));
    AB4(counter)=find(F4==min(F4));
    
end

sort(AB1)
sort(AB2)
sort(AB3)
sort(AB4)




