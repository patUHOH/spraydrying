function res = computeObservables(data, functionHandles)
    % iterate over the function handles
    for i = 1:length(functionHandles)
        % apply the function handle to the data
        observables{i} = functionHandles{i}(data);
    end
    % recast into matrix
    res = cell2mat(observables);
end