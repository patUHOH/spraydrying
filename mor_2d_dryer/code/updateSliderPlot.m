% add updateSliderPlot function
function updateSliderPlot(value, Phi, Bhat, geometryX, geometryY, plotHandleReal)
    % Update plot based on slider value
    % round value
    value = round(value);
    % Clear current figure of all axes objects, to preseve the slider
    % Find all axes objects in the current figure
    axesObjects = findobj(gcf, 'Type', 'Axes');

    % Preserve the slider and other UI elements by excluding them from clearing
    delete(setdiff(axesObjects, plotHandleReal.Parent));

    % subplot for real part
    subplot(2,1,1)
    % Plot the updated heatmap using heatmapir
    heatmapir(geometryX, geometryY, real(Phi(:,value)), 0.1, false);
    xlabel('x (m)');
    ylabel('y (m)');
    title(['Realpart DMD Mode ', num2str(value)]);
    colorbar;
    if min(real(Phi(:,value))) == max(real(Phi(:,value)))
        clim([min(real(Phi(:,value))), min(real(Phi(:,value)))+eps]);
    else
        clim([min(real(Phi(:,value))), max(real(Phi(:,value)))]);
    end
    % subplot for imaginary part
    subplot(2,1,2)
    % Plot the updated heatmap using heatmapir
    heatmapir(geometryX, geometryY, imag(Phi(:,value)), 0.1, false);
    xlabel('x (m)');
    ylabel('y (m)');
    title(['Imaginarypart DMD Mode ', num2str(value)]);
    colorbar;
    if min(imag(Phi(:,value))) == max(imag(Phi(:,value)))
        clim([min(imag(Phi(:,value))), min(imag(Phi(:,value)))+eps]);
    else
        clim([min(imag(Phi(:,value))), max(imag(Phi(:,value)))]);
    end
end