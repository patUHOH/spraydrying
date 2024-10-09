% compute svd for the two sets of snapshots
[UxTemperature,SxTemperature,VxTemperature] = svd(stateInputMatrixTemperature,'econ');
[UxHumidity,SxHumidity,VxHumidity] = svd(stateInputMatrixHumidity,'econ');
% compute svd of shifted snapshots
[UsTemperature,SsTemperature,VsTemperature] = svd(X2Temperature,'econ');
[UsHumidity,SsHumidity,VsHumidity] = svd(X2Humidity,'econ');