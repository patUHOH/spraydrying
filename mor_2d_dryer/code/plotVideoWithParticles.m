% plot data
recordVideoData = true;
plotEveryNthElement = 1;
if recordVideoData
    if useMoistureData
        videoFile = VideoWriter('..\results\originalTemperatureAndMoistureDataWithParticles.avi');
    else
        videoFile = VideoWriter('..\results\originalTemperatureDataWithParticles.avi');
    end
    open(videoFile);
    % Create a figure to plot the temperature profiles and heat maps
    fig = figure();
    set(fig, 'Position', [100, 100, 1600, 800]);

    for ii = 1:ceil(size(temperatureData, 2)/plotEveryNthElement)-1
        i = ii*plotEveryNthElement;
        % add sgtitle
        % sgtitle('DMD computation Dataset')
        % Plot temperature profile in 2D for each time instance
        % subplot(1, 3, 1);
        subplot(3,3,1)
        yyaxis left
        plot(timeSteps(1:i), inletTemperatureData(1:i,2));
        ylabel('Inlet Temperature (K)')
        grid on;
        xlim([tStart,tEndWithParticles])
        ylim([372,374])
        if useMoistureData
            yyaxis right
            plot(timeSteps(1:i), inletHumidityData(1:i,2));
            ylabel('Inlet Vapor Mass Fraction')
            ylim([0,0.2])
            xlim([tStart,tEndWithParticles])
        end
        % ylim([minInlet,maxInlet])
        subplot(3,3,2)
        yyaxis left
        plot(timeSteps(1:i), particleHeatData(1:i,2),'-', 'DisplayName', 'Particle Heat');
        ylabel('Particle Heat (W/m^3)')
        ylim([minParticleHeat,maxParticleHeat])
        grid on;
        xlim([tStart,tEndWithParticles])
        if useMoistureData
            yyaxis right
            plot(timeSteps(1:i), particleMoistureDomain9Data(1:i,2),'-', 'DisplayName', 'Domain 9');
            hold on;
            plot(timeSteps(1:i), particleMoistureDomain10Data(1:i,2),'-', 'DisplayName', 'Domain 10');
            ylabel('Particle Moisture')
            ylim([min(minParticleMoistureDomain9, minParticleMoistureDomain10),max(maxParticleMoistureDomain9, maxParticleMoistureDomain10)])
            legend()
            xlim([tStart,tEndWithParticles])
        end
        if useMoistureData
            subplot(3,3, [4,7])
            heatmapir(geometryXData,geometryYData,temperatureData(:,i)-temperatureData(:,1),0.1,false);
            colormap(jet); 
            cb = colorbar();
            ylabel(cb,'$\Delta T = T - T_\mathrm{init}$','Interpreter','latex', 'FontSize',12,'Rotation', 270);
            % clim([temperatureDataMin-min(temperatureData(:,1)), temperatureDataMax-max(temperatureData(:,1))]); % Add colorbar for temperature
            clim([-4, 1]); % Add colorbar for temperature
            title(['COMSOL FEM - Time: ', num2str(round(timeSteps(i),2),'%.02f')]);        xlabel('X Spatial Coordinate');
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
            subplot(3,3, [5,8]) 
            heatmapir(geometryXHumidityData,geometryYHumidityData,humidityData(:,i)-humidityData(:,1),0.1,false);
            colormap(jet);
            cb = colorbar();
            ylabel(cb,'$\Delta H = H - H_\mathrm{init}$','Interpreter','latex', 'FontSize',12,'Rotation', 270);
            clim([-0.025, 0.015]); % Add colorbar for humidity
            title(['COMSOL FEM - Time: ', num2str(round(timeSteps(i),2),'%.02f')]);  
            xlabel('X Spatial Coordinate');
            ylabel('Y Spatial Coordinate');
            % add sensor positions
            hold on;
            scatter(outletSensorPosition(:,1), outletSensorPosition(:,2), 30, 'w+','LineWidth',1.2);
            L = scatter(nan,nan,30,'k+','LineWidth',1.2);   
            legendEntries = {'OS'}; % only outlet sensor for humidity
            % exclude the heat map from the legend
            % add legend and supress ignore extra legend entries warning
            legend(L, legendEntries);
        else
            subplot(3,3, [4 5 7 8])
            heatmapir(geometryXData,geometryYData,temperatureData(:,i)-temperatureData(:,1),0.1,false);
            colormap(jet); 
            cb = colorbar();
            ylabel(cb,'$\Delta T = T - T_\mathrm{init}$','Interpreter','latex', 'FontSize',12,'Rotation', 270);
            % clim([temperatureDataMin-min(temperatureData(:,1)), temperatureDataMax-max(temperatureData(:,1))]); % Add colorbar for temperature
            clim([-4, 1]); % Add colorbar for temperature
            title(['COMSOL FEM - Time: ', num2str(round(timeSteps(i),2),'%.02f')]); 
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
        end
        subplot(3,3,3)
        yyaxis left
        plot(timeSteps(1:i), outletTemperatureData(1:i,2));
        ylabel('T(OS) (K)')
        grid on;
        xlim([tStart,tEndWithParticles])
        ylim([minOutlet,maxOutlet])
        if useMoistureData
            yyaxis right
            plot(timeSteps(1:i), outletHumidityData(1:i,2));
            ylabel('\phi (1)')
            grid on;
            xlim([tStart,tEndWithParticles])
            ylim([minOutletHumidity,maxOutletHumidity])
        end
        subplot(3,3,6)
        plot(timeSteps(1:i), glassSensor1TemperatureData(1:i,2));
        ylabel('T(GS1) (K)')
        grid on;
        xlim([tStart,tEndWithParticles])
        ylim([minGlass1,maxGlass1])
        ytickformat('%,.2f')
        subplot(3,3,9)
        plot(timeSteps(1:i), glassSensor2TemperatureData(1:i,2));
        ylabel('T(GS2) (K)')
        grid on;
        xlim([tStart,tEndWithParticles])
        ylim([minGlass2,maxGlass2])
        ytickformat('%,.2f')
        
        % % Create a heat map for the temperature distribution
        % subplot(1, 3, 2);
        % heatmapir(geometryX,geometryY,temperatureReconstructed(:,i),0.1,false);
        % colormap(jet); 
        % cb = colorbar();
        % ylabel(cb,'Temperature (K)', 'FontSize',12,'Rotation', 270);
        % clim([temperatureDataMin, temperatureDataMax]); % Add colorbar for temperature
        % title(['DMD rank r = ', num2str(r), ' - Time: ',  num2str(timeSteps(i))]);
        % xlabel('X Spatial Coordinate');
        % ylabel('Y Spatial Coordinate');
        % 
        % % Create a heat map for the kalmann filtered temperature distribution
        % subplot(1, 3, 3);
        % heatmapir(geometryX,geometryY,temperatureReconstructed_kf(:,i),0.1,false);
        % colormap(jet);
        % cb = colorbar();
        % ylabel(cb,'Temperature (K)', 'FontSize',12,'Rotation', 270);
        % clim([temperatureDataMin, temperatureDataMax]); % Add colorbar for temperature
        % title(['DMD with KF rank r = ', num2str(r), ' - Time: ',  num2str(timeSteps(i))]);
        % xlabel('X Spatial Coordinate');
        % ylabel('Y Spatial Coordinate');
        % % add measurement points
        % hold on;
        % scatter(measurementPointsPositions(:,1), measurementPointsPositions(:,2), 'k+');
        % % add glass sensors
        % scatter(glassSensor1Position(1), glassSensor1Position(2), 'k*');
        % scatter(glassSensor2Position(1), glassSensor2Position(2), 'kx');
        % % add legend entries for the sensors
        % legendEntries = {'LS', 'GS1', 'GS2'};
        % % exclude the heat map from the legend
        % h = get(gca,'Children');
        % h = h(1:end-1);
        % % add legend and supress ignore extra legend entries warning
        % legend(h, legendEntries);
        
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