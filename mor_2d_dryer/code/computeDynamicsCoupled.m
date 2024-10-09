% compute reduced order dynamics for the system
% specify initial condition
initialConditionWithoutParticles = [temperatureDataWithoutParticles(:,1); humidityDataWithoutParticles(:,1)]; % initial condition without particles
initialConditionWithParticles = [temperatureData(:,1); humidityData(:,1)]; % initial condition with particles
% initialize reduced order dynamics
coupledDynamicsWithoutParticles = zeros(r,size(temperatureDataWithoutParticles,2));
coupledDynamicsWithParticles = zeros(r,size(temperatureData,2));
% reduce order of the initial condition
coupledDynamicsWithoutParticles(:,1) = Ustilde'*initialConditionWithoutParticles;
coupledDynamicsWithParticles(:,1) = Ustilde'*initialConditionWithParticles;
numTimeStepsWithoutParticles = size(temperatureDataWithoutParticles,2);
% iterate over time steps
for i = 1:numTimeStepsWithoutParticles-1
    % compute reduced order dynamics
    coupledDynamicsWithoutParticles(:,i+1) = Atilde*coupledDynamicsWithoutParticles(:,i) + Btilde*UCase1(i,:)';
end
numTimeStepsWithParticles = size(temperatureData,2);
% iterate over time steps
for i = 1:numTimeStepsWithParticles-1
    % compute reduced order dynamics
    coupledDynamicsWithParticles(:,i+1) = Atilde*coupledDynamicsWithParticles(:,i) + Btilde*UCase2(i,:)';
end

% reconstruct full order dynamics
coupledReconstructedWithoutParticles = Ustilde*coupledDynamicsWithoutParticles;
coupledReconstructedWithParticles = Ustilde*coupledDynamicsWithParticles;

% get the temperature data
temperatureReconstructedWithoutParticles = coupledReconstructedWithoutParticles(1:size(temperatureDataWithoutParticles(:,1)),:);
temperatureReconstructedWithParticles = coupledReconstructedWithParticles(1:size(temperatureData(:,1)),:);
humidityReconstructedWithoutParticles = coupledReconstructedWithoutParticles(size(temperatureDataWithoutParticles(:,1))+1:end,:);
humidityReconstructedWithParticles = coupledReconstructedWithParticles(size(temperatureData(:,1))+1:end,:);

% combine both cases
temperatureReconstructed = [temperatureReconstructedWithoutParticles, temperatureReconstructedWithParticles];
humidityReconstructed = [humidityReconstructedWithoutParticles, humidityReconstructedWithParticles];

% reconstruct measurements
measurementsReconstructedWithoutParticles = Ctilde*coupledDynamicsWithoutParticles;
measurementsReconstructedWithoutParticles = measurementsReconstructedWithoutParticles';
measurementsReconstructedWithParticles = Ctilde*coupledDynamicsWithParticles;
measurementsReconstructedWithParticles = measurementsReconstructedWithParticles';
% extract temperature measurements
measurementsReconstructedWithoutParticlesTemperature = measurementsReconstructedWithoutParticles(:,1:3);
measurementsReconstructedWithParticlesTemperature = measurementsReconstructedWithParticles(:,1:3);
% extract humidity measurements
measurementsReconstructedWithoutParticlesHumidity = measurementsReconstructedWithoutParticles(:,4);
measurementsReconstructedWithParticlesHumidity = measurementsReconstructedWithParticles(:,4);
