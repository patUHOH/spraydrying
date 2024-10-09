% compute reduced order dynamics for the system
% specify initial condition
initialConditionWithoutParticles = temperatureDataWithoutParticles(:,1); % initial condition without particles
initialConditionWithParticles = temperatureData(:,1); % initial condition with particles
initialConditionWithoutParticlesHumidity = humidityDataWithoutParticles(:,1); % initial condition humidity
initialConditionWithParticlesHumidity = humidityData(:,1); % initial condition with particles humidity
% initialize reduced order dynamics
temperatureDynamicsWithoutParticles = zeros(rTemperature,size(temperatureDataWithoutParticles,2));
temperatureDynamicsWithParticles = zeros(rTemperature,size(temperatureData,2));
humidityDynamicsWithoutParticles = zeros(rHumidity,size(humidityDataWithoutParticles,2));
humidityDynamicsWithParticles = zeros(rHumidity,size(humidityData,2));
% reduce order of the initial condition
temperatureDynamicsWithoutParticles(:,1) = UstildeTemperature'*initialConditionWithoutParticles;
temperatureDynamicsWithParticles(:,1) = UstildeTemperature'*initialConditionWithParticles;
humidityDynamicsWithoutParticles(:,1) = UstildeHumidity'*initialConditionWithoutParticlesHumidity;
humidityDynamicsWithParticles(:,1) = UstildeHumidity'*initialConditionWithParticlesHumidity;
numTimeStepsWithoutParticles = size(temperatureDataWithoutParticles,2);
% iterate over time steps
for i = 1:numTimeStepsWithoutParticles-1
    % compute reduced order dynamics
    temperatureDynamicsWithoutParticles(:,i+1) = AtildeTemperature*temperatureDynamicsWithoutParticles(:,i) + BtildeTemperature*UCase1Temperature(i,:)';
    humidityDynamicsWithoutParticles(:,i+1) = AtildeHumidity*humidityDynamicsWithoutParticles(:,i) + BtildeHumidity*UCase1Humidity(i,:)';
end
numTimeStepsWithParticles = size(temperatureData,2);
% iterate over time steps
for i = 1:numTimeStepsWithParticles-1
    % compute reduced order dynamics
    temperatureDynamicsWithParticles(:,i+1) = AtildeTemperature*temperatureDynamicsWithParticles(:,i) + BtildeTemperature*UCase2Temperature(i,:)';
    humidityDynamicsWithParticles(:,i+1) = AtildeHumidity*humidityDynamicsWithParticles(:,i) + BtildeHumidity*UCase2Humidity(i,:)';
end

% reconstruct full order dynamics
temperatureReconstructedWithoutParticles = UstildeTemperature*temperatureDynamicsWithoutParticles;
temperatureReconstructedWithParticles = UstildeTemperature*temperatureDynamicsWithParticles;
humidityReconstructedWithoutParticles = UstildeHumidity*humidityDynamicsWithoutParticles;
humidityReconstructedWithParticles = UstildeHumidity*humidityDynamicsWithParticles;

% combine both cases
temperatureReconstructed = [temperatureReconstructedWithoutParticles, temperatureReconstructedWithParticles];
humidityReconstructed = [humidityReconstructedWithoutParticles, humidityReconstructedWithParticles];

% reconstruct measurements
% temperature measurements
measurementsReconstructedWithoutParticlesTemperature = CtildeTemperature*temperatureDynamicsWithoutParticles;
measurementsReconstructedWithoutParticlesTemperature = measurementsReconstructedWithoutParticlesTemperature';
measurementsReconstructedWithParticlesTemperature = CtildeTemperature*temperatureDynamicsWithParticles;
measurementsReconstructedWithParticlesTemperature = measurementsReconstructedWithParticlesTemperature';
% humidity measurements
measurementsReconstructedWithoutParticlesHumidity = CtildeHumidity*humidityDynamicsWithoutParticles;
measurementsReconstructedWithoutParticlesHumidity = measurementsReconstructedWithoutParticlesHumidity';
measurementsReconstructedWithParticlesHumidity = CtildeHumidity*humidityDynamicsWithParticles;
measurementsReconstructedWithParticlesHumidity = measurementsReconstructedWithParticlesHumidity';
