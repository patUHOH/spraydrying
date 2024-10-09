% compute dmd of the system

% temperature
% truncate to rank-r
numInputsTemperature = size(UTemperature,1);
rtildeTemperature = rTemperature + numInputsTemperature;
Uxtilde1Temperature = UxTemperature(1:end-rtildeTemperature+rTemperature,1:rtildeTemperature); 
Uxtilde2Temperature = UxTemperature(end-rtildeTemperature+rTemperature+1:end,1:rtildeTemperature);
SxtildeTemperature = SxTemperature(1:rtildeTemperature,1:rtildeTemperature);
VxtildeTemperature = VxTemperature(:,1:rtildeTemperature);
UstildeTemperature = UsTemperature(:,1:rTemperature);
VstildeTemperature = VsTemperature(:,1:rTemperature);
SstildeTemperature = SsTemperature(1:rTemperature,1:rTemperature);
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
% truncate to rank-r
numInputsHumidity = size(UHumidity,1);
rtildeHumidity = rHumidity + numInputsHumidity;
Uxtilde1Humidity = UxHumidity(1:end-rtildeHumidity+rHumidity,1:rtildeHumidity);
Uxtilde2Humidity = UxHumidity(end-rtildeHumidity+rHumidity+1:end,1:rtildeHumidity);
SxtildeHumidity = SxHumidity(1:rtildeHumidity,1:rtildeHumidity);
VxtildeHumidity = VxHumidity(:,1:rtildeHumidity);
UstildeHumidity = UsHumidity(:,1:rHumidity);
VstildeHumidity = VsHumidity(:,1:rHumidity);
SstildeHumidity = SsHumidity(1:rHumidity,1:rHumidity);
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
