% compute kalman filter in the dmd space

% temperature
% initialize kalman filter
numStatesTemperature = size(AtildeTemperature,1);
numMeasurementsTemperature = size(CtildeTemperature,1);
numInputsTemperature = size(BtildeTemperature,2);
QTemperature = 2e2*eye(numStatesTemperature);
RTemperature = 1e-2*eye(numMeasurementsTemperature);
P0Temperature = 1e2*eye(numStatesTemperature);

% time steps for both cases
numTimeStepsWithoutParticlesTemperature = size(temperatureDataWithoutParticles,2);
numTimeStepsWithParticlesTemperature = size(temperatureData,2);

% initialize kalman filter variables
estimatedStatesInDMDSpaceCase1Temperature = zeros(numStatesTemperature,numTimeStepsWithoutParticles);
kalmanGainsCase1Temperature = zeros(numStatesTemperature,numMeasurementsTemperature,numTimeStepsWithoutParticles);
PCase1Temperature = zeros(numStatesTemperature,numStatesTemperature,numTimeStepsWithoutParticles);
estimatedStatesInDMDSpaceCase2Temperature = zeros(numStatesTemperature,numTimeStepsWithParticles);
kalmanGainsCase2Temperature = zeros(numStatesTemperature,numMeasurementsTemperature,numTimeStepsWithParticles);
PCase2Temperature = zeros(numStatesTemperature,numStatesTemperature,numTimeStepsWithParticles);

estimatedStatesInDMDSpaceCase1Temperature(:,1) = UstildeTemperature'*initialConditionWithoutParticles;
estimatedStatesInDMDSpaceCase2Temperature(:,1) = UstildeTemperature'*initialConditionWithParticles;
% humidity
% initialize kalman filter
numStatesHumidity = size(AtildeHumidity,1);
numMeasurementsHumidity = size(CtildeHumidity,1);
numInputsHumidity = size(BtildeHumidity,2);
QHumidity = 2e2*eye(numStatesHumidity);
RHumidity = 1e-2*eye(numMeasurementsHumidity);
P0Humidity = 1e2*eye(numStatesHumidity);

% time steps for both cases
numTimeStepsWithoutParticlesHumidity = size(humidityDataWithoutParticles,2);
numTimeStepsWithParticlesHumidity = size(humidityData,2);

% initialize kalman filter variables
estimatedStatesInDMDSpaceCase1Humidity = zeros(numStatesHumidity,numTimeStepsWithoutParticles);
kalmanGainsCase1Humidity = zeros(numStatesHumidity,numMeasurementsHumidity,numTimeStepsWithoutParticles);
PCase1Humidity = zeros(numStatesHumidity,numStatesHumidity,numTimeStepsWithoutParticles);
estimatedStatesInDMDSpaceCase2Humidity = zeros(numStatesHumidity,numTimeStepsWithParticles);
kalmanGainsCase2Humidity = zeros(numStatesHumidity,numMeasurementsHumidity,numTimeStepsWithParticles);
PCase2Humidity = zeros(numStatesHumidity,numStatesHumidity,numTimeStepsWithParticles);

estimatedStatesInDMDSpaceCase1Humidity(:,1) = UstildeHumidity'*initialConditionWithoutParticlesHumidity;
estimatedStatesInDMDSpaceCase2Humidity(:,1) = UstildeHumidity'*initialConditionWithParticlesHumidity;


% loop over time instances without particles
for i = 2:numTimeStepsWithoutParticles
    % predict temperature state
    estimatedStatesInDMDSpaceCase1Temperature(:,i) = AtildeTemperature*estimatedStatesInDMDSpaceCase1Temperature(:,i-1) + BtildeTemperature*[UCase1Temperature(i-1,:)';estimatedStatesInDMDSpaceCase1Humidity(:,i-1)];
    PCase1Temperature(:,:,i) = AtildeTemperature*PCase1Temperature(:,:,i-1)*AtildeTemperature' + QTemperature;
    % compute kalman gain
    kalmanGainsCase1Temperature(:,:,i) = PCase1Temperature(:,:,i)*CtildeTemperature'/(CtildeTemperature*PCase1Temperature(:,:,i)*CtildeTemperature' + RTemperature);
    % correct state
    estimatedStatesInDMDSpaceCase1Temperature(:,i) = estimatedStatesInDMDSpaceCase1Temperature(:,i) + kalmanGainsCase1Temperature(:,:,i)*(YCase1Temperature(i,:)' - CtildeTemperature*estimatedStatesInDMDSpaceCase1Temperature(:,i));
    % update covariance
    PCase1Temperature(:,:,i) = (eye(numStatesTemperature) - kalmanGainsCase1Temperature(:,:,i)*CtildeTemperature)*PCase1Temperature(:,:,i);
    
    % predict humidity state
    estimatedStatesInDMDSpaceCase1Humidity(:,i) = AtildeHumidity*estimatedStatesInDMDSpaceCase1Humidity(:,i-1) + BtildeHumidity*[UCase1Humidity(i-1,:)';estimatedStatesInDMDSpaceCase1Temperature(:,i-1)];
    PCase1Humidity(:,:,i) = AtildeHumidity*PCase1Humidity(:,:,i-1)*AtildeHumidity' + QHumidity;
    % compute kalman gain
    kalmanGainsCase1Humidity(:,:,i) = PCase1Humidity(:,:,i)*CtildeHumidity'/(CtildeHumidity*PCase1Humidity(:,:,i)*CtildeHumidity' + RHumidity);
    % correct state
    estimatedStatesInDMDSpaceCase1Humidity(:,i) = estimatedStatesInDMDSpaceCase1Humidity(:,i) + kalmanGainsCase1Humidity(:,:,i)*(YCase1Humidity(i,:)' - CtildeHumidity*estimatedStatesInDMDSpaceCase1Humidity(:,i));
    % update covariance
    PCase1Humidity(:,:,i) = (eye(numStatesHumidity) - kalmanGainsCase1Humidity(:,:,i)*CtildeHumidity)*PCase1Humidity(:,:,i);
end

% loop over time instances with particles
for i = 2:numTimeStepsWithParticles
    % predict temperature state
    estimatedStatesInDMDSpaceCase2Temperature(:,i) = AtildeTemperature*estimatedStatesInDMDSpaceCase2Temperature(:,i-1) + BtildeTemperature*[UCase2Temperature(i-1,:)';estimatedStatesInDMDSpaceCase2Humidity(:,i-1)];
    PCase2Temperature(:,:,i) = AtildeTemperature*PCase2Temperature(:,:,i-1)*AtildeTemperature' + QTemperature;
    % compute kalman gain
    kalmanGainsCase2Temperature(:,:,i) = PCase2Temperature(:,:,i)*CtildeTemperature'/(CtildeTemperature*PCase2Temperature(:,:,i)*CtildeTemperature' + RTemperature);
    % correct state
    estimatedStatesInDMDSpaceCase2Temperature(:,i) = estimatedStatesInDMDSpaceCase2Temperature(:,i) + kalmanGainsCase2Temperature(:,:,i)*(YCase2Temperature(i,:)' - CtildeTemperature*estimatedStatesInDMDSpaceCase2Temperature(:,i));
    % update covariance
    PCase2Temperature(:,:,i) = (eye(numStatesTemperature) - kalmanGainsCase2Temperature(:,:,i)*CtildeTemperature)*PCase2Temperature(:,:,i);

    % predict humidity state
    estimatedStatesInDMDSpaceCase2Humidity(:,i) = AtildeHumidity*estimatedStatesInDMDSpaceCase2Humidity(:,i-1) + BtildeHumidity*[UCase2Humidity(i-1,:)';estimatedStatesInDMDSpaceCase2Temperature(:,i-1)];
    PCase2Humidity(:,:,i) = AtildeHumidity*PCase2Humidity(:,:,i-1)*AtildeHumidity' + QHumidity;
    % compute kalman gain
    kalmanGainsCase2Humidity(:,:,i) = PCase2Humidity(:,:,i)*CtildeHumidity'/(CtildeHumidity*PCase2Humidity(:,:,i)*CtildeHumidity' + RHumidity);
    % correct state
    estimatedStatesInDMDSpaceCase2Humidity(:,i) = estimatedStatesInDMDSpaceCase2Humidity(:,i) + kalmanGainsCase2Humidity(:,:,i)*(YCase2Humidity(i,:)' - CtildeHumidity*estimatedStatesInDMDSpaceCase2Humidity(:,i));
    % update covariance
    PCase2Humidity(:,:,i) = (eye(numStatesHumidity) - kalmanGainsCase2Humidity(:,:,i)*CtildeHumidity)*PCase2Humidity(:,:,i);

end

% reconstruct full order dynamics
estimatedStatesCase1Temperature = UstildeTemperature*estimatedStatesInDMDSpaceCase1Temperature;
estimatedStatesCase2Temperature = UstildeTemperature*estimatedStatesInDMDSpaceCase2Temperature;
estimatedStatesCase1Humidity = UstildeHumidity*estimatedStatesInDMDSpaceCase1Humidity;
estimatedStatesCase2Humidity = UstildeHumidity*estimatedStatesInDMDSpaceCase2Humidity;

% reconstruct estimated measurements
estimatedMeasurementsCase1Temperature = CtildeTemperature*estimatedStatesInDMDSpaceCase1Temperature;
estimatedMeasurementsCase1Temperature = estimatedMeasurementsCase1Temperature';
estimatedMeasurementsCase2Temperature = CtildeTemperature*estimatedStatesInDMDSpaceCase2Temperature;
estimatedMeasurementsCase2Temperature = estimatedMeasurementsCase2Temperature';
estimatedMeasurementsCase1Humidity = CtildeHumidity*estimatedStatesInDMDSpaceCase1Humidity;
estimatedMeasurementsCase1Humidity = estimatedMeasurementsCase1Humidity';
estimatedMeasurementsCase2Humidity = CtildeHumidity*estimatedStatesInDMDSpaceCase2Humidity;
estimatedMeasurementsCase2Humidity = estimatedMeasurementsCase2Humidity';



