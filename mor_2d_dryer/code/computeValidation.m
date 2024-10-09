dataValidation = readtable([dataPath,'validation\temperatureData_withParticles'],'VariableNamingRule','preserve');
inletDataValidation = readtable([dataPath,'validation\inlet_temperatureData_withParticles'],'VariableNamingRule','preserve');
outletDataValidation = readtable([dataPath,'validation\outlet_temperatureData_withParticles'],'VariableNamingRule','preserve');
glass1DataValidation = readtable([dataPath,'validation\glassSensor1_temperatureData_withParticles'],'VariableNamingRule','preserve');
glass2DataValidation = readtable([dataPath,'validation\glassSensor2_temperatureData_withParticles'],'VariableNamingRule','preserve');
particleHeatDataValidation = readtable([dataPath,'validation\particles_heatData_withParticles'],'VariableNamingRule','preserve');

if useMoistureData
    particleMoistureDomain9DataValidation = readtable([dataPath,'validation\particles_domain9_moistureSourceData_withParticles'],'VariableNamingRule','preserve');
    particleMoistureDomain10DataValidation = readtable([dataPath,'validation\particles_domain10_moistureSourceData_withParticles'],'VariableNamingRule','preserve');
    humidityDataValidation = readtable([dataPath,'validation\humidityData_withParticles'],'VariableNamingRule','preserve');
    inletHumidityDataValidation = readtable([dataPath,'validation\inlet_humidityData_withParticles'],'VariableNamingRule','preserve');
    outletHumidityDataValidation = readtable([dataPath,'validation\outlet_humidityData_withParticles'],'VariableNamingRule','preserve');
end
% extract geometry data
geometryXData = table2array(dataValidation(:,1));
geometryYData = table2array(dataValidation(:,2));

if positionConstraint
    % constraint the geometry and therefore the temperature data field used for dmd
    idx = find(geometryXData >= xMin & geometryXData <= xMax & geometryYData >= yMin & geometryYData <= yMax);
    dataValidation = dataValidation(idx,:);
    geometryXData = table2array(dataValidation(:,1));
    geometryYData = table2array(dataValidation(:,2));
end

temperatureDataValidation = table2array(dataValidation(:,3:end));
inletTemperatureDataValidation = table2array(inletDataValidation(~any(ismissing(inletDataValidation),2),:));
outletTemperatureDataValidation = table2array(outletDataValidation(~any(ismissing(outletDataValidation),2),:));
glassSensor1TemperatureDataValidation = table2array(glass1DataValidation(~any(ismissing(glass1DataValidation),2),:));
glassSensor2TemperatureDataValidation = table2array(glass2DataValidation(~any(ismissing(glass2DataValidation),2),:));

% extract particle heat data
particleHeatDataValidation = table2array(particleHeatDataValidation(~any(ismissing(particleHeatDataValidation),2),:));
% find missing entries, fill with zeros, loop over the entries in inlet temperature data 
% and append zero if time instance is missing in the particle heat data
particleHeatDataVectorValidation = zeros(size(inletTemperatureDataValidation));
idx = 1;
for i = 1:size(inletTemperatureDataValidation,1)
    if ~ismember(inletTemperatureDataValidation(i,1),particleHeatDataValidation(:,1))
        particleHeatDataVectorValidation(i,:) = [inletTemperatureDataValidation(i,1),0];
    else
        particleHeatDataVectorValidation(i,:) = [inletTemperatureDataValidation(i,1),particleHeatDataValidation(idx,2)];
        idx = idx + 1;
    end
end 
particleHeatDataValidation = particleHeatDataVectorValidation;

if useMoistureData
    % extract particle moisture data
    particleMoistureDomain9DataValidation = table2array(particleMoistureDomain9DataValidation(~any(ismissing(particleMoistureDomain9DataValidation),2),:));
    particleMoistureDomain10DataValidation = table2array(particleMoistureDomain10DataValidation(~any(ismissing(particleMoistureDomain10DataValidation),2),:));
    % find missing entries, fill with zeros, loop over the entries in inlet temperature data
    % and append zero if time instance is missing in the particle moisture data
    particleMoistureDomain9DataVectorValidation = zeros(size(inletTemperatureDataValidation));
    particleMoistureDomain10DataVectorValidation = zeros(size(inletTemperatureDataValidation));
    idx9 = 1;
    idx10 = 1;
    for i = 1:size(inletTemperatureDataValidation,1)
        if ~ismember(inletTemperatureDataValidation(i,1),particleMoistureDomain9DataValidation(:,1))
            particleMoistureDomain9DataVectorValidation(i,:) = [inletTemperatureDataValidation(i,1),0];
        else
            particleMoistureDomain9DataVectorValidation(i,:) = [inletTemperatureDataValidation(i,1),particleMoistureDomain9DataValidation(idx9,2)];
            idx9 = idx9 + 1;
        end
        if ~ismember(inletTemperatureDataValidation(i,1),particleMoistureDomain10DataValidation(:,1))
            particleMoistureDomain10DataVectorValidation(i,:) = [inletTemperatureDataValidation(i,1),0];
        else
            particleMoistureDomain10DataVectorValidation(i,:) = [inletTemperatureDataValidation(i,1),particleMoistureDomain10DataValidation(idx10,2)];
            idx10 = idx10 + 1;
        end
    end
    particleMoistureDomain9DataValidation = particleMoistureDomain9DataVector;
    particleMoistureDomain10DataValidation = particleMoistureDomain10DataVector;
    particleMoistureDataValidation = particleMoistureDomain9DataValidation + particleMoistureDomain10DataValidation;
    
    % extract humidity data
    % exclude NaN entries
    humidityDataValidation = humidityDataValidation(~any(ismissing(humidityDataValidation),2),:);
    % build geometry
    geometryXHumidityData = table2array(humidityDataValidation(:,1));
    geometryYHumidityData = table2array(humidityDataValidation(:,2));
    if positionConstraint
        % constraint the geometry and therefore the moisture data field used for dmd
        idx = find(geometryXHumidityData >= xMin & geometryXHumidityData <= xMax & geometryYHumidityData >= yMin & geometryYHumidityData <= yMax);
        humidityDataValidation = humidityDataValidation(idx,:);
        geometryXHumidityData = table2array(humidityDataValidation(:,1));
        geometryYHumidityData = table2array(humidityDataValidation(:,2));
    end
    humidityDataValidation = table2array(humidityDataValidation(:,3:end));

    % extract outlet humidity data
    inletHumidityDataValidation = table2array(inletHumidityDataValidation(~any(ismissing(inletHumidityDataValidation),2),:));


    % extract outlet humidity data
    outletHumidityDataValidation = table2array(outletHumidityDataValidation(~any(ismissing(outletHumidityDataValidation),2),:));
end

% lifting

% particle heat
liftedParticleHeatValidation = functionHandlesParticleInputMatrix{2}(particleHeatDataValidation(:,2));
% particle moisture
liftedParticleMoistureValidation = functionHandlesParticleInputMatrix{2}(particleMoistureDataValidation(:,2));
% states
if useLiftedStates
    liftedTemperatureStatesValidation = computeObservables(temperatureDataValidation(:,2:end),functionHandlesStateMatrix);
    % humidity states
    liftedHumidityStatesWithValidation = computeObservables(humidityDataValidation(:,2:end),functionHandlesStateMatrix);
end

% build input
if useLiftedInputs
    input1Validation = inletTemperatureDataValidation(1:end-1,2); % inlet temperature
    input2Validation = inletHumidityDataValidation(1:end-1,2); % inlet humidity
    input3Validation = liftedParticleHeatValidation(1:end-1,:); % particle heat
    input4Validation = liftedParticleMoistureValidation(1:end-1,:); % particle moisture
else 
    input1Validation = inletTemperatureDataValidation(1:end-1,2); % inlet temperature
    input2Validation = inletHumidityDataValidation(1:end-1,2); % inlet humidity
    input3Validation = particleHeatDataValidation(1:end-1,2); % particle heat
    input4Validation = particleMoistureDataValidation(1:end-1,2); % particle moisture
end

UValidation = [input1Validation,input2Validation,input3Validation,input4Validation];
UValidationTemperature = [input1Validation,input3Validation];
UValidationHumidity = [input2Validation,input4Validation];

% build output
output1Validation = outletTemperatureDataValidation(:,2);
output2Validation = glassSensor1TemperatureDataValidation(:,2);
output3Validation = glassSensor2TemperatureDataValidation(:,2);
output4Validation = outletHumidityDataValidation(:,2);
YValidation = [output1Validation,output2Validation,output3Validation,output4Validation];
YValidationTemperature = [output1Validation,output2Validation,output3Validation];
YValidationHumidity = output4Validation;

outputMatrixValidation = [YValidation(1:end-1,:)];
outputMatrixTemperatureValidation = [YValidationTemperature(1:end-1,:)];
outputMatrixHumidityValidation = [YValidationHumidity(1:end-1,:)];

initialConditionTemperatureValidation = [temperatureDataValidation(:,1)]; % initial condition
initialConditionHumidityValidation = [humidityDataValidation(:,1)]; % initial condition

%% method 1: coupled DMD 
if method == 1
    % compute reduced order dynamics for the system
    % specify initial condition
    initialConditionValidation = [temperatureDataValidation(:,1); humidityDataValidation(:,1)]; % initial condition with particles
    % initialize reduced order dynamics
    coupledDynamicsValidation = zeros(r,size(temperatureData,2));
    % reduce order of the initial condition
    coupledDynamicsValidation(:,1) = Ustilde'*initialConditionValidation;
    numTimeStepsValidation = size(temperatureDataValidation,2);
    % iterate over time steps
    for i = 1:numTimeStepsValidation-1
        % compute reduced order dynamics
        coupledDynamicsValidation(:,i+1) = Atilde*coupledDynamicsValidation(:,i) + Btilde*UValidation(i,:)';
    end

    % reconstruct full order dynamics
    coupledReconstructedValidation = Ustilde*coupledDynamicsValidation;

    % get the temperature data
    temperatureReconstructedValidation = coupledReconstructedValidation(1:size(temperatureDataValidation(:,1)),:);
    humidityReconstructedValidation = coupledReconstructedValidation(size(temperatureDataValidation(:,1))+1:end,:);

    % reconstruct measurements
    measurementsReconstructedValidation = Ctilde*coupledDynamicsValidation;
    measurementsReconstructedValidation = measurementsReconstructedValidation';
    % extract temperature measurements
    measurementsReconstructedValidationTemperature = measurementsReconstructedValidation(:,1:3);
    % extract humidity measurements
    measurementsReconstructedValidationHumidity = measurementsReconstructedValidation(:,4);


    % compute kalman filter in the dmd space
    % initialize kalman filter
    numStates = size(Atilde,1);
    numMeasurements = size(Ctilde,1);
    numInputs = size(Btilde,2);
    Q = 2e2*eye(numStates);
    R = 1e-2*eye(numMeasurements);
    P0 = 1e2*eye(numStates);

    % time steps for both cases
    numTimeStepsValidation = size(temperatureDataValidation,2);

    % initialize kalman filter variables
    estimatedStatesInDMDSpaceValidation = zeros(numStates,numTimeStepsValidation);
    kalmanGainsValidation = zeros(numStates,numMeasurements,numTimeStepsValidation);
    PValidation = zeros(numStates,numStates,numTimeStepsValidation);

    estimatedStatesInDMDSpaceValidation(:,1) = Ustilde'*initialConditionValidation;


    for i = 2:numTimeStepsValidation
        % predict state
        estimatedStatesInDMDSpaceValidation(:,i) = Atilde*estimatedStatesInDMDSpaceValidation(:,i-1) + Btilde*UValidation(i-1,:)';
        PValidation(:,:,i) = Atilde*PValidation(:,:,i-1)*Atilde' + Q;
        % compute kalman gain
        kalmanGainsValidation(:,:,i) = PValidation(:,:,i)*Ctilde'/(Ctilde*PValidation(:,:,i)*Ctilde' + R);
        % correct state
        estimatedStatesInDMDSpaceValidation(:,i) = estimatedStatesInDMDSpaceValidation(:,i) + kalmanGainsValidation(:,:,i)*(YValidation(i,:)' - Ctilde*estimatedStatesInDMDSpaceValidation(:,i));
        % update covariance
        PValidation(:,:,i) = (eye(numStates) - kalmanGainsValidation(:,:,i)*Ctilde)*PValidation(:,:,i);
    end

    % reconstruct full order dynamics
    estimatedStatesValidation = Ustilde*estimatedStatesInDMDSpaceValidation;

    % get temperature data
    estimatedStatesValidationTemperature = estimatedStatesValidation(1:size(temperatureDataValidation(:,1)),:);
    estimatedStatesValidationHumidity = estimatedStatesValidation(size(temperatureDataValidation(:,1))+1:end,:);


    % reconstruct estimated measurements
    estimatedMeasurementsValidation = Ctilde*estimatedStatesInDMDSpaceValidation;
    estimatedMeasurementsValidation = estimatedMeasurementsValidation';

    % get the temperature data
    estimatedMeasurementsValidationTemperature = estimatedMeasurementsValidation(:,1:3);
    estimatedMeasurementsValidationHumidity = estimatedMeasurementsValidation(:,4);
end


%% method 2: decoupled DMD
if method == 2 || method == 3
    % initialize reduced order model
    % compute reduced order dynamics for the system
    % specify initial condition
    initialConditionValidation = temperatureDataValidation(:,1); % initial condition with particles
    initialConditionValidationHumidity = humidityDataValidation(:,1); % initial condition with particles humidity
    % initialize reduced order dynamics
    temperatureDynamicsValidation = zeros(rTemperature,size(temperatureDataValidation,2));
    humidityDynamicsValidation = zeros(rHumidity,size(humidityDataValidation,2));
    % reduce order of the initial condition
    temperatureDynamicsValidation(:,1) = UstildeTemperature'*initialConditionValidation;
    humidityDynamicsValidation(:,1) = UstildeHumidity'*initialConditionValidationHumidity;
    numTimeStepsValidation = size(temperatureDataValidation,2);
    % iterate over time steps
    for i = 1:numTimeStepsValidation-1
        % compute reduced order dynamics
        temperatureDynamicsValidation(:,i+1) = AtildeTemperature*temperatureDynamicsValidation(:,i) + BtildeTemperature*[UValidationTemperature(i,:)';humidityDynamicsValidation(:,i)];
        humidityDynamicsValidation(:,i+1) = AtildeHumidity*humidityDynamicsValidation(:,i) + BtildeHumidity*[UValidationHumidity(i,:)';temperatureDynamicsValidation(:,i)];
    end

    % reconstruct full order dynamics
    temperatureReconstructedValidation = UstildeTemperature*temperatureDynamicsValidation;
    humidityReconstructedValidation = UstildeHumidity*humidityDynamicsValidation;

    % temperature measurements
    measurementsReconstructedValidationTemperature = CtildeTemperature*temperatureDynamicsValidation;
    measurementsReconstructedValidationTemperature = measurementsReconstructedValidationTemperature';
    % humidity measurements
    measurementsReconstructedValidationHumidity = CtildeHumidity*humidityDynamicsValidation;
    measurementsReconstructedValidationHumidity = measurementsReconstructedValidationHumidity';


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
    numTimeStepsValidationTemperature = size(temperatureData,2);

    % initialize kalman filter variables
    estimatedStatesInDMDSpaceValidationTemperature = zeros(numStatesTemperature,numTimeStepsValidation);
    kalmanGainsValidationTemperature = zeros(numStatesTemperature,numMeasurementsTemperature,numTimeStepsValidation);
    PValidationTemperature = zeros(numStatesTemperature,numStatesTemperature,numTimeStepsValidation);

    estimatedStatesInDMDSpaceValidationTemperature(:,1) = UstildeTemperature'*initialConditionValidation;
    % humidity
    % initialize kalman filter
    numStatesHumidity = size(AtildeHumidity,1);
    numMeasurementsHumidity = size(CtildeHumidity,1);
    numInputsHumidity = size(BtildeHumidity,2);
    QHumidity = 2e2*eye(numStatesHumidity);
    RHumidity = 1e-2*eye(numMeasurementsHumidity);
    P0Humidity = 1e2*eye(numStatesHumidity);

    % time steps for both cases
    numTimeStepsValidationHumidity = size(humidityData,2);

    % initialize kalman filter variables
    estimatedStatesInDMDSpaceValidationHumidity = zeros(numStatesHumidity,numTimeStepsValidation);
    kalmanGainsValidationHumidity = zeros(numStatesHumidity,numMeasurementsHumidity,numTimeStepsValidation);
    PValidationHumidity = zeros(numStatesHumidity,numStatesHumidity,numTimeStepsValidation);
    estimatedStatesInDMDSpaceValidationHumidity(:,1) = UstildeHumidity'*initialConditionValidationHumidity;

    % loop over time instances with particles
    for i = 2:numTimeStepsValidation
        % predict temperature state
        estimatedStatesInDMDSpaceValidationTemperature(:,i) = AtildeTemperature*estimatedStatesInDMDSpaceValidationTemperature(:,i-1) + BtildeTemperature*[UValidationTemperature(i-1,:)';estimatedStatesInDMDSpaceValidationHumidity(:,i-1)];
        PValidationTemperature(:,:,i) = AtildeTemperature*PValidationTemperature(:,:,i-1)*AtildeTemperature' + QTemperature;
        % compute kalman gain
        kalmanGainsValidationTemperature(:,:,i) = PValidationTemperature(:,:,i)*CtildeTemperature'/(CtildeTemperature*PValidationTemperature(:,:,i)*CtildeTemperature' + RTemperature);
        % correct state
        estimatedStatesInDMDSpaceValidationTemperature(:,i) = estimatedStatesInDMDSpaceValidationTemperature(:,i) + kalmanGainsValidationTemperature(:,:,i)*(YValidationTemperature(i,:)' - CtildeTemperature*estimatedStatesInDMDSpaceValidationTemperature(:,i));
        % update covariance
        PValidationTemperature(:,:,i) = (eye(numStatesTemperature) - kalmanGainsValidationTemperature(:,:,i)*CtildeTemperature)*PValidationTemperature(:,:,i);

        % predict humidity state
        estimatedStatesInDMDSpaceValidationHumidity(:,i) = AtildeHumidity*estimatedStatesInDMDSpaceValidationHumidity(:,i-1) + BtildeHumidity*[UValidationHumidity(i-1,:)';estimatedStatesInDMDSpaceValidationTemperature(:,i-1)];
        PValidationHumidity(:,:,i) = AtildeHumidity*PValidationHumidity(:,:,i-1)*AtildeHumidity' + QHumidity;
        % compute kalman gain
        kalmanGainsValidationHumidity(:,:,i) = PValidationHumidity(:,:,i)*CtildeHumidity'/(CtildeHumidity*PValidationHumidity(:,:,i)*CtildeHumidity' + RHumidity);
        % correct state
        estimatedStatesInDMDSpaceValidationHumidity(:,i) = estimatedStatesInDMDSpaceValidationHumidity(:,i) + kalmanGainsValidationHumidity(:,:,i)*(YValidationHumidity(i,:)' - CtildeHumidity*estimatedStatesInDMDSpaceValidationHumidity(:,i));
        % update covariance
        PValidationHumidity(:,:,i) = (eye(numStatesHumidity) - kalmanGainsValidationHumidity(:,:,i)*CtildeHumidity)*PValidationHumidity(:,:,i);

    end

    % reconstruct full order dynamics
    estimatedStatesValidationTemperature = UstildeTemperature*estimatedStatesInDMDSpaceValidationTemperature;
    estimatedStatesValidationHumidity = UstildeHumidity*estimatedStatesInDMDSpaceValidationHumidity;

    % reconstruct estimated measurements
    estimatedMeasurementsValidationTemperature = CtildeTemperature*estimatedStatesInDMDSpaceValidationTemperature;
    estimatedMeasurementsValidationTemperature = estimatedMeasurementsValidationTemperature';
    estimatedMeasurementsValidationHumidity = CtildeHumidity*estimatedStatesInDMDSpaceValidationHumidity;
    estimatedMeasurementsValidationHumidity = estimatedMeasurementsValidationHumidity';
end

%% validation error
% compute the reconstruction error of the dmd model
errorReconstructedValidationTemperature = temperatureDataValidation - temperatureReconstructedValidation;
errorReconstructedValidationHumidity = humidityDataValidation - humidityReconstructedValidation;



rmseValidationTemperature(idxROM) = sqrt(mean(errorReconstructedValidationTemperature.^2, 'all'));
rmseValidationHumidity(idxROM) = sqrt(mean(errorReconstructedValidationHumidity.^2, 'all'));
% compute the reconstruction error of the dmd model with kalman filter
errorReconstructedValidationKFTemperature  = temperatureDataValidation - estimatedStatesValidationTemperature ;
errorReconstructedValidationKFHumidity = humidityDataValidation - estimatedStatesValidationHumidity;

rmseValidationKFTemperature(idxROM) = sqrt(mean(errorReconstructedValidationKFTemperature.^2, 'all'));
rmseValidationKFHumidity(idxROM) = sqrt(mean(errorReconstructedValidationKFHumidity.^2, 'all'));


% display the reconstruction error
disp(['T - RMSE validation: ', num2str(rmseValidationTemperature(idxROM))]);
disp(['T - RMSE validation (KF): ', num2str(rmseValidationKFTemperature(idxROM))]);
disp(['H - RMSE validation: ', num2str(rmseValidationHumidity(idxROM))]);
disp(['H - RMSE validation (KF): ', num2str(rmseValidationKFHumidity(idxROM))]);

timeErrorValidationTemperature = sqrt(mean((temperatureReconstructedValidation - temperatureDataValidation).^2, 1));
timeErrorValidationKFTemperature = sqrt(mean((estimatedStatesValidationTemperature - temperatureDataValidation).^2, 1));
timeErrorValidationHumidity = sqrt(mean((humidityReconstructedValidation - humidityDataValidation).^2, 1));
timeErrorValidationKFHumidity = sqrt(mean((estimatedStatesValidationHumidity - humidityDataValidation).^2, 1));

