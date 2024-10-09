% add updateSliderPlot function
function updateSliderPlotMatrix(value, Bhat, geometryX, geometryY, plotHandle,dataType)
    % Update plot based on slider value
    % round value
    value = round(value);
    % Clear current figure of all axes objects, to preseve the slider
    % Find all axes objects in the current figure
    axesObjects = findobj(gcf, 'Type', 'Axes');

    % Preserve the slider and other UI elements by excluding them from clearing
    delete(setdiff(axesObjects, plotHandle.Parent));

    
    % Plot the updated heatmap using heatmapir
    heatmapir(geometryX, geometryY, Bhat(:,value), 0.1, false);
    xlabel('x (m)');
    ylabel('y (m)');
    title([dataType,' ', num2str(value)]);
    colorbar;
    clim([min((Bhat(:,value))), max((Bhat(:,value)))])
end