% plot data
recordVideoData = true;
plotEveryNthElement = 20;
if recordVideoData
    if useMoistureData
        videoFile = VideoWriter('..\results\originalAndDmdTemperatureAndMoistureDataWithoutParticles.avi');
    else
        videoFile = VideoWriter('..\results\originalAndDmdTemperatureDataWithoutParticles.avi');
    end
    open(videoFile);
    % Create a figure to plot the temperature profiles and heat maps
    fig = figure();
    set(fig, 'Position', [100, 100, 1600, 800]);

    for ii = 1:ceil(size(temperatureDataWithoutParticles, 2)/plotEveryNthElement)-1
        i = ii*plotEveryNthElement;
        subplot(3,3,[1 2])
        % yyaxis left
        plot(timeSteps(1:i), inletTemperatureDataWithoutParticles(1:i,2));
        ylabel('Inlet Temperature (K)')
        grid on;
        xlim([tStart,tEnd])
        ylim([minInletWithoutParticles,maxInletWithoutParticles])
        % if useMoistureData
        %     yyaxis right
        %     plot(timeSteps(1:i), inletHumidityDataWithoutParticles(1:i,2));
        %     ylabel('Inlet Vapor Mass Fraction')
        %     ylim([0,0.2])
        %     xlim([tStart,tEnd])
        % end

        subplot(3,3, [4 7])
        heatmapir(geometryXData,geometryYData,temperatureDataWithoutParticles(:,i)-temperatureDataWithoutParticles(:,1),0.1,false);
        colormap(jet); 
        cb = colorbar();
        ylabel(cb,'$\Delta T_\mathrm{FEM} = T_\mathrm{FEM} - T_\mathrm{init}$','Interpreter','latex', 'FontSize',12,'Rotation', 270);
        % clim([temperatureDataMin-min(temperatureData(:,1)), temperatureDataMax-max(temperatureData(:,1))]); % Add colorbar for temperature
        clim([-1, 140]); % Add colorbar for temperature
        title(['FEM - Time: ', num2str(round(timeSteps(i),2),'%.02f')]); 
        xlabel('X Spatial Coordinate');
        ylabel('Y Spatial Coordinate');
        % add sensor positions
        hold on;
        scatter(outletSensorPosition(:,1), outletSensorPosition(:,2), 30, 'w+','LineWidth',1.2);
        L(1) = scatter(nan,nan,30,'k+','LineWidth',1.2);
        % add glass sensors
        scatter(glassSensor1Position(1), glassSensor1Position(2), 30, 'w*','LineWidth',1.2);
        L(2) = scatter(nan,nan,30,'k*','LineWidth',1.2);
        scatter(glassSensor2Position(1), glassSensor2Position(2), 30, 'wx','LineWidth',1.2);
        L(3) = scatter(nan,nan,30,'kx','LineWidth',1.2);
        % add legend entries for the sensors
        legendEntries = {'OS', 'GS1', 'GS2'};
        % exclude the heat map from the legend
        % add legend and supress ignore extra legend entries warning
        legend(L, legendEntries);

        subplot(3,3, [5 8])
        heatmapir(geometryXData,geometryYData,temperatureReconstructedWithoutParticles(:,i)-temperatureDataWithoutParticles(:,1),0.1,false);
        colormap(jet); 
        cb = colorbar();
        ylabel(cb,'$\Delta T_{DMD} = T_{DMD} - T_\mathrm{init}$','Interpreter','latex', 'FontSize',12,'Rotation', 270);
        % clim([temperatureDataMin-min(temperatureData(:,1)), temperatureDataMax-max(temperatureData(:,1))]); % Add colorbar for temperature
        clim([-1, 140]); % Add colorbar for temperature
        title(['DMD - Time: ', num2str(round(timeSteps(i),2),'%.02f')]); 
        xlabel('X Spatial Coordinate');
        ylabel('Y Spatial Coordinate');
        % add sensor positions
        hold on;
        scatter(outletSensorPosition(:,1), outletSensorPosition(:,2), 30, 'w+','LineWidth',1.2);
        L(1) = scatter(nan,nan,30,'k+','LineWidth',1.2);
        % add glass sensors
        scatter(glassSensor1Position(1), glassSensor1Position(2), 30, 'w*','LineWidth',1.2);
        L(2) = scatter(nan,nan,30,'k*','LineWidth',1.2);
        scatter(glassSensor2Position(1), glassSensor2Position(2), 30, 'wx','LineWidth',1.2);
        L(3) = scatter(nan,nan,30,'kx','LineWidth',1.2);
        % add legend entries for the sensors
        legendEntries = {'OS', 'GS1', 'GS2'};
        % exclude the heat map from the legend
        % add legend and supress ignore extra legend entries warning
        legend(L, legendEntries);

        subplot(3,3,3)
        % yyaxis left
        plot(timeSteps(1:i), outletTemperatureDataWithoutParticles(1:i,2),'b-','DisplayName','$y$');
        hold on;
        plot(timeSteps(1:i), measurementsReconstructedWithoutParticles(1:i,1),'r--','DisplayName','$\hat y_\mathrm{dmd}$');
        plot(timeSteps(1:i), estimatedMeasurementsCase1(1:i,1),'k--','DisplayName','$\hat y_\mathrm{kf}$');
        ylabel('T(OS) (K)')
        grid on;
        xlim([tStart,tEnd])
        ylim([min([minOutletWithoutParticles,minOutletTemperatureReconstructedWithoutParticles,minOutletTemperatureKFWithoutParticles]),max([maxOutlet,maxOutletTemperatureReconstructedWithoutParticles,maxOutletTemperatureKFWithoutParticles])])
        legend(Interpreter='latex')
        subplot(3,3,6)
        plot(timeSteps(1:i), glassSensor1TemperatureDataWithoutParticles(1:i,2),'b-','DisplayName','$y$');
        hold on;
        plot(timeSteps(1:i), measurementsReconstructedWithoutParticles(1:i,2),'r--','DisplayName','$\hat y_\mathrm{dmd}$');
        plot(timeSteps(1:i), estimatedMeasurementsCase1(1:i,2),'k--','DisplayName','$\hat y_\mathrm{kf}$');
        ylabel('T(GS1) (K)')
        grid on;
        xlim([tStart,tEnd])
        ylim([min([minGlass1WithoutParticles,minGlassSensor1TemperatureReconstructedWithoutParticles,maxGlassSensor1TemperatureKFWithoutParticles]),max([maxGlass1,maxGlassSensor1TemperatureReconstructedWithoutParticles,maxGlassSensor1TemperatureKFWithoutParticles])])
        legend(Interpreter='latex')
        ytickformat('%,.2f')
        subplot(3,3,9)
        plot(timeSteps(1:i), glassSensor2TemperatureDataWithoutParticles(1:i,2),'b-','DisplayName','$y$');
        hold on;
        plot(timeSteps(1:i), measurementsReconstructedWithoutParticles(1:i,3),'r--','DisplayName','$\hat y_\mathrm{dmd}$');
        plot(timeSteps(1:i), estimatedMeasurementsCase1(1:i,3),'k--','DisplayName','$\hat y_\mathrm{kf}$');
        ylabel('T(GS2) (K)')
        grid on;
        xlim([tStart,tEnd])
        ylim([min([minGlass2WithoutParticles,minGlassSensor2TemperatureReconstructedWithoutParticles,minGlassSensor2TemperatureKFWithoutParticles]),max([maxGlass2,maxGlassSensor2TemperatureReconstructedWithoutParticles,maxGlassSensor2TemperatureKFWithoutParticles])])
        ytickformat('%,.2f')
        legend(Interpreter='latex')
        
        drawnow;
        % Capture the frame and add it to the video
        frame = getframe(gcf);
        writeVideo(videoFile, frame);
        
        pause(0.01); % Adjust pause time if needed for visualization
        
        % Clear the current plot to update with the next frame
        clf(fig);
    end

    % Close the video file
    close(videoFile);
end