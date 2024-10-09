% compute kalman filter in the dmd space
% initialize kalman filter
numStates = size(Atilde,1);
numMeasurements = size(Ctilde,1);
numInputs = size(Btilde,2);
Q = 2e2*eye(numStates);
R = 1e-2*eye(numMeasurements);
P0 = 1e2*eye(numStates);

% time steps for both cases
numTimeStepsWithoutParticles = size(temperatureDataWithoutParticles,2);
numTimeStepsWithParticles = size(temperatureData,2);

% initialize kalman filter variables
estimatedStatesInDMDSpaceCase1 = zeros(numStates,numTimeStepsWithoutParticles);
kalmanGainsCase1 = zeros(numStates,numMeasurements,numTimeStepsWithoutParticles);
PCase1 = zeros(numStates,numStates,numTimeStepsWithoutParticles);
estimatedStatesInDMDSpaceCase2 = zeros(numStates,numTimeStepsWithParticles);
kalmanGainsCase2 = zeros(numStates,numMeasurements,numTimeStepsWithParticles);
PCase2 = zeros(numStates,numStates,numTimeStepsWithParticles);

estimatedStatesInDMDSpaceCase1(:,1) = Ustilde'*initialConditionWithoutParticles;
estimatedStatesInDMDSpaceCase2(:,1) = Ustilde'*initialConditionWithParticles;


% loop over time instances
for i = 2:numTimeStepsWithoutParticles
    % predict state
    estimatedStatesInDMDSpaceCase1(:,i) = Atilde*estimatedStatesInDMDSpaceCase1(:,i-1) + Btilde*UCase1(i-1,:)';
    PCase1(:,:,i) = Atilde*PCase1(:,:,i-1)*Atilde' + Q;
    % compute kalman gain
    kalmanGainsCase1(:,:,i) = PCase1(:,:,i)*Ctilde'/(Ctilde*PCase1(:,:,i)*Ctilde' + R);
    % correct state
    estimatedStatesInDMDSpaceCase1(:,i) = estimatedStatesInDMDSpaceCase1(:,i) + kalmanGainsCase1(:,:,i)*(YCase1(i,:)' - Ctilde*estimatedStatesInDMDSpaceCase1(:,i));
    % update covariance
    PCase1(:,:,i) = (eye(numStates) - kalmanGainsCase1(:,:,i)*Ctilde)*PCase1(:,:,i);
end

for i = 2:numTimeStepsWithParticles
    % predict state
    estimatedStatesInDMDSpaceCase2(:,i) = Atilde*estimatedStatesInDMDSpaceCase2(:,i-1) + Btilde*UCase2(i-1,:)';
    PCase2(:,:,i) = Atilde*PCase2(:,:,i-1)*Atilde' + Q;
    % compute kalman gain
    kalmanGainsCase2(:,:,i) = PCase2(:,:,i)*Ctilde'/(Ctilde*PCase2(:,:,i)*Ctilde' + R);
    % correct state
    estimatedStatesInDMDSpaceCase2(:,i) = estimatedStatesInDMDSpaceCase2(:,i) + kalmanGainsCase2(:,:,i)*(YCase2(i,:)' - Ctilde*estimatedStatesInDMDSpaceCase2(:,i));
    % update covariance
    PCase2(:,:,i) = (eye(numStates) - kalmanGainsCase2(:,:,i)*Ctilde)*PCase2(:,:,i);
end

% reconstruct full order dynamics
estimatedStatesCase1 = Ustilde*estimatedStatesInDMDSpaceCase1;
estimatedStatesCase2 = Ustilde*estimatedStatesInDMDSpaceCase2;

% get temperature data
estimatedStatesCase1Temperature = estimatedStatesCase1(1:size(temperatureDataWithoutParticles(:,1)),:);
estimatedStatesCase2Temperature = estimatedStatesCase2(1:size(temperatureData(:,1)),:);
estimatedStatesCase1Humidity = estimatedStatesCase1(size(temperatureDataWithoutParticles(:,1))+1:end,:);
estimatedStatesCase2Humidity = estimatedStatesCase2(size(temperatureData(:,1))+1:end,:);


% reconstruct estimated measurements
estimatedMeasurementsCase1 = Ctilde*estimatedStatesInDMDSpaceCase1;
estimatedMeasurementsCase1 = estimatedMeasurementsCase1';
estimatedMeasurementsCase2 = Ctilde*estimatedStatesInDMDSpaceCase2;
estimatedMeasurementsCase2 = estimatedMeasurementsCase2';

% get the temperature data
estimatedMeasurementsCase1Temperature = estimatedMeasurementsCase1(:,1:3);
estimatedMeasurementsCase2Temperature = estimatedMeasurementsCase2(:,1:3);
estimatedMeasurementsCase1Humidity = estimatedMeasurementsCase1(:,4);
estimatedMeasurementsCase2Humidity = estimatedMeasurementsCase2(:,4);
