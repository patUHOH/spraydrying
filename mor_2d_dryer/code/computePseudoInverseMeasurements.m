% compute measurement matrix via pseudo inverse
% temperature
YTemperature = outputMatrixTemperature';
temperatureDataInDMDSpace = UstildeTemperature'*X1Temperature;
pseudoInverseTemperatureInDMDSpace = pinv(temperatureDataInDMDSpace);
CtildeTemperature = YTemperature*pseudoInverseTemperatureInDMDSpace;
ChatTemperature = CtildeTemperature*UstildeTemperature';
% humidity
YHumidity = outputMatrixHumidity';
humidityDataInDMDSpace = UstildeHumidity'*X1Humidity;
pseudoInverseHumidityInDMDSpace = pinv(humidityDataInDMDSpace);
CtildeHumidity = YHumidity*pseudoInverseHumidityInDMDSpace;
ChatHumidity = CtildeHumidity*UstildeHumidity';