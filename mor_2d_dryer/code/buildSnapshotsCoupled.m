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
    % UCase1 = [input1Case1, input3Case1]; % only use inlet temp + particle heat
    % UCase2 = [input1Case2, input3Case2]; % only use inlet temp + particle heat
    UCase1 = [input1Case1, input2Case1, input3Case1, input4Case1]; % use all 
    UCase2 = [input1Case2, input2Case2, input3Case2, input4Case2]; % use all

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
    % UCase1 = [input1Case1, input3Case1]; % only use inlet temp + particle heat
    % UCase2 = [input1Case2, input3Case2]; % only use inlet temp + particle heat
    UCase1 = [input1Case1, input2Case1, input3Case1, input4Case1]; % use all 
    UCase2 = [input1Case2, input2Case2, input3Case2, input4Case2]; % use all
end

% specify outputs
% first case: no particles inside the drying chamber
output1Case1 = outletTemperatureDataWithoutParticles(:,2); % outlet temperature
output2Case1 = glassSensor1TemperatureDataWithoutParticles(:,2); % glass sensor 1 temperature
output3Case1 = glassSensor2TemperatureDataWithoutParticles(:,2); % glass sensor 2 temperature
output4Case1 = outletHumidityDataWithoutParticles(:,2); % outlet humidity
% YCase1 = [output1Case1];
% YCase1 = [output1Case1, output2Case1, output3Case1]; % no humidity
YCase1 = [output1Case1, output2Case1, output3Case1, output4Case1]; % use all
% second case: particles inside the drying chamber
output1Case2 = outletTemperatureData(:,2); % outlet temperature
output2Case2 = glassSensor1TemperatureData(:,2); % glass sensor 1 temperature
output3Case2 = glassSensor2TemperatureData(:,2); % glass sensor 2 temperature
output4Case2 = outletHumidityData(:,2); % outlet humidity
% YCase2 = [output1Case2];
% YCase2 = [output1Case2, output2Case2, output3Case2]; % no humidity
YCase2 = [output1Case2, output2Case2, output3Case2, output4Case2]; % use all

% specify states
% first case: no particles inside the drying chamber
states1Case1 = temperatureDataWithoutParticles;
states2Case1 = humidityDataWithoutParticles;
% second case: particles inside the drying chamber
states1Case2 = temperatureData;
states2Case2 = humidityData;

% build snapshots
% undelayed states
% X1Case1 = [states1Case1(:,1:end-1)]; % only temperature
% X1Case2 = [states1Case2(:,1:end-1)]; % only temperature
X1Case1 = [states1Case1(:,1:end-1); states2Case1(:,1:end-1)]; % use all
X1Case2 = [states1Case2(:,1:end-1); states2Case2(:,1:end-1)]; % use all
% delayed states
% X2Case1 = [states1Case1(:,2:end)]; % only temperature
% X2Case2 = [states1Case2(:,2:end)]; % only temperature
X2Case1 = [states1Case1(:,2:end); states2Case1(:,2:end)]; % use all
X2Case2 = [states1Case2(:,2:end); states2Case2(:,2:end)]; % use all

% cut case 2 into only one spraying period, i.e. Np = 12 time instances
% Np = 12;
% X1Case2 = X1Case2(:,1:Np);
% X2Case2 = X2Case2(:,1:Np);
% YCase2 = YCase2(1:Np+1,:);
% UCase2 = UCase2(1:Np,:);   

% put X1 data in one matrix
X1 = [X1Case1, X1Case2];
% put X2 data in one matrix
X2 = [X2Case1, X2Case2];
% put U data in one matrix
U = [UCase1; UCase2]';

% build state and input matrix for DMDc
stateInputMatrix = [X1; U];
% build output matrix for identification of KF
outputMatrix = [YCase1(1:end-1,:); YCase2(1:end-1,:)];

