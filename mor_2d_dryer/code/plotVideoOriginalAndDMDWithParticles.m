% plot data
recordVideoData = true;
plotEveryNthElement = 1;
if recordVideoData
    if useMoistureData
        videoFile = VideoWriter('..\results\originalAndDmdTemperatureAndMoistureDataWithParticles.avi');
    else
        videoFile = VideoWriter('..\results\originalAndDmdTemperatureDataWithParticles.avi');
    end
    open(videoFile);
    % Create a figure to plot the temperature profiles and heat maps
    fig = figure();
    set(fig, 'Position', [100, 100, 1600, 800]);

    for ii = 1:ceil(size(temperatureData, 2)/plotEveryNthElement)-1
        i = ii*plotEveryNthElement;
        subplot(3,3,[1 2])
        % yyaxis left
        plot(timeSteps(1:i), inletTemperatureData(1:i,2));
        ylabel('Inlet Temperature (K)')
        grid on;
        xlim([tStart,tEndWithParticles])
        ylim([minInlet,maxInlet])
        % if useMoistureData
        %     yyaxis right
        %     plot(timeSteps(1:i), inletHumidityData(1:i,2));
        %     ylabel('Inlet Vapor Mass Fraction')
        %     ylim([0,0.2])
        %     xlim([tStart,tEndWithParticles])
        % end

        subplot(3,3, [4 7])
        % heatmapir(geometryXData,geometryYData,temperatureReconstructedWithParticles(:,i)-temperatureData(:,i),0.1,false);
        heatmapir(geometryXData,geometryYData,temperatureData(:,i)-temperatureData(:,1),0.1,false);
        colormap(jet); 
        cb = colorbar();
        ylabel(cb,'$\Delta T_\mathrm{FEM} = T_\mathrm{FEM} - T_\mathrm{init}$','Interpreter','latex', 'FontSize',12,'Rotation', 270);
        % clim([temperatureDataMin-min(temperatureData(:,1)), temperatureDataMax-max(temperatureData(:,1))]); % Add colorbar for temperature
        clim([-2, 0.1]); % Add colorbar for temperature
        title(['FEM - Time: ', num2str(round(timeSteps(i),2),'%.02f')]); 
        xlabel('x (m)');
        ylabel('y (m)');
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
        heatmapir(geometryXData,geometryYData,temperatureReconstructedWithParticles(:,i)-temperatureData(:,1),0.1,false);
        colormap(jet); 
        cb = colorbar();
        ylabel(cb,'$\Delta T_{DMD} = T_{DMD} - T_\mathrm{init}$','Interpreter','latex', 'FontSize',12,'Rotation', 270);
        % clim([temperatureDataMin-min(temperatureData(:,1)), temperatureDataMax-max(temperatureData(:,1))]); % Add colorbar for temperature
        clim([-2, 0.1]); % Add colorbar for temperature
        title(['DMD - Time: ', num2str(round(timeSteps(i),2),'%.02f')]); 
        xlabel('x (m)');
        ylabel('y (m)');
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
        plot(timeSteps(1:i), outletTemperatureData(1:i,2),'b-','DisplayName','$y$');
        hold on;
        plot(timeSteps(1:i), measurementsReconstructedWithParticles(1:i,1),'r--','DisplayName','$\hat y_\mathrm{dmd}$');
        plot(timeSteps(1:i), estimatedMeasurementsCase2(1:i,1),'k--','DisplayName','$\hat y_\mathrm{kf}$');
        ylabel('T(OS) (K)')
        grid on;
        xlim([tStart,tEndWithParticles])
        ylim([min([minOutlet,minOutletTemperatureReconstructedWithParticles,minOutletTemperatureKFWithParticles]),max([maxOutlet,maxOutletTemperatureReconstructedWithParticles,maxOutletTemperatureKFWithParticles])])
        legend(Interpreter='latex')
        subplot(3,3,6)
        plot(timeSteps(1:i), glassSensor1TemperatureData(1:i,2),'b-','DisplayName','$y$');
        hold on;
        plot(timeSteps(1:i), measurementsReconstructedWithParticles(1:i,2),'r--','DisplayName','$\hat y_\mathrm{dmd}$');
        plot(timeSteps(1:i), estimatedMeasurementsCase2(1:i,2),'k--','DisplayName','$\hat y_\mathrm{kf}$');
        ylabel('T(GS1) (K)')
        grid on;
        xlim([tStart,tEndWithParticles])
        ylim([min([minGlass1,minGlassSensor1TemperatureReconstructedWithParticles,minGlassSensor1TemperatureKFWithParticles]),max([maxGlass1,maxGlassSensor1TemperatureReconstructedWithParticles,maxGlassSensor1TemperatureKFWithParticles])])
        legend(Interpreter='latex')
        ytickformat('%,.2f')
        subplot(3,3,9)
        plot(timeSteps(1:i), glassSensor2TemperatureData(1:i,2),'b-','DisplayName','$y$');
        hold on;
        plot(timeSteps(1:i), measurementsReconstructedWithParticles(1:i,3),'r--','DisplayName','$\hat y_\mathrm{dmd}$');
        plot(timeSteps(1:i), estimatedMeasurementsCase2(1:i,3),'k--','DisplayName','$\hat y_\mathrm{kf}$');
        ylabel('T(GS2) (K)')
        grid on;
        xlim([tStart,tEndWithParticles])
        ylim([min([minGlass2,minGlassSensor2TemperatureReconstructedWithParticles,minGlassSensor2TemperatureKFWithParticles]),max([maxGlass2,maxGlassSensor2TemperatureReconstructedWithParticles,maxGlassSensor2TemperatureKFWithParticles])])
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