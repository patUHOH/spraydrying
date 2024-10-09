% temperature

% only use the first input for the dmd
UStep1Temperature = UTemperature(1,:);
UStep2Temperature = UTemperature(2:end,:);
% stateInputMatrixStep1Temperature = [X1Temperature; UStep1Temperature];
stateInputMatrixStep1Temperature = [X1Case1Temperature; input1Case1']; % only use the first case for the dmd: on particles sprayed
X2Step1Temperature = X2Case1Temperature;

% compute svd of stateInputMatrix
[UxStep1Temperature,SxStep1Temperature,VxStep1Temperature] = svd(stateInputMatrixStep1Temperature,"econ");
% compute svd of shifted snapshots
[UsTemperature,SsTemperature,VsTemperature] = svd(X2Step1Temperature,'econ');

% compute dmd of the system

% truncate to rank-r
numInputsTemperature = size(UStep1Temperature,1);
rtildeTemperature = rTemperature + numInputsTemperature;
Uxtilde1Temperature = UxStep1Temperature(1:end-rtildeTemperature+rTemperature,1:rtildeTemperature); 
Uxtilde2Temperature = UxStep1Temperature(end-rtildeTemperature+rTemperature+1:end,1:rtildeTemperature);
SxtildeTemperature = SxStep1Temperature(1:rtildeTemperature,1:rtildeTemperature);
VxtildeTemperature = VxStep1Temperature(:,1:rtildeTemperature);
UstildeTemperature = UsTemperature(:,1:rTemperature);
VstildeTemperature = VsTemperature(:,1:rTemperature);
SstildeTemperature = SsTemperature(1:rTemperature,1:rTemperature);
tempTemperature = VxtildeTemperature/SxtildeTemperature*Uxtilde1Temperature'*UstildeTemperature;
AtildeTemperature = SstildeTemperature*VstildeTemperature'*VxtildeTemperature/SxtildeTemperature*Uxtilde1Temperature'*UstildeTemperature;

% compute eigendecomposition
[WTemperature,DTemperature] = eig(AtildeTemperature);
lambdasTemperature = diag(DTemperature);

% compute input mapping matrix
BtildeStep1Temperature = SstildeTemperature*VstildeTemperature'*VxtildeTemperature/SxtildeTemperature*Uxtilde2Temperature';

% Step 2: Pseudo-Inverse to find (X2 - A*X1 - B1*U1) = B2*U2
reducedDynamicsStep1Temperature = UstildeTemperature'*X2Temperature - AtildeTemperature*UstildeTemperature'*X1Temperature - BtildeStep1Temperature*UStep1Temperature;
BtildeStep2Temperature = reducedDynamicsStep1Temperature*pinv(UStep2Temperature);
BtildeTemperature = [BtildeStep1Temperature,BtildeStep2Temperature];

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

% only use the first input for the dmd
UStep1Humidity = UHumidity(1,:);
UStep2Humidity = UHumidity(2:end,:);
% stateInputMatrixStep1Humidity = [X1Humidity; UStep1Humidity];
stateInputMatrixStep1Humidity= [X1Case1Humidity; input2Case1']; % only use the first case for the dmd: on particles sprayed
X2Step1Humidity = X2Case1Humidity;

% compute svd of stateInputMatrix
[UxStep1Humidity,SxStep1Humidity,VxStep1Humidity] = svd(stateInputMatrixStep1Humidity,'econ');
% compute svd of shifted snapshots
[UsHumidity,SsHumidity,VsHumidity] = svd(X2Step1Humidity,'econ');

% compute dmd of the system

% truncate to rank-r
numInputsHumidity = size(UStep1Humidity,1);
rtildeHumidity = rHumidity + numInputsHumidity;
Uxtilde1Humidity = UxStep1Humidity(1:end-rtildeHumidity+rHumidity,1:rtildeHumidity);
Uxtilde2Humidity = UxStep1Humidity(end-rtildeHumidity+rHumidity+1:end,1:rtildeHumidity);
SxtildeHumidity = SxStep1Humidity(1:rtildeHumidity,1:rtildeHumidity);
VxtildeHumidity = VxStep1Humidity(:,1:rtildeHumidity);
UstildeHumidity = UsHumidity(:,1:rHumidity);
VstildeHumidity = VsHumidity(:,1:rHumidity);
SstildeHumidity = SsHumidity(1:rHumidity,1:rHumidity);
tempHumidity = VxtildeHumidity/SxtildeHumidity*Uxtilde1Humidity'*UstildeHumidity;
AtildeHumidity = SstildeHumidity*VstildeHumidity'*VxtildeHumidity/SxtildeHumidity*Uxtilde1Humidity'*UstildeHumidity;

% compute eigendecomposition
[WHumidity,DHumidity] = eig(AtildeHumidity);
lambdasHumidity = diag(DHumidity);

% compute input mapping matrix
BtildeStep1Humidity = SstildeHumidity*VstildeHumidity'*VxtildeHumidity/SxtildeHumidity*Uxtilde2Humidity';

% Step 2: Pseudo-Inverse to find (X2 - A*X1 - B1*U1) = B2*U2
reducedDynamicsStep1Humidity = UstildeHumidity'*X2Humidity - AtildeHumidity*UstildeHumidity'*X1Humidity - BtildeStep1Humidity*UStep1Humidity;
BtildeStep2Humidity = reducedDynamicsStep1Humidity*pinv(UStep2Humidity);
BtildeHumidity = [BtildeStep1Humidity,BtildeStep2Humidity];

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

