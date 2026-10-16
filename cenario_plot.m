function cenario_plot(MV,MB,MF,MS)
% Plota o cenário inicial, STARTUP

% colors for plot per species
deepBlue = [0, 0, 139] / 255;
darkOran = [230, 159, 0] / 255;
tealGree = [0, 158, 115] / 255;
crimsonR = [213, 94, 0] / 255;
colors = {deepBlue, darkOran, tealGree, crimsonR};

%% PLANTAS / FOLHAS

figure('Units', 'pixels', 'Position', [100, 100, 600, 500]);hold on;
for k = 1:4
    [row, col] = find(MV(:,:,k));
    plot(col, row, 's', ...
        'MarkerSize', 6, ...
        'MarkerFaceColor', colors{k}, ...
        'MarkerEdgeColor', 'none');
end
axis ij;axis equal; % flip the y-axis like in spy()
title('Randomized initial spatial distribution of individuals',...
    'fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Simulated dimension - longitude [m]')
ylabel('Simulated dimension - latitude [m]')
xlim([-10,110]);ylim([-10,110])
set(gca,'XTick',0:10:100,'YTick',0:10:100);
hold off;grid on
print(gcf, 'INITIAL_SCENARIO_1.png', '-dpng', '-r300');


%% BOTÕES

figure('Units', 'pixels', 'Position', [100, 100, 600, 500]);hold on;
for k = 1:4
    [row, col] = find(MB(:,:,k));
    plot(col, row, 's', ...
        'MarkerSize', 6, ...
        'MarkerFaceColor', colors{k}, ...
        'MarkerEdgeColor', 'none');
end
axis ij;axis equal; % flip the y-axis like in spy()
title('Randomized initial spatial distribution of floral buds',...
    'fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Simulated dimension - longitude [m]')
ylabel('Simulated dimension - latitude [m]')
xlim([-10,110]);ylim([-10,110])
set(gca,'XTick',0:10:100,'YTick',0:10:100);
hold off;grid on
print(gcf, 'INITIAL_SCENARIO_2.png', '-dpng', '-r300');


%% FLORES

figure('Units', 'pixels', 'Position', [100, 100, 600, 500]);hold on;
for k = 1:4
    [row, col] = find(MF(:,:,k));
    plot(col, row, 's', ...
        'MarkerSize', 6, ...
        'MarkerFaceColor', colors{k}, ...
        'MarkerEdgeColor', 'none');
end
axis ij;axis equal; % flip the y-axis like in spy()
title('Randomized initial spatial distribution of flowers',...
    'fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Simulated dimension - longitude [m]')
ylabel('Simulated dimension - latitude [m]')
xlim([-10,110]);ylim([-10,110])
set(gca,'XTick',0:10:100,'YTick',0:10:100);
hold off;grid on
print(gcf, 'INITIAL_SCENARIO_3.png', '-dpng', '-r300');


%% SEMENTES

figure('Units', 'pixels', 'Position', [100, 100, 600, 500]);hold on;
for k = 1:4
    [row, col] = find(MS(:,:,k));
    plot(col, row, 's', ...
        'MarkerSize', 6, ...
        'MarkerFaceColor', colors{k}, ...
        'MarkerEdgeColor', 'none');
end
axis ij;axis equal; % flip the y-axis like in spy()
title('Randomized initial spatial distribution of fruits',...
    'fontweight','bold',...
    'fontname','Arial','fontangle','italic','fontsize',12)
legend('\itB. Malifolia\rm','\itP. Tomentosa\rm',...
    '\itB. Laevifolia\rm','\itB. Campestris\rm',...
    'location','bestoutside')
xlabel('Simulated dimension - longitude [m]')
ylabel('Simulated dimension - latitude [m]')
xlim([-10,110]);ylim([-10,110])
set(gca,'XTick',0:10:100,'YTick',0:10:100);
hold off;grid on
print(gcf, 'INITIAL_SCENARIO_4.png', '-dpng', '-r300');






