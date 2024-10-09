function h=heatmapir(x, y, z, s, showTriangles)
    %% default parameters
    if (nargin<4)||isempty(s)                                                   % no shrink factor provided
       s=0.1;                                                                   % default value
    end
    if nargin < 5 || isempty(showTriangles)
        showTriangles = true; % Show triangles by default
    end
    %% Remove duplicate data points
    [xy,ind] = unique([x, y], 'rows');
    z = z(ind);
    x = xy(:, 1);
    y = xy(:, 2);
    %% triangulate data points
    dt = delaunayTriangulation(x, y);                                           % Delaunay triangulation
    x = dt.Points(:, 1);
    y = dt.Points(:, 2);
    %% find enclosing boundary
    k = boundary(x, y, s);                                                      % define boundary enclosing all data points
    c = [k(1:end-1), k(2:end)];                                                 % constraints
    dt.Constraints = c;                                                         % add constraints
    io = dt.isInterior();                                                       % triangles which are in the interior of domain
    tri = dt.ConnectivityList;                                                  % read triangles
    tri = tri(io, :);                                                           % use only triangles in the interior
    %% plot
    % Use contourf to create a filled contour plot representing temperature
    % h = trisurf_2d(tri, x, y, z, 'FaceColor', 'interp', opt{:});                    % filled contour plot
    h = trisurf_2d(tri, x, y, z, showTriangles);                    % filled contour plot
    colormap(jet);                                                              % set colormap
    colorbar;                                                                   % add colorbar
    title('Temperature Profile - Filled Contour');                                % set title
    xlabel('X Spatial Coordinate');                                              % set x-axis label
    ylabel('Y Spatial Coordinate');                                              % set y-axis label
end
