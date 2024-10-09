% compute svd of stateInputMatrix
[Ux,Sx,Vx] = svd(stateInputMatrix,'econ');
% compute svd of shifted snapshots
[Us,Ss,Vs] = svd(X2,'econ');