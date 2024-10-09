figure;
subplot(1,2,1)
plot(timeSteps(1:20:end-1),inletTemperatureDataWithoutParticles(1:20:end-1,2))
yyaxis right
plot(timeSteps(1:20:end-1),inletHumidityDataWithoutParticles(1:20:end-1,2))
subplot(1,2,2)
plot(timeStepsWithParticles,particleHeatData(:,2))
yyaxis right
plot(timeStepsWithParticles,particleMoistureData(:,2))
exportPlots('inputs')