% compute the reconstruction error of the dmd model
errorReconstructedWithoutParticlesTemperature = temperatureDataWithoutParticles - temperatureReconstructedWithoutParticles;
errorReconstructedWithParticlesTemperature = temperatureData - temperatureReconstructedWithParticles;
errorReconstructedWithoutParticlesHumidity = humidityDataWithoutParticles - humidityReconstructedWithoutParticles;
errorReconstructedWithParticlesHumidity = humidityData - humidityReconstructedWithParticles;



rmseWithoutParticlesTemperature(idxROM) = sqrt(mean(errorReconstructedWithoutParticlesTemperature.^2, 'all'));
rmseWithParticlesTemperature(idxROM) = sqrt(mean(errorReconstructedWithParticlesTemperature.^2, 'all'));
rmseWithoutParticlesHumidity(idxROM) = sqrt(mean(errorReconstructedWithoutParticlesHumidity.^2, 'all'));
rmseWithParticlesHumidity(idxROM) = sqrt(mean(errorReconstructedWithParticlesHumidity.^2, 'all'));
% compute the reconstruction error of the dmd model with kalman filter
errorReconstructedWithoutParticlesKFTemperature = temperatureDataWithoutParticles - estimatedStatesCase1Temperature ;
errorReconstructedWithParticlesKFTemperature  = temperatureData - estimatedStatesCase2Temperature ;
errorReconstructedWithoutParticlesKFHumidity = humidityDataWithoutParticles - estimatedStatesCase1Humidity;
errorReconstructedWithParticlesKFHumidity = humidityData - estimatedStatesCase2Humidity;

rmseWithoutParticlesKFTemperature(idxROM) = sqrt(mean(errorReconstructedWithoutParticlesKFTemperature.^2, 'all'));
rmseWithParticlesKFTemperature(idxROM) = sqrt(mean(errorReconstructedWithParticlesKFTemperature.^2, 'all'));
rmseWithoutParticlesKFHumidity(idxROM) = sqrt(mean(errorReconstructedWithoutParticlesKFHumidity.^2, 'all'));
rmseWithParticlesKFHumidity(idxROM) = sqrt(mean(errorReconstructedWithParticlesKFHumidity.^2, 'all'));

rmseAllTemperature(idxROM) = sqrt(mean([errorReconstructedWithParticlesTemperature,errorReconstructedWithoutParticlesTemperature].^2, 'all'));
rmseAllKFTemperature(idxROM) = sqrt(mean([errorReconstructedWithParticlesKFTemperature,errorReconstructedWithoutParticlesKFTemperature].^2, 'all'));
rmseAllHumidity(idxROM) = sqrt(mean([errorReconstructedWithParticlesHumidity,errorReconstructedWithoutParticlesHumidity].^2, 'all'));
rmseAllKFHumidity(idxROM) = sqrt(mean([errorReconstructedWithParticlesKFHumidity,errorReconstructedWithoutParticlesKFHumidity].^2, 'all'));

% display the reconstruction error
disp('===========================================');
disp(['ROM: r = ', num2str(reducedOrders(idxROM))]);
% disp(['T - Direct Reconstruction error: ', num2str(directReconstructionErrorTemperature)]);
disp(['T - RMSE without particles: ', num2str(rmseWithoutParticlesTemperature(idxROM))]);
disp(['T - RMSE with particles: ', num2str(rmseWithParticlesTemperature(idxROM))]);
disp(['T - RMSE without particles (KF): ', num2str(rmseWithoutParticlesKFTemperature(idxROM))]);
disp(['T - RMSE with particles (KF): ', num2str(rmseWithParticlesKFTemperature(idxROM))]);
% disp(['H - Direct Reconstruction error: ', num2str(directReconstructionErrorHumidity)]);
disp(['H - RMSE without particles: ', num2str(rmseWithoutParticlesHumidity(idxROM))]);
disp(['H - RMSE with particles: ', num2str(rmseWithParticlesHumidity(idxROM))]);
disp(['H - RMSE without particles (KF): ', num2str(rmseWithoutParticlesKFHumidity(idxROM))]);
disp(['H - RMSE with particles (KF): ', num2str(rmseWithParticlesKFHumidity(idxROM))]);

timeErrorWithoutParticlesTemperature = sqrt(mean((temperatureReconstructedWithoutParticles - temperatureDataWithoutParticles).^2, 1));
timeErrorWithParticlesTemperature = sqrt(mean((temperatureReconstructedWithParticles - temperatureData).^2, 1));
timeErrorWithoutParticlesKFTemperature = sqrt(mean((estimatedStatesCase1Temperature - temperatureDataWithoutParticles).^2, 1));
timeErrorWithParticlesKFTemperature = sqrt(mean((estimatedStatesCase2Temperature - temperatureData).^2, 1));
timeErrorWithoutParticlesHumidity = sqrt(mean((humidityReconstructedWithoutParticles - humidityDataWithoutParticles).^2, 1));
timeErrorWithParticlesHumidity = sqrt(mean((humidityReconstructedWithParticles - humidityData).^2, 1));
timeErrorWithoutParticlesKFHumidity = sqrt(mean((estimatedStatesCase1Humidity - humidityDataWithoutParticles).^2, 1));
timeErrorWithParticlesKFHumidity = sqrt(mean((estimatedStatesCase2Humidity - humidityData).^2, 1));

% compute min and max values of the reconstructed data
minOutletTemperatureReconstructedWithoutParticles = min(measurementsReconstructedWithoutParticlesTemperature(:,1));
maxOutletTemperatureReconstructedWithoutParticles = max(measurementsReconstructedWithoutParticlesTemperature(:,1));
minOutletTemperatureReconstructedWithParticles = min(measurementsReconstructedWithParticlesTemperature(:,1));
maxOutletTemperatureReconstructedWithParticles = max(measurementsReconstructedWithParticlesTemperature(:,1));
minGlassSensor1TemperatureReconstructedWithoutParticles = min(measurementsReconstructedWithoutParticlesTemperature(:,2));
maxGlassSensor1TemperatureReconstructedWithoutParticles = max(measurementsReconstructedWithoutParticlesTemperature(:,2));
minGlassSensor1TemperatureReconstructedWithParticles = min(measurementsReconstructedWithParticlesTemperature(:,2));
maxGlassSensor1TemperatureReconstructedWithParticles = max(measurementsReconstructedWithParticlesTemperature(:,2));
minGlassSensor2TemperatureReconstructedWithoutParticles = min(measurementsReconstructedWithoutParticlesTemperature(:,3));
maxGlassSensor2TemperatureReconstructedWithoutParticles = max(measurementsReconstructedWithoutParticlesTemperature(:,3));
minGlassSensor2TemperatureReconstructedWithParticles = min(measurementsReconstructedWithParticlesTemperature(:,3));
maxGlassSensor2TemperatureReconstructedWithParticles = max(measurementsReconstructedWithParticlesTemperature(:,3));
minOutletHumidityReconstructedWithoutParticles = min(measurementsReconstructedWithoutParticlesHumidity(:,1));
maxOutletHumidityReconstructedWithoutParticles = max(measurementsReconstructedWithoutParticlesHumidity(:,1));
minOutletHumidityReconstructedWithParticles = min(measurementsReconstructedWithParticlesHumidity(:,1));
maxOutletHumidityReconstructedWithParticles = max(measurementsReconstructedWithParticlesHumidity(:,1));

% compute min and max of the kalman filter measurements
minOutletTemperatureKFWithoutParticles = min(estimatedMeasurementsCase1Temperature(:,1));
maxOutletTemperatureKFWithoutParticles = max(estimatedMeasurementsCase1Temperature(:,1));
minGlassSensor1TemperatureKFWithoutParticles = min(estimatedMeasurementsCase1Temperature(:,2));
maxGlassSensor1TemperatureKFWithoutParticles = max(estimatedMeasurementsCase1Temperature(:,2));
minGlassSensor2TemperatureKFWithoutParticles= min(estimatedMeasurementsCase1Temperature(:,3));
maxGlassSensor2TemperatureKFWithoutParticles= max(estimatedMeasurementsCase1Temperature(:,3));
minOutletTemperatureKFWithParticles = min(estimatedMeasurementsCase2Temperature(:,1));
maxOutletTemperatureKFWithParticles = max(estimatedMeasurementsCase2Temperature(:,1));
minGlassSensor1TemperatureKFWithParticles = min(estimatedMeasurementsCase2Temperature(:,2));
maxGlassSensor1TemperatureKFWithParticles = max(estimatedMeasurementsCase2Temperature(:,2));
minGlassSensor2TemperatureKFWithParticles = min(estimatedMeasurementsCase2Temperature(:,3));
maxGlassSensor2TemperatureKFWithParticles = max(estimatedMeasurementsCase2Temperature(:,3));
minOutletHumidityKFWithoutParticles = min(estimatedMeasurementsCase1Humidity(:,1));
maxOutletHumidityKFWithoutParticles = max(estimatedMeasurementsCase1Humidity(:,1));
minOutletHumidityKFWithParticles = min(estimatedMeasurementsCase2Humidity(:,1));
maxOutletHumidityKFWithParticles = max(estimatedMeasurementsCase2Humidity(:,1));


% compute measurement error
measurementOutletTemperatureErrorWithoutParticles = estimatedMeasurementsCase1Temperature(:,1) - outletTemperatureDataWithoutParticles(:,2);
measurementOutletTemperatureErrorWithParticles = estimatedMeasurementsCase2Temperature(:,1) - outletTemperatureData(:,2);
measurementGlassSensor1ErrorWithoutParticles = estimatedMeasurementsCase1Temperature(:,2) - glassSensor1TemperatureDataWithoutParticles(:,2);
measurementGlassSensor1ErrorWithParticles = estimatedMeasurementsCase2Temperature(:,2) - glassSensor1TemperatureData(:,2);
measurementGlassSensor2ErrorWithoutParticles = estimatedMeasurementsCase1Temperature(:,3) - glassSensor2TemperatureDataWithoutParticles(:,2);
measurementGlassSensor2ErrorWithParticles = estimatedMeasurementsCase2Temperature(:,3) - glassSensor2TemperatureData(:,2);
measurementOutletHumidityErrorWithoutParticles = estimatedMeasurementsCase1Humidity(:,1) - outletHumidityDataWithoutParticles(:,2);
measurementOutletHumidityErrorWithParticles = estimatedMeasurementsCase2Humidity(:,1) - outletHumidityData(:,2);