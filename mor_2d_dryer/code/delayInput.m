function res = delayInput(u, Np)
    % u is a vector of inputs
    numTimeInstances = length(u);
    
    % Pre-allocate the result matrix V with numTimeInstances rows and Np columns
    res = zeros(numTimeInstances, Np);
    
    % Loop through each time step
    for t = 1:numTimeInstances
        % Fill in the current value and previous values up to Np delays
        for delay = 0:Np-1
            if t - delay > 0
                res(t, delay + 1) = u(t - delay);
            else
                res(t, delay + 1) = 0;  % Zero padding for earlier time steps
            end
        end
    end
end