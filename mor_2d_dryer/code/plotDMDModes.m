% calculate the number of modes
numModes = size(Phi, 2);
numInputs = size(Bhat, 2);
numOutputs = size(Ctilde, 1);

% plot the input representation in 2d space
fig = figure();
set(fig, 'Position', [100, 100, 1600, 800]);
plotHandle = heatmapir(geometryXData, geometryYData, Bhat(:,1), 0.1, false);
xlabel('x (m)');
ylabel('y (m)');
title(['Input ', num2str(1)]);
colorbar;
clim([min((Bhat(:,1))), max((Bhat(:,1)))])
updatePlot = @(value) updateSliderPlotMatrix(value, Bhat, geometryXData, geometryYData, plotHandle,'Input');
% Create slider
slider = uicontrol('Style', 'slider', 'Min', 1, 'Max', numInputs, 'Value', 1, 'Position', [400 20 400 20]);
% Add callback function to slider
slider.Callback = @(es, ed) updatePlot(es.Value);
% Label the slider
uicontrol('Style', 'text', 'Position', [300 15 100 20], 'String', 'DMD Mode Slider');
% Set slider step to integer increments
slider.SliderStep = [1/numInputs, 1]; % Ensure the first value is at least stepSize


% plot the output representation in 2d space
figOutputs = figure();
set(figOutputs, 'Position', [100, 100, 1600, 800]);
plotHandleOutputs = heatmapir(geometryXData, geometryYData, Chat(1,:), 0.1, false);
xlabel('x (m)');
ylabel('y (m)');
title(['Output ', num2str(1)]);
colorbar;
clim([min((Chat(1,:))), max((Chat(1,:)))])
updatePlotOutputs = @(value) updateSliderPlotMatrix(value, Chat', geometryXData, geometryYData, plotHandleOutputs,'Output');
% Create slider
sliderOutputs = uicontrol('Style', 'slider', 'Min', 1, 'Max', numOutputs, 'Value', 1, 'Position', [400 20 400 20]);
% Add callback function to slider
sliderOutputs.Callback = @(es, ed) updatePlotOutputs(es.Value);
% Label the slider
uicontrol('Style', 'text', 'Position', [300 15 100 20], 'String', 'DMD Mode Slider');
% Set slider step to integer increments
sliderOutputs.SliderStep = [1/numOutputs, 1]; % Ensure the first value is at least stepSize


% plot the dmd modes
fig2 = figure();
set(fig2, 'Position', [100, 100, 1600, 800]);
% subplot for real part
subplot(2,1,1)
% Plot the updated heatmap using heatmapir
plotHandleReal = heatmapir(geometryXData, geometryYData, real(Phi(:,1)), 0.1, false);
xlabel('x (m)');
ylabel('y (m)');
title(['Realpart DMD Mode ', num2str(1)]);
colorbar;
clim([min(real(Phi(:,1))), max(real(Phi(:,1)))]);
% subplot for imaginary part
subplot(2,1,2)
% Plot the updated heatmap using heatmapir
plotHandleImag = heatmapir(geometryXData, geometryYData, imag(Phi(:,1)), 0.1, false);
xlabel('x (m)');
ylabel('y (m)');
title(['Imaginarypart DMD Mode ', num2str(1)]);
colorbar;
if min(imag(Phi(:,1))) == max(imag(Phi(:,1)))
    clim([min(imag(Phi(:,1))), min(imag(Phi(:,1)))+eps]);
end
% Function to update plot when slider changes
updatePlotStates = @(value) updateSliderPlot(value, Phi, Bhat, geometryXData, geometryYData, plotHandleReal);
% Create slider
sliderStates = uicontrol('Style', 'slider', 'Min', 1, 'Max', numModes, 'Value', 1, 'Position', [400 20 400 20]);
% Add callback function to slider
sliderStates.Callback = @(es, ed) updatePlotStates(es.Value);
% Label the slider
uicontrol('Style', 'text', 'Position', [300 15 100 20], 'String', 'DMD Mode Slider');
% Set slider step to integer increments
sliderStates.SliderStep = [1/numModes, 1]; % Ensure the first value is at least stepSize

