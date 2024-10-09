% close all; 
clear all; clc;
diary logFile
% add path to data folder
addpath('..\data');
% add path to results folder
addpath('..\results');
% specify parameters
dataPath = 'C:\Users\Arthur Lepsien\Nextcloud\Sprühtrocknung\DMD\2D_Dryer\data\temperatureAndMoisture\';
% dataPath = 'D:\Nextcloud\Sprühtrocknung\DMD\2D_Dryer\data\temperatureAndMoisture\';

% specify data sets
useMoistureData = true;
positionConstraint = true; % constrain the x and y position of the data points used for dmd
if positionConstraint
    xMin = 0.8; %min(geometryXData);
    xMax = 1.4; %max(geometryXData);
    yMin = 0.1; %min(geometryYData);
    yMax = 1.9; %max(geometryYData);
end

% specify position of the glass sensors
glassSensor1Position = [0.9, 1.4];
glassSensor2Position = [1.3, 1.7];
% position of the outlet measurement
outletSensorPosition = [1.1, 0.6];
% specify time instances
dt = 0.05;
tStart = 0;
tEndWithParticles = 4.2;
tEnd = 600;
timeSteps = tStart:dt:tEnd;
timeStepsWithParticles = tStart:dt:tEndWithParticles;

% lift particle inputs
useLiftedInputs = true;
useLiftedStates = false;
Np = 11; % Number of delays for the inputs

% dmd truncation rank 
rTemperature = 36; % 36
rHumidity = 36; % 36
% r = 12;
% reducedOrders = [1:1:40, 40:10:200];
reducedOrders = 1:1:40;

% specify dmd method 
method = 1; % 1 = usual dmd, 2 = decoupled dmd, 3 = decoupled dmd + pseudoinverse

% display particle histogram
% displayHistogramData

% read data without particles
readComsolDataWithoutParticles

% display results
% plotVideoWithoutParticles

% read data with particles
readComsolDataWithParticles

% display results
% plotVideoWithParticles

% build observables
buildObservables

% build snapshots for DMD
if method == 1
    buildSnapshotsCoupled
else
    buildSnapshotsDecoupled
end


% plot the input signals
% plotInputs

% compute svd
if method == 1
    computeSVDCoupled
else
    computeSVD
end

reducedOrders = 20;
for idxROM = 1:length(reducedOrders)
    rTemperature = reducedOrders(idxROM); % number of modes in ROM
    rHumidity = reducedOrders(idxROM); % number of modes in ROM
    r = reducedOrders(idxROM); 
    % plot energy content
    % plotEnergyContent

    % compute DMD
    if method == 1
        computeDMDCoupled
    elseif method == 2
        computeDMDDecoupled
    elseif method == 3
        computeDMDDecoupledinTwoSteps
    end


    % test reconstructability
    % testReconstructability
    
    % plot eigenvalues of reduced order system
    % plotEigenvaluesDMD
    
    % compute pseudo inverse for measurement matrix
    if method == 1
        computePseudoInverseMeasurementsCoupled
    elseif method == 2 || method == 3
        computePseudoInverseMeasurements
    end
    
    % plot DMD modes in spatial coordinates
    % plotDMDModes
    
    % display the input matrix
    % displayBMatrix
    
    % compute dynamics
    if method == 1
        computeDynamicsCoupled
    elseif method == 2 || method == 3
        % computeDynamics
        computeDynamicsWithGivenStructure
    end
    
    % compute kalman filter
    if method == 1
        computeKalmanFilterCoupled
    elseif method == 2 || method == 3
        % computeKalmanFilter
        computeKalmanWithGivenStructure
    end
    


    % calculate errors from reconstruction
    computeReconstructionError

    % plot reconstruction error
    % plotReconstructionError

    % display solution / error of DMD and KF
    % plotVideosSolution

    % compute validation data set errors
    computeValidation
end

% display RMSE of ROM
displayRMSE
displayRMSEValidation



diary off