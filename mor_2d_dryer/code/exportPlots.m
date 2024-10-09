function exportPlots(runname)
    %% This script exports plots of the scenarios to latex with matlab2tikz
    addpath(genpath('matlab2tikz'))
    %% set experiment name
    experimentName = strcat(runname, '_tikz');%'ellipsoid';%'csgSeparate'; %'hardMaxPointVessel';%'hardMaxVesselOutline';
    
    exportPath = strcat(fileparts(cd), '/results/Plots/');%'E:\Uni\Master\HiWi RT\Spraydrying\Data_Processing\Curve_Fit\Code\Plots';
    
    reduceDataPoints = true;
    % resolution (to reduce data points to manageable number
    resolution = 300; %in dpi, standard would be 300
    plotWidth = 8; % print width of plot in in cm
    
    
    % check type of figure
    figname = get(gcf,'Name');
    figureName = strcat(experimentName,figname);
           
    
    matlab2tikz('filename',strcat(exportPath,'/',experimentName,'/',figureName,'.tex'),'externalData',true,'relativeDataPath',strcat('figuredata/',figureName,'/'),...
                'height','0.1\textheight','width','0.8\columnwidth','showInfo', false)
end

