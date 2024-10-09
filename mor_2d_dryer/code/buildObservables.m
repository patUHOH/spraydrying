T_ref = 100 + 273.15; % Reference temperature in K
T_infty = temperatureData(:,1); % Inlet temperature
functionHandlesStateMatrix = {@(x) x; @(x) x - T_infty; @(x) x.^4; @(x) 1./x; @(x) 1/T_ref - 1./x; @(x) (1/T_ref - 1./x).^2; @(x) (1/T_ref - 1./x).^3 };
functionHandlesParticleInputMatrix = {@(u) u; @(u) delayInput(u,Np)};
functionHandleTemperatureInputMatrix = {@(u) delayInput(u,Np); @(u) u; @(u) u.^4};


% particle heat
liftedParticleHeatCase1 = functionHandlesParticleInputMatrix{2}(zeros(size(inletHumidityDataWithoutParticles(:,2))));
liftedParticleHeatCase2 = functionHandlesParticleInputMatrix{2}(particleHeatData(:,2));
% particle moisture
liftedParticleMoistureCase1 = functionHandlesParticleInputMatrix{2}(zeros(size(inletHumidityDataWithoutParticles(:,2))));
liftedParticleMoistureCase2 = functionHandlesParticleInputMatrix{2}(particleMoistureData(:,2));

% % temperature states
if useLiftedStates
    liftedTemperatureStatesWithoutParticles = computeObservables(temperatureDataWithoutParticles(:,2:end),functionHandlesStateMatrix);
    liftedTemperatureStatesWithParticles = computeObservables(temperatureData(:,2:end),functionHandlesStateMatrix);
    % humidity states
    liftedHumidityStatesWithoutParticles = computeObservables(humidityDataWithoutParticles(:,2:end),functionHandlesStateMatrix);
    liftedHumidityStatesWithParticles = computeObservables(humidityData(:,2:end),functionHandlesStateMatrix);
end