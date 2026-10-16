function plot_cerrado(MV,MB,MF,MS,C,nex,ney,T,dT,i,contador_anual)
% Função destinada a representar as diferentes matrizes durante as
% iterações no tempo, usando gráficos tipo "stem3".

%% Startup do vídeo

global aviobj

if i==1
    fig=figure;
    
    fprintf('Please resize figure to proper size, thjen click on it.')
    waitforbuttonpress
    
    % abre vídeo
    aviobj=avifile('CSVM.avi','compression','Cinepak');
    aviobj.quality = 100;
    aviobj.fps = 6;

end

%% Monta as matrizes de X e Y para o surf
tempo=1:T*dT;fundo=zeros(size(MV(:,:,1)));

%% FOLHAS
subplot(2,3,1);stem3(MV(:,:,1),'fill','color',[50,50,235]/255);hold on;
subplot(2,3,1);stem3(MV(:,:,2),'fill','color',[50,235,50]/255);
subplot(2,3,1);stem3(MV(:,:,3),'fill','color',[235,50,50]/255);
subplot(2,3,1);stem3(MV(:,:,4),'fill','color',[255,240,10]/255);
subplot(2,3,1);stem3(fundo,'fill','color',[100,62,38]/255);hold off;
title('Vegetation','fontweight','bold','color',[.8 .8 .8],...
    'fontname','Calibri','fontangle','italic','fontsize',18)
axis([0,nex,0,ney,0,2]);box off;axis off;

%% BOTÕES
subplot(2,3,4);stem3(MB(:,:,1),'fill','color',[50,50,235]/255);hold on;
subplot(2,3,4);stem3(MB(:,:,2),'fill','color',[50,235,50]/255);
subplot(2,3,4);stem3(MB(:,:,3),'fill','color',[235,50,50]/255);
subplot(2,3,4);stem3(MB(:,:,4),'fill','color',[255,240,10]/255);
subplot(2,3,4);stem3(fundo,'fill','color',[100,62,38]/255);hold off;
title('Floral buds','fontweight','bold','color',[.8 .8 .8],...
    'fontname','Calibri','fontangle','italic','fontsize',18)
axis([0,nex,0,ney,0,2]);box off;axis off

%% FLORES
subplot(2,3,5);stem3(MF(:,:,1),'fill','color',[50,50,235]/255);hold on;
subplot(2,3,5);stem3(MF(:,:,2),'fill','color',[50,235,50]/255);
subplot(2,3,5);stem3(MF(:,:,3),'fill','color',[235,50,50]/255);
subplot(2,3,5);stem3(MF(:,:,4),'fill','color',[255,240,10]/255);
subplot(2,3,5);stem3(fundo,'fill','color',[100,62,38]/255);hold off;
title('Flowers','fontweight','bold','color',[.8 .8 .8],...
    'fontname','Calibri','fontangle','italic','fontsize',18)
axis([0,nex,0,ney,0,2]);box off;axis off

%% SEMENTES
subplot(2,3,6);stem3(MS(:,:,1),'fill','color',[50,50,235]/255);hold on;
subplot(2,3,6);stem3(MS(:,:,2),'fill','color',[50,235,50]/255);
subplot(2,3,6);stem3(MS(:,:,3),'fill','color',[235,50,50]/255);
subplot(2,3,6);stem3(MS(:,:,4),'fill','color',[255,240,10]/255);
subplot(2,3,6);stem3(fundo,'fill','color',[100,62,38]/255);hold off;
title('Fruits','fontweight','bold','color',[.8 .8 .8],...
    'fontname','Calibri','fontangle','italic','fontsize',18)
axis([0,nex,0,ney,0,2]);box off;axis off

%% PLUVIOSIDADE
subplot(2,3,2);plot(tempo,C*(T*dT/3),'y','linewidth',2);hold on
subplot(2,3,2);plot(tempo(i),C(i)*(T*dT/3),'o','linewidth',4,...
    'markersize',8,'color','r');hold off;axis equal off;box off;
set(gca,'XTick',0:48:T*dT,'color',[.25 .25 .25])
title('Rainfall','fontweight','bold','color',[.8 .8 .8],...
    'fontname','Calibri','fontangle','italic','fontsize',18)

%% TABELA DA DATA E LEGENDA
        
%cria marcadores falsos para a legenda
subplot(2,3,3);plot(0,0,'s','markerfacecolor',[.15 .15 .15],...
    'markeredgecolor',[.15 .15 .15]);hold on
subplot(2,3,3);plot(0,0,'s','markerfacecolor',[50,50,235]/255,...
    'markeredgecolor',[.15 .15 .15])
subplot(2,3,3);plot(0,0,'s','markerfacecolor',[50,235,50]/255,...
    'markeredgecolor',[.15 .15 .15])
subplot(2,3,3);plot(0,0,'s','markerfacecolor',[235,50,50]/255,...
    'markeredgecolor',[.15 .15 .15])
subplot(2,3,3);plot(0,0,'s','markerfacecolor',[255,240,10]/255,...
    'markeredgecolor',[.15 .15 .15]);
subplot(2,3,3);plot(0,0,'s','markerfacecolor',[.15 .15 .15],...
    'markeredgecolor',[.15 .15 .15]);

%monta a barra de progresso anual
calendario='Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec';
subplot(2,3,3);text(dT/2,-2,calendario,...
    'fontweight','bold','color',[.8 .8 .8],...
    'fontname','Calibri','fontangle','italic','fontsize',10,...
    'horizontalalignment','center')

posicao=i-((contador_anual-1)*dT);
subplot(2,3,3);plot([posicao,posicao],[0,-4],'-r','linewidth',4);

subplot(2,3,3);plot(1:dT,zeros(dT,1),'.-y','linewidth',2);
subplot(2,3,3);plot(1:dT,zeros(dT,1)-dT/12,'.-y','linewidth',2);
axis equal off;box off;
set(gca,'XTick',0:48:T*dT,'color',[.25 .25 .25]);hold off

%monta o texto da legenda

week=posicao;
if week>=1 && week<=4
    month='Jan';
elseif week>=5 && week<=8
    month='Fev';
elseif week>=9 && week<=12
    month='Mar';
elseif week>=13 && week<=16
    month='Apr';
elseif week>=17 && week<=20
    month='May';
elseif week>=21 && week<=24
    month='Jun';
elseif week>=25 && week<=28
    month='Jul';
elseif week>=29 && week<=32
    month='Aug';
elseif week>=33 && week<=36
    month='Sep';
elseif week>=37 && week<=40
    month='Oct';
elseif week>=41 && week<=44
    month='Nov';
elseif week>=45 && week<=48
    month='Dec';
end
year=contador_anual;
data=strcat('Week:',num2str(week),' Month:',month,' Year:',num2str(year));
legend(data,...
    'Banisteriopsis malifolia','Peixotoa tomentosa',...
    'Banisteriopsis laevifolia','Banisteriopsis campestris',...
    'location','north');

hold off;axis equal off;box off;
title('Legend & Date','fontweight','bold','color',[.8 .8 .8],...
    'fontname','Calibri','fontangle','italic','fontsize',18)


%% PROPRIEDADES
 set(gcf,'color',[.15 .15 .15],'InvertHardCopy','off');drawnow

 
 
 %% Salva frame no vídeo
 drawnow expose
 set(gcf,'PaperPositionMode','auto')
 print(gcf,'image','-dbmp','-painters','-r150');
 aviobj = addframe(aviobj,im2frame(imread('image.bmp')));
 pause(0.01)
 
 if i==dT*T
     %% fecha video
     aviobj = close(aviobj);
 end
 
 
 
 
 
