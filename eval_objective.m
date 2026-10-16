function result = eval_objective(x,~)




% F_OT = 12.4143; quadratic error integral somatory for B. F. and S.
X1=[0.0511;0.0383;0.0801;0.0712;0.7523;0.8045;
    0.8062;0.5205;0.4718;0.0700;0.1130];

% % F_OT = 31.3994; quadratic error integral somatory for B. F. and S.
% X2=[0.0393;0.0670;0.1938;0.0570;1.1932;1.1825;
%     1.1868;0.9808;0.7472;0.0936;0.1034];
% 
% % F_OT = 33.6590; quadratic error integral somatory for B. F. and S.
% X3=[0.0633;0.0864;0.1783;0.0663;1.0225;0.9873;
%     1.1570;0.9038;0.4837;0.0913;0.0846];
% 
% % F_OT = 44.6734; quadratic error integral somatory for B. F. and S.
% X4=[0.0529;0.0627;0.1485;0.0197;0.8107;0.8016;
%     0.8016;0.6503;0.4875;0.0697;0.1185];



% OB=[0.02    0.09
%     0.03    0.10
%     0.05    0.20
%     0.01    0.10
%     0.75    1.20
%     0.80    1.20
%     0.80    1.20
%     0.50    1.10
%     0.45    0.75
%     0.06    0.10
%     0.055   0.12];

OB(:,1)=X1*0.4; % Valor otimizado - 60%
OB(:,2)=X1*1.6; % Valor otimizado + 60%


for i=1:11
    if x(i)>OB(i,2) || x(i)<OB(i,1)
        result=10e5;
        return
    end
end

[result] = CSV_Method (x)



