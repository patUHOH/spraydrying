subplot(2,2,1)
heatmapir(geometryXData, geometryYData, Bhat(:,2), 0.1, false);
xlim([0,2.2])
title(['\nu_',num2str(1)])
xlabel('x (m)');
ylabel('y (m)');
title('\nu_{1}')
% clim([min((Bhat(:,2))), max((Bhat(:,2)))])

subplot(2,2,2)
heatmapir(geometryXData, geometryYData, Bhat(:,2+idxPlot), 0.1, false);
xlim([0,2.2])
title(['\nu_',num2str(idxPlot+1)])
xlabel('x (m)');
ylabel('y (m)');
% clim([min((Bhat(:,2))), max((Bhat(:,2)))])

subplot(2,2,3)
heatmapir(geometryXData, geometryYData, Bhat(:,2+idxPlot*2), 0.1, false);
xlim([0,2.2])
title(['\nu_',num2str(idxPlot*2+1)])
xlabel('x (m)');
ylabel('y (m)');
% clim([min((Bhat(:,2))), max((Bhat(:,2)))])

subplot(2,2,4)
heatmapir(geometryXData, geometryYData, Bhat(:,2+idxPlot*3), 0.1, false);
xlim([0,2.2])
title(['\nu_{',num2str(idxPlot*3+1),'}'])
xlabel('x (m)');
ylabel('y (m)');
% clim([min((Bhat(:,2))), max((Bhat(:,2)))])

% sgtitle('Input Matrix for DMD')