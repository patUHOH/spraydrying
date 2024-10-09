data = readtable([dataPath,'withParticles\temperatureData_withParticles'],'VariableNamingRule','preserve');
inletData = readtable([dataPath,'withParticles\inlet_temperatureData_withParticles'],'VariableNamingRule','preserve');
outletData = readtable([dataPath,'withParticles\outlet_temperatureData_withParticles'],'VariableNamingRule','preserve');
glass1Data = readtable([dataPath,'withParticles\glassSensor1_temperatureData_withParticles'],'VariableNamingRule','preserve');
glass2Data = readtable([dataPath,'withParticles\glassSensor2_temperatureData_withParticles'],'VariableNamingRule','preserve');
particleHeatData = readtable([dataPath,'withParticles\particles_heatData_withParticles'],'VariableNamingRule','preserve');
if useMoistureData
    particleMoistureDomain9Data = readtable([dataPath,'withParticles\particles_domain9_moistureSourceData_withParticles'],'VariableNamingRule','preserve');
    particleMoistureDomain10Data = readtable([dataPath,'withParticles\particles_domain10_moistureSourceData_withParticles'],'VariableNamingRule','preserve');
    humidityData = readtable([dataPath,'withParticles\humidityData_withParticles'],'VariableNamingRule','preserve');
    inletHumidityData = readtable([dataPath,'withParticles\inlet_humidityData_withParticles'],'VariableNamingRule','preserve');
    outletHumidityData = readtable([dataPath,'withParticles\outlet_humidityData_withParticles'],'VariableNamingRule','preserve');
end

% extract geometry data
geometryXData = table2array(data(:,1));
geometryYData = table2array(data(:,2));

if positionConstraint
    % constraint the geometry and therefore the temperature data field used for dmd
    idx = find(geometryXData >= xMin & geometryXData <= xMax & geometryYData >= yMin & geometryYData <= yMax);
    data = data(idx,:);
    geometryXData = table2array(data(:,1));
    geometryYData = table2array(data(:,2));
end

% extract temperature data
temperatureData = table2array(data(:,3:end));
temperatureDataMin = min(temperatureData,[],'all');
temperatureDataMax = max(temperatureData,[],'all');

% extract inlet temperature data
inletTemperatureData = table2array(inletData(~any(ismissing(inletData),2),:));
minInlet = min(inletTemperatureData(:,2),[],'all');
maxInlet = max(inletTemperatureData(:,2),[],'all');

% extract measurement points
outletTemperatureData = table2array(outletData(~any(ismissing(outletData),2),:));
minOutlet = min(outletTemperatureData(:,2),[],'all');
maxOutlet = max(outletTemperatureData(:,2),[],'all');
glassSensor1TemperatureData = table2array(glass1Data(~any(ismissing(glass1Data),2),:));
minGlass1 = min(glassSensor1TemperatureData(:,2),[],'all');
maxGlass1 = max(glassSensor1TemperatureData(:,2),[],'all');
glassSensor2TemperatureData = table2array(glass2Data(~any(ismissing(glass2Data),2),:));
minGlass2 = min(glassSensor2TemperatureData(:,2),[],'all');
maxGlass2 = max(glassSensor2TemperatureData(:,2),[],'all');

% extract particle heat data
particleHeatData = table2array(particleHeatData(~any(ismissing(particleHeatData),2),:));
% find missing entries, fill with zeros, loop over the entries in inlet temperature data 
% and append zero if time instance is missing in the particle heat data
particleHeatDataVector = zeros(size(inletTemperatureData));
idx = 1;
for i = 1:size(inletTemperatureData,1)
    if ~ismember(inletTemperatureData(i,1),particleHeatData(:,1))
        particleHeatDataVector(i,:) = [inletTemperatureData(i,1),0]; % inletTemperatureDataValidation(i,1) = time instances, 0 = data
    else
        particleHeatDataVector(i,:) = [inletTemperatureData(i,1),particleHeatData(idx,2)]; % inletTemperatureDataValidation(i,1) = time instances, particleHeatData(idx,2) = data
        idx = idx + 1;
    end
end 
particleHeatData = particleHeatDataVector;
minParticleHeat = min(particleHeatData(:,2),[],'all');
maxParticleHeat = max(particleHeatData(:,2),[],'all');

if useMoistureData
    % extract particle moisture data
    particleMoistureDomain9Data = table2array(particleMoistureDomain9Data(~any(ismissing(particleMoistureDomain9Data),2),:));
    particleMoistureDomain10Data = table2array(particleMoistureDomain10Data(~any(ismissing(particleMoistureDomain10Data),2),:));
    % find missing entries, fill with zeros, loop over the entries in inlet temperature data
    % and append zero if time instance is missing in the particle moisture data
    particleMoistureDomain9DataVector = zeros(size(inletTemperatureData));
    particleMoistureDomain10DataVector = zeros(size(inletTemperatureData));
    idx9 = 1;
    idx10 = 1;
    for i = 1:size(inletTemperatureData,1)
        if ~ismember(inletTemperatureData(i,1),particleMoistureDomain9Data(:,1))
            particleMoistureDomain9DataVector(i,:) = [inletTemperatureData(i,1),0];
        else
            particleMoistureDomain9DataVector(i,:) = [inletTemperatureData(i,1),particleMoistureDomain9Data(idx9,2)];
            idx9 = idx9 + 1;
        end
        if ~ismember(inletTemperatureData(i,1),particleMoistureDomain10Data(:,1))
            particleMoistureDomain10DataVector(i,:) = [inletTemperatureData(i,1),0];
        else
            particleMoistureDomain10DataVector(i,:) = [inletTemperatureData(i,1),particleMoistureDomain10Data(idx10,2)];
            idx10 = idx10 + 1;
        end
    end
    particleMoistureDomain9Data = particleMoistureDomain9DataVector;
    particleMoistureDomain10Data = particleMoistureDomain10DataVector;
    minParticleMoistureDomain9 = min(particleMoistureDomain9Data(:,2),[],'all');
    maxParticleMoistureDomain9 = max(particleMoistureDomain9Data(:,2),[],'all');
    minParticleMoistureDomain10 = min(particleMoistureDomain10Data(:,2),[],'all');
    maxParticleMoistureDomain10 = max(particleMoistureDomain10Data(:,2),[],'all');
    particleMoistureData = particleMoistureDomain9Data + particleMoistureDomain10Data;
    minParticleMoisture = min(particleMoistureData(:,2),[],'all');
    maxParticleMoisture = max(particleMoistureData(:,2),[],'all');
    
    % extract humidity data
    % exclude NaN entries
    humidityData = humidityData(~any(ismissing(humidityData),2),:);
    % build geometry
    geometryXHumidityData = table2array(humidityData(:,1));
    geometryYHumidityData = table2array(humidityData(:,2));
    if positionConstraint
        % constraint the geometry and therefore the moisture data field used for dmd
        idx = find(geometryXHumidityData >= xMin & geometryXHumidityData <= xMax & geometryYHumidityData >= yMin & geometryYHumidityData <= yMax);
        humidityData = humidityData(idx,:);
        geometryXHumidityData = table2array(humidityData(:,1));
        geometryYHumidityData = table2array(humidityData(:,2));
    end
    humidityData = table2array(humidityData(:,3:end));
    minHumidity = min(humidityData(:,2),[],'all');
    maxHumidity = max(humidityData(:,2),[],'all');

    % extract outlet humidity data
    inletHumidityData = table2array(inletHumidityData(~any(ismissing(inletHumidityData),2),:));
    minInletHumidity = min(inletHumidityData(:,2),[],'all');
    maxInletHumidity = max(inletHumidityData(:,2),[],'all');


    % extract outlet humidity data
    outletHumidityData = table2array(outletHumidityData(~any(ismissing(outletHumidityData),2),:));
    minOutletHumidity = min(outletHumidityData(:,2),[],'all');
    maxOutletHumidity = max(outletHumidityData(:,2),[],'all');
end



