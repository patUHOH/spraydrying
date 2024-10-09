% compute dmd of the system
% truncate to rank-r
numInputs = size(U,1);
rtilde = r + numInputs;
Uxtilde1 = Ux(1:end-rtilde+r,1:rtilde); 
Uxtilde2 = Ux(end-rtilde+r+1:end,1:rtilde);
Sxtilde = Sx(1:rtilde,1:rtilde);
Vxtilde = Vx(:,1:rtilde);
Ustilde = Us(:,1:r);
Vstilde = Vs(:,1:r);
Sstilde = Ss(1:r,1:r);
temp = Vxtilde/Sxtilde*Uxtilde1'*Ustilde;
Atilde = Sstilde*Vstilde'*Vxtilde/Sxtilde*Uxtilde1'*Ustilde;

% compute eigendecomposition
[W,D] = eig(Atilde);
lambdas = diag(D);

% compute input mapping matrix
Btilde = Sstilde*Vstilde'*Vxtilde/Sxtilde*Uxtilde2';
Bhat = Ustilde*Btilde;

% check for zero eigenvalues
[W, Lambda, zeroInd] = checkModes(W, D);
% DMD modes of A
Phi = Ustilde*W;
% DMD modes for zero eigenvalues
if ~isempty(zeroInd)
    disp('zero eigenvalue');
    Phi(:, end) = Uxtilde1*Uxtilde1'*Ustilde*W(:, end);
end