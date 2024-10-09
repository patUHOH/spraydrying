% use case 1 data to compute DMD modes for temperature and humidity
X1Step1Temperature = X1Case1Temperature;
X2Step1Temperature = X2Case1Temperature;
X1Step1Humidity = X1Case1Humidity;
X2Step1Humidity = X2Case1Humidity;
% compute shifted snapshot singular value decompositions
% compute svd of shifted snapshots for temperature
[UsTemperature,SsTemperature,VsTemperature] = svd(X2Step1Temperature,'econ');
% compute svd of shifted snapshots for humidity
[UsHumidity,SsHumidity,VsHumidity] = svd(X2Step1Humidity,'econ');
% do not use particle inputs for the DMD step
UStep1Temperature = input1Case1'; % only use the heating temperature
UStep1Humidity = input2Case1'; % only use the heating humidity
% use case 2 for pseudo-inverse to find B2
X1Step2Temperature = X1Case2Temperature;
X2Step2Temperature = X2Case2Temperature;
X1Step2Humidity = X1Case2Humidity;
X2Step2Humidity = X2Case2Humidity;
UTemperatureStep2Temperature = input1Case2'; % inlet heating temperature
UParticlesStep2Temperature = input3Case2'; % particle heating
UHumidityStep2Humidity = input2Case2'; % inlet humidity
UParticlesStep2Humidity = input4Case2'; % particle moisture


% truncate to rank-r
UstildeTemperature = UsTemperature(:,1:rTemperature);
VstildeTemperature = VsTemperature(:,1:rTemperature);
SstildeTemperature = SsTemperature(1:rTemperature,1:rTemperature);
UstildeHumidity = UsHumidity(:,1:rHumidity);
VstildeHumidity = VsHumidity(:,1:rHumidity);
SstildeHumidity = SsHumidity(1:rHumidity,1:rHumidity);

% project the snapshots onto the DMD modes to get the reduced order dynamics
temperatureInputCase1 = UstildeTemperature'*X1Step1Temperature;
temperatureInputCase2 = UstildeTemperature'*X1Step2Temperature;
humidityInputCase1 = UstildeHumidity'*X1Step1Humidity;
humidityInputCase2 = UstildeHumidity'*X1Step2Humidity;

% temperature
stateInputMatrixStep1Temperature = [X1Step1Temperature; UStep1Temperature; humidityInputCase1]; % only use the first case for the dmd: on particles sprayed
% compute svd of stateInputMatrix
[UxStep1Temperature,SxStep1Temperature,VxStep1Temperature] = svd(stateInputMatrixStep1Temperature,"econ");
% truncate to rank-r
numInputsTemperature = size([UStep1Temperature; humidityInputCase1],1);
rtildeTemperature = rTemperature + numInputsTemperature;
Uxtilde1Temperature = UxStep1Temperature(1:end-rtildeTemperature+rTemperature,1:rtildeTemperature); 
Uxtilde2Temperature = UxStep1Temperature(end-rtildeTemperature+rTemperature+1:end,1:rtildeTemperature);
SxtildeTemperature = SxStep1Temperature(1:rtildeTemperature,1:rtildeTemperature);
VxtildeTemperature = VxStep1Temperature(:,1:rtildeTemperature);
tempTemperature = VxtildeTemperature/SxtildeTemperature*Uxtilde1Temperature'*UstildeTemperature;
AtildeTemperature = SstildeTemperature*VstildeTemperature'*VxtildeTemperature/SxtildeTemperature*Uxtilde1Temperature'*UstildeTemperature;

% compute eigendecomposition
[WTemperature,DTemperature] = eig(AtildeTemperature);
lambdasTemperature = diag(DTemperature);

% compute input mapping matrix
BtildeStep1Temperature = SstildeTemperature*VstildeTemperature'*VxtildeTemperature/SxtildeTemperature*Uxtilde2Temperature';

% Step 2: Pseudo-Inverse to find (X2 - A*X1 - B1*U1) = B2*U2; ONLY USE CASE 2 DATA HERE!!
reducedDynamicsStep1Temperature = UstildeTemperature'*X2Step2Temperature - AtildeTemperature*UstildeTemperature'*X1Step2Temperature - BtildeStep1Temperature*[UTemperatureStep2Temperature; humidityInputCase2];
BtildeStep2Temperature = reducedDynamicsStep1Temperature*pinv(UParticlesStep2Temperature);
% reorder so that the input is in the correct order: 
% first input = inlet heating, 
% second input = particle heating
% third input = moisture
BtildeTemperature = [BtildeStep1Temperature(:,1),BtildeStep2Temperature,BtildeStep1Temperature(:,2:end)];

BhatTemperature = UstildeTemperature*BtildeTemperature;

% check for zero eigenvalues
[WTemperature, LambdaTemperature, zeroIndTemperature] = checkModes(WTemperature, DTemperature);
% DMD modes of A
PhiTemperature = UstildeTemperature*WTemperature;
% DMD modes for zero eigenvalues
if ~isempty(zeroIndTemperature)
    disp('zero eigenvalue');
    PhiTemperature(:, end) = Uxtilde1Temperature*Uxtilde1Temperature'*UstildeTemperature*WTemperature(:, end);
end

% humidity
stateInputMatrixStep1Humidity= [X1Step1Humidity; UStep1Humidity; temperatureInputCase1]; % only use the first case for the dmd: on particles sprayed
% compute svd of stateInputMatrix
[UxStep1Humidity,SxStep1Humidity,VxStep1Humidity] = svd(stateInputMatrixStep1Humidity,'econ');
% compute svd of shifted snapshots
[UsHumidity,SsHumidity,VsHumidity] = svd(X2Step1Humidity,'econ');
% compute dmd of the system
% truncate to rank-r
numInputsHumidity = size([UStep1Humidity; temperatureInputCase1],1);
rtildeHumidity = rHumidity + numInputsHumidity;
Uxtilde1Humidity = UxStep1Humidity(1:end-rtildeHumidity+rHumidity,1:rtildeHumidity);
Uxtilde2Humidity = UxStep1Humidity(end-rtildeHumidity+rHumidity+1:end,1:rtildeHumidity);
SxtildeHumidity = SxStep1Humidity(1:rtildeHumidity,1:rtildeHumidity);
VxtildeHumidity = VxStep1Humidity(:,1:rtildeHumidity);
tempHumidity = VxtildeHumidity/SxtildeHumidity*Uxtilde1Humidity'*UstildeHumidity;
AtildeHumidity = SstildeHumidity*VstildeHumidity'*VxtildeHumidity/SxtildeHumidity*Uxtilde1Humidity'*UstildeHumidity;

% compute eigendecomposition
[WHumidity,DHumidity] = eig(AtildeHumidity);
lambdasHumidity = diag(DHumidity);

% compute input mapping matrix
BtildeStep1Humidity = SstildeHumidity*VstildeHumidity'*VxtildeHumidity/SxtildeHumidity*Uxtilde2Humidity';

% Step 2: Pseudo-Inverse to find (X2 - A*X1 - B1*U1) = B2*U2; ONLY USE CASE 2 DATA HERE!!
reducedDynamicsStep1Humidity = UstildeHumidity'*X2Step2Humidity - AtildeHumidity*UstildeHumidity'*X1Step2Humidity - BtildeStep1Humidity*[UHumidityStep2Humidity;temperatureInputCase2];
BtildeStep2Humidity = reducedDynamicsStep1Humidity*pinv(UParticlesStep2Humidity);
BtildeHumidity = [BtildeStep1Humidity(:,1),BtildeStep2Humidity,BtildeStep1Humidity(:,2:end)];

BhatHumidity = UstildeHumidity*BtildeHumidity;

% check for zero eigenvalues
[WHumidity, LambdaHumidity, zeroIndHumidity] = checkModes(WHumidity, DHumidity);
% DMD modes of A
PhiHumidity = UstildeHumidity*WHumidity;
% DMD modes for zero eigenvalues
if ~isempty(zeroIndHumidity)
    disp('zero eigenvalue');
    PhiHumidity(:, end) = Uxtilde1Humidity*Uxtilde1Humidity'*UstildeHumidity*WHumidity(:, end);
end

