data = readtable([dataPath,'withoutParticles\temperatureData_withoutParticles'],'VariableNamingRule','preserve');
inletData = readtable([dataPath,'withoutParticles\inlet_temperatureData_withoutParticles'],'VariableNamingRule','preserve');
outletData = readtable([dataPath,'withoutParticles\outlet_temperatureData_withoutParticles'],'VariableNamingRule','preserve');
glass1Data = readtable([dataPath,'withoutParticles\glassSensor1_temperatureData_withoutParticles'],'VariableNamingRule','preserve');
glass2Data = readtable([dataPath,'withoutParticles\glassSensor2_temperatureData_withoutParticles'],'VariableNamingRule','preserve');
if useMoistureData
    humidityData = readtable([dataPath,'withoutParticles\humidityData_withoutParticles'],'VariableNamingRule','preserve');
    inletHumidityData = readtable([dataPath,'withoutParticles\inlet_humidityData_withoutParticles'],'VariableNamingRule','preserve');
    outletHumidityData = readtable([dataPath,'withoutParticles\outlet_humidityData_withoutParticles'],'VariableNamingRule','preserve');
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
temperatureDataWithoutParticles = table2array(data(:,3:end));
temperatureDataWithoutParticlesMin = min(temperatureDataWithoutParticles,[],'all');
temperatureDataWithoutParticlesMax = max(temperatureDataWithoutParticles,[],'all');

% extract inlet temperature data
inletTemperatureDataWithoutParticles = table2array(inletData(~any(ismissing(inletData),2),:));
minInletWithoutParticles = min(inletTemperatureDataWithoutParticles(:,2),[],'all');
maxInletWithoutParticles = max(inletTemperatureDataWithoutParticles(:,2),[],'all');

% extract measurement points
outletTemperatureDataWithoutParticles = table2array(outletData(~any(ismissing(outletData),2),:));
minOutletWithoutParticles = min(outletTemperatureDataWithoutParticles(:,2),[],'all');
maxOutletWithoutParticles = max(outletTemperatureDataWithoutParticles(:,2),[],'all');
glassSensor1TemperatureDataWithoutParticles = table2array(glass1Data(~any(ismissing(glass1Data),2),:));
minGlass1WithoutParticles = min(glassSensor1TemperatureDataWithoutParticles(:,2),[],'all');
maxGlass1WithoutParticles= max(glassSensor1TemperatureDataWithoutParticles(:,2),[],'all');
glassSensor2TemperatureDataWithoutParticles = table2array(glass2Data(~any(ismissing(glass2Data),2),:));
minGlass2WithoutParticles = min(glassSensor2TemperatureDataWithoutParticles(:,2),[],'all');
maxGlass2WithoutParticles = max(glassSensor2TemperatureDataWithoutParticles(:,2),[],'all');

if useMoistureData
    % extract humidity data
    humidityData = humidityData(~any(ismissing(humidityData),2),:);
    geometryXHumidityData = table2array(humidityData(:,1));
    geometryYHumidityData = table2array(humidityData(:,2));

    if positionConstraint
        % constraint the geometry and therefore the moisture data field used for dmd
        idx = find(geometryXHumidityData >= xMin & geometryXHumidityData <= xMax & geometryYHumidityData >= yMin & geometryYHumidityData <= yMax);
        humidityData = humidityData(idx,:);
        geometryXHumidityData = table2array(humidityData(:,1));
        geometryYHumidityData = table2array(humidityData(:,2));
    end
    humidityDataWithoutParticles = table2array(humidityData(:,3:end));
    minHumidityWithoutParticles = min(humidityDataWithoutParticles(:,2),[],'all');
    maxHumidityWithoutParticles = max(humidityDataWithoutParticles(:,2),[],'all');

    % extract outlet humidity data
    inletHumidityDataWithoutParticles = table2array(inletHumidityData(~any(ismissing(inletHumidityData),2),:));
    minintletHumidityWithoutParticles = min(inletHumidityDataWithoutParticles(:,2),[],'all');
    maxInletHumidityWithoutParticles = max(inletHumidityDataWithoutParticles(:,2),[],'all');

    % extract outlet humidity data
    outletHumidityDataWithoutParticles = table2array(outletHumidityData(~any(ismissing(outletHumidityData),2),:));
    minOutletHumidityWithoutParticles = min(outletHumidityDataWithoutParticles(:,2),[],'all');
    maxOutletHumidityWithoutParticles = max(outletHumidityDataWithoutParticles(:,2),[],'all');
end


