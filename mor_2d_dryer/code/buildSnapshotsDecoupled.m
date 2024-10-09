% specify inputs
if useLiftedInputs
    % first case: no particles inside the drying chamber
    input1Case1 = inletTemperatureDataWithoutParticles(1:end-1,2); % inlet temperature
    input2Case1 = inletHumidityDataWithoutParticles(1:end-1,2); % inlet humidity
    input3Case1 = liftedParticleHeatCase1(1:end-1,:);
    input4Case1 = liftedParticleMoistureCase1(1:end-1,:);
    % second case: particles inside the drying chamber
    input1Case2 = inletTemperatureData(1:end-1,2); % inlet temperature
    input2Case2 = inletHumidityData(1:end-1,2); % inlet humidity
    input3Case2 = liftedParticleHeatCase2(1:end-1,:); % particle heat
    input4Case2 = liftedParticleMoistureCase2(1:end-1,:); % particle humidity domain 9
    % undelayed inputs
    UCase1Temperature = [input1Case1, input3Case1]; % only use inlet temp + particle heat
    UCase2Temperature = [input1Case2, input3Case2]; % only use inlet temp + particle heat
    UCase1Humidity = [input2Case1, input4Case1]; % only use inlet humidity + particle moisture
    UCase2Humidity = [input2Case2, input4Case2]; % only use inlet humidity + particle moisture
else
    % first case: no particles inside the drying chamber
    input1Case1 = inletTemperatureDataWithoutParticles(1:end-1,2); % inlet temperature
    input2Case1 = inletHumidityDataWithoutParticles(1:end-1,2); % inlet humidity
    input3Case1 = zeros(size(inletHumidityDataWithoutParticles(1:end-1,2))); % particle heat = 0
    input4Case1 = zeros(size(inletHumidityDataWithoutParticles(1:end-1,2))); % particle humidity domain 9 = 0
    input5Case1 = zeros(size(inletHumidityDataWithoutParticles(1:end-1,2))); % particle humidity domain 10 = 0
    % second case: particles inside the drying chamber
    input1Case2 = inletTemperatureData(1:end-1,2); % inlet temperature
    input2Case2 = inletHumidityData(1:end-1,2); % inlet humidity
    input3Case2 = particleHeatData(1:end-1,2); % particle heat
    input4Case2 = particleMoistureData(1:end-1,2); % particle humidity domain 9
    % undelayed inputs
    UCase1Temperature = [input1Case1, input3Case1]; % only use inlet temp + particle heat
    UCase2Temperature = [input1Case2, input3Case2]; % only use inlet temp + particle heat
    UCase1Humidity = [input2Case1, input4Case1]; % only use inlet humidity + particle moisture
    UCase2Humidity = [input2Case2, input4Case2]; % only use inlet humidity + particle moisture
end

% specify outputs
% first case: no particles inside the drying chamber
output1Case1 = outletTemperatureDataWithoutParticles(:,2); % outlet temperature
output2Case1 = glassSensor1TemperatureDataWithoutParticles(:,2); % glass sensor 1 temperature
output3Case1 = glassSensor2TemperatureDataWithoutParticles(:,2); % glass sensor 2 temperature
output4Case1 = outletHumidityDataWithoutParticles(:,2); % outlet humidity
YCase1Temperature = [output1Case1, output2Case1, output3Case1];
YCase1Humidity = [output4Case1];
% second case: particles inside the drying chamber
output1Case2 = outletTemperatureData(:,2); % outlet temperature
output2Case2 = glassSensor1TemperatureData(:,2); % glass sensor 1 temperature
output3Case2 = glassSensor2TemperatureData(:,2); % glass sensor 2 temperature
output4Case2 = outletHumidityData(:,2); % outlet humidity
% YCase2 = [output1Case2];
YCase2Temperature = [output1Case2, output2Case2, output3Case2];
YCase2Humidity = [output4Case2];

% specify states
% first case: no particles inside the drying chamber
states1Case1 = temperatureDataWithoutParticles;
states2Case1 = humidityDataWithoutParticles;
% second case: particles inside the drying chamber
states1Case2 = temperatureData;
states2Case2 = humidityData;

% build snapshots
% undelayed states
X1Case1Temperature = [states1Case1(:,1:end-1)];
X1Case2Temperature = [states1Case2(:,1:end-1)];
X1Case1Humidity = [states2Case1(:,1:end-1)];
X1Case2Humidity = [states2Case2(:,1:end-1)];
% delayed states
X2Case1Temperature = [states1Case1(:,2:end)];
X2Case2Temperature = [states1Case2(:,2:end)];
X2Case1Humidity = [states2Case1(:,2:end)];
X2Case2Humidity = [states2Case2(:,2:end)];

% cut case 2 into only one spraying period, i.e. Np = 12 time instances
% Np = 12;
% X1Case2 = X1Case2(:,1:Np);
% X2Case2 = X2Case2(:,1:Np);
% YCase2 = YCase2(1:Np+1,:);
% UCase2 = UCase2(1:Np,:);   

% put X1 data in one matrix
X1Temperature = [X1Case1Temperature, X1Case2Temperature];
X1Humidity = [X1Case1Humidity, X1Case2Humidity];
% put X2 data in one matrix
X2Temperature = [X2Case1Temperature, X2Case2Temperature];
X2Humidity = [X2Case1Humidity, X2Case2Humidity];
% put U data in one matrix
UTemperature = [UCase1Temperature; UCase2Temperature]';
UHumidity = [UCase1Humidity; UCase2Humidity]';

% build state and input matrix for DMDc
stateInputMatrixTemperature = [X1Temperature; UTemperature];
stateInputMatrixHumidity = [X1Humidity; UHumidity];
% build output matrix for identification of KF
outputMatrixTemperature = [YCase1Temperature(1:end-1,:); YCase2Temperature(1:end-1,:)];
outputMatrixHumidity = [YCase1Humidity(1:end-1,:); YCase2Humidity(1:end-1,:)];

