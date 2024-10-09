% compute measurement matrix via pseudo inverse
Y = outputMatrix';
temperatureDataInDMDSpace = Ustilde'*X1;
pseudoInverseTemperatureInDMDSpace = pinv(temperatureDataInDMDSpace);
Ctilde = Y*pseudoInverseTemperatureInDMDSpace;
Chat = Ctilde*Ustilde';