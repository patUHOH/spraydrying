figure;
heatmapir(geometryXData, geometryYData, BhatTemperature(:,1), 0.1, false);
xlim([0,2.2])
colorbar;
clim([min((BhatTemperature(:,1))), max((BhatTemperature(:,1)))])
title('T_{inlet}')
xlabel('x (m)');
ylabel('y (m)');
hold on;

figure;
idxPlot = 3;
subplot(4,4,[1 5])
heatmapir(geometryXHumidityData, geometryYHumidityData, BhatHumidity(:,2), 0.1, false);
xlim([0,2.2])
title(['\gamma_',num2str(1)])
xlabel('x (m)');
ylabel('y (m)');

subplot(4,4,[2 6])
heatmapir(geometryXHumidityData, geometryYHumidityData, BhatHumidity(:,2+idxPlot), 0.1, false);
xlim([0,2.2])
title(['\gamma_',num2str(idxPlot+1)])
xlabel('x (m)');
ylabel('y (m)');

subplot(4,4,[9 13])
heatmapir(geometryXHumidityData, geometryYHumidityData, BhatHumidity(:,2+2*idxPlot), 0.1, false);
xlim([0,2.2])
title(['\gamma_',num2str(idxPlot*2+1)])
xlabel('x (m)');
ylabel('y (m)');

subplot(4,4,[10 14])
heatmapir(geometryXHumidityData, geometryYHumidityData, BhatHumidity(:,2+3*idxPlot), 0.1, false);
xlim([0,2.2])
title(['\gamma_{',num2str(idxPlot*3+1),'}'])
xlabel('x (m)');
ylabel('y (m)');

subplot(4,4,[3 7])
heatmapir(geometryXData, geometryYData, BhatTemperature(:,2), 0.1, false);
xlim([0,2.2])
title(['\nu_',num2str(1)])
xlabel('x (m)');
ylabel('y (m)');
title('\nu_{1}')
% clim([min((Bhat(:,2))), max((Bhat(:,2)))])

subplot(4,4,[4,8])
heatmapir(geometryXData, geometryYData, BhatTemperature(:,2+idxPlot), 0.1, false);
xlim([0,2.2])
title(['\nu_',num2str(idxPlot+1)])
xlabel('x (m)');
ylabel('y (m)');
% clim([min((Bhat(:,2))), max((Bhat(:,2)))])

subplot(4,4,[11,15])
heatmapir(geometryXData, geometryYData, BhatTemperature(:,2+idxPlot*2), 0.1, false);
xlim([0,2.2])
title(['\nu_',num2str(idxPlot*2+1)])
xlabel('x (m)');
ylabel('y (m)');
% clim([min((Bhat(:,2))), max((Bhat(:,2)))])

subplot(4,4,[12,16])
heatmapir(geometryXData, geometryYData, BhatTemperature(:,2+idxPlot*3), 0.1, false);
xlim([0,2.2])
title(['\nu_{',num2str(idxPlot*3+1),'}'])
xlabel('x (m)');
ylabel('y (m)');
% clim([min((Bhat(:,2))), max((Bhat(:,2)))])

sgtitle('Input Matrix for DMD')