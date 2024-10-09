% [particleDiameterHistogramDataName, particleDiameterHistogramDataPath] = uigetfile('..\data\*.csv', 'Select the particle diameter histogram data file');
% [particleTemperatureHistogramDataName, particleTemperatureHistogramDataPath] = uigetfile('..\data\*.csv', 'Select the particle temperature histogram data file');
% try
%     particleDiameterHistogramData = readtable([particleDiameterHistogramDataPath,particleDiameterHistogramDataName],'VariableNamingRule','preserve');
%     particleTemperatureHistogramData = readtable([particleTemperatureHistogramDataPath,particleTemperatureHistogramDataName],'VariableNamingRule','preserve');
% catch
%     disp('No valid file selected!')
% end
particleDiameterHistogramData = readtable([dataPath,'withParticles\particle_diameter_histogram'],'VariableNamingRule','preserve');
particleTemperatureHistogramData = readtable([dataPath,'withParticles\particle_temperature_histogram'],'VariableNamingRule','preserve');

% times = 0:0.05:0.5;
times = 0:0.1:0.5;
% extract particle histogram data
particleDiameterHistogramCounts = table2array(particleDiameterHistogramData(:,2));
particleDiameterHistogramDiameter = table2array(particleDiameterHistogramData(:,1));
particleTemperatureHistogramCounts = table2array(particleTemperatureHistogramData(:,2));
particleTemperatureHistogramTemperature = table2array(particleTemperatureHistogramData(:,1));
% extract time instances, i.e. when diameter decreases -> new time instance
timeInstances = find(diff(particleDiameterHistogramDiameter) < 0);
% for each time instance, extract the particle histogram data
particleDiameterHistogramData = cell(length(timeInstances),1);
particleTemperatureHistogramData = cell(length(timeInstances),1);
for i = 1:length(times)
    if i == 1
        particleDiameterHistogramData{i}.Counts = particleDiameterHistogramCounts(1:timeInstances(i));
        particleDiameterHistogramData{i}.Diameter = particleDiameterHistogramDiameter(1:timeInstances(i));
        particleTemperatureHistogramData{i}.Counts = particleTemperatureHistogramCounts(1:timeInstances(i));
        particleTemperatureHistogramData{i}.Temperature = particleTemperatureHistogramTemperature(1:timeInstances(i));
    else
        particleDiameterHistogramData{i}.Counts = particleDiameterHistogramCounts(timeInstances(i-1)+1:timeInstances(i));
        particleDiameterHistogramData{i}.Diameter = particleDiameterHistogramDiameter(timeInstances(i-1)+1:timeInstances(i));
        particleTemperatureHistogramData{i}.Counts = particleTemperatureHistogramCounts(timeInstances(i-1)+1:timeInstances(i));
        particleTemperatureHistogramData{i}.Temperature = particleTemperatureHistogramTemperature(timeInstances(i-1)+1:timeInstances(i));
    end
end
particleDiameterHistogramData{i+1}.Counts = particleDiameterHistogramCounts(timeInstances(i)+1:end);
particleDiameterHistogramData{i+1}.Diameter = particleDiameterHistogramDiameter(timeInstances(i)+1:end);
particleTemperatureHistogramData{i+1}.Counts = particleTemperatureHistogramCounts(timeInstances(i)+1:end);
particleTemperatureHistogramData{i+1}.Temperature = particleTemperatureHistogramTemperature(timeInstances(i)+1:end);

% plot data
figure();
for i = 1:length(times)
    subplot(2,1,1)
    plot(particleDiameterHistogramData{i}.Diameter,particleDiameterHistogramData{i}.Counts,'DisplayName',sprintf('t = %.2f s',times(i)));
    hold on;
    grid on;
    ylabel('Relative counts');
    xlabel('Particle diameter (\mum)');
    legend('show');
    subplot(2,1,2)
    plot(particleTemperatureHistogramData{i}.Temperature,particleTemperatureHistogramData{i}.Counts,'DisplayName',sprintf('t = %.2f s',times(i)));
    hold on;
    grid on;
    ylabel('Relative counts');
    xlabel('Particle temperature (K)');
    legend('show');
end
exportPlots('histograms')
