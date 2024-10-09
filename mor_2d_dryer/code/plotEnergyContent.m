% plot energy content
figure();
subplot(2,1,1)
title('Temperature')
cummulativeSum = cumsum((diag(SxTemperature(1:min(size(SxTemperature)),1:min(size(SxTemperature))))));
energy = cummulativeSum(end);
semilogx(cummulativeSum/energy)
grid on;
xlabel('Number of SVs')
ylabel('Energy (%)')
subplot(2,1,2)
title('Humidity')
cummulativeSum = cumsum((diag(SxHumidity(1:min(size(SxHumidity)),1:min(size(SxHumidity))))));
energy = cummulativeSum(end);
semilogx(cummulativeSum/energy)
grid on;
xlabel('Number of SVs')
ylabel('Energy (%)')
% saveas(gcf, 'energyContent.png')
exportPlots('energyContent')