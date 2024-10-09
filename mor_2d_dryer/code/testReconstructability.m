% compute the reconstruction of the ROM without dynamics
temperatureReconstructed = UstildeTemperature*UstildeTemperature'*X1Temperature;
directReconstructionErrorTemperature = rmse(temperatureReconstructed,X1Temperature,'all');
humidityReconstructed = UstildeHumidity*UstildeHumidity'*X1Humidity;
directReconstructionErrorHumidity = rmse(humidityReconstructed,X1Humidity,'all');