% compute shifted snapshot singular value decompositions
% compute svd of shifted snapshots for temperature
[UsTemperature,SsTemperature,VsTemperature] = svd(X2Temperature,'econ');
% compute svd of shifted snapshots for humidity
[UsHumidity,SsHumidity,VsHumidity] = svd(X2Humidity,'econ');

% truncate to rank-r
UstildeTemperature = UsTemperature(:,1:rTemperature);
VstildeTemperature = VsTemperature(:,1:rTemperature);
SstildeTemperature = SsTemperature(1:rTemperature,1:rTemperature);
UstildeHumidity = UsHumidity(:,1:rHumidity);
VstildeHumidity = VsHumidity(:,1:rHumidity);
SstildeHumidity = SsHumidity(1:rHumidity,1:rHumidity);

% project the snapshots onto the DMD modes to get the reduced order dynamics
temperatureInput = UstildeTemperature'*X1Temperature;
humidityInput = UstildeHumidity'*X1Humidity;
% temperature
% append the reduced order humidities as input to the temperature dmd
stateInputMatrixTemperature = [X1Temperature; UTemperature; humidityInput];

% compute svd of stateInputMatrix
[UxStep1Temperature,SxStep1Temperature,VxStep1Temperature] = svd(stateInputMatrixTemperature,"econ");


% compute dmd of the system

% truncate to rank-r
numInputsTemperature = size([UTemperature; humidityInput],1);
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
BtildeTemperature = SstildeTemperature*VstildeTemperature'*VxtildeTemperature/SxtildeTemperature*Uxtilde2Temperature';
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

% append the reduced order temperatures as input to the humidity dmd
stateInputMatrixHumidity = [X1Humidity; UHumidity; temperatureInput];

% compute svd of stateInputMatrix
[UxStep1Humidity,SxStep1Humidity,VxStep1Humidity] = svd(stateInputMatrixHumidity,"econ");

% truncate to rank-r
numInputsHumidity = size([UHumidity; temperatureInput],1);
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
BtildeHumidity = SstildeHumidity*VstildeHumidity'*VxtildeHumidity/SxtildeHumidity*Uxtilde2Humidity';
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
