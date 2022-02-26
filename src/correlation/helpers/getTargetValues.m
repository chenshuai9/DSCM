%
% J.T. Ouwerling <j.t.ouwerling@student.rug.nl>, University of Groningen
% Date created: June 10, 2015
%
% Calculate information about the reference subset and return it as a struct, to prevent recalculation.
% 
% Input:
% 
% * rows: the discrete set of row values for the subset
% * cols: the discrete set of column values for the subset
% * config: the configuration struct
% 
% Output:
% A struct fData with the fields: values, mean and delta, dy and dx.
% 
% * values: the values at all points [0,255]
% * mean: the mean of all values
% * delta: the delta of all values
% * dy: df/dy at all points
% * dx: df/dx at all points
%
% function [fData] = getReferenceValues(rows, cols, config)
%

function [gData] = getTargetValues(rows, cols, config)
    gValues = zeros(size(rows, 2), size(cols,2));
    g_x = zeros(size(rows, 2), size(cols,2));
    g_y = zeros(size(rows, 2), size(cols,2));
    cfTar = config.imTarget.interpolation;
    
    % calculate the g values, and g_x and g_y
    for row = 1:size(rows,2)
        for col = 1:size(cols,2)
            r = floor(rows(row));
            c = floor(cols(col));
            x = cols(col) - c;
            y = rows(row) - r;
            % real value
            gValues(row,col) =  cfTar.a00(r,c)      + cfTar.a01(r,c)*y      + cfTar.a02(r,c)*y^2        + cfTar.a03(r,c)*y^3 + ...      % i = 0
                                cfTar.a10(r,c)*x    + cfTar.a11(r,c)*x*y    + cfTar.a12(r,c)*x*y^2      + cfTar.a13(r,c)*x*y^3 + ...    % i = 1
                                cfTar.a20(r,c)*x^2  + cfTar.a21(r,c)*x^2*y  + cfTar.a22(r,c)*x^2*y^2    + cfTar.a23(r,c)*x^2*y^3 + ...  % i = 2
                                cfTar.a30(r,c)*x^3  + cfTar.a31(r,c)*x^3*y  + cfTar.a32(r,c)*x^3*y^2    + cfTar.a33(r,c)*x^3*y^3;       % i = 3
            % derivative to x
            g_x(row, col) =     0                     + 0                         + 0                             + 0 + ...                         % i = 0
                                cfTar.a10(r,c)        + cfTar.a11(r,c)*y          + cfTar.a12(r,c)*y^2            + cfTar.a13(r,c)*y^3 + ...      % i = 1
                                2*cfTar.a20(r,c)*x    + 2*cfTar.a21(r,c)*x*y      + 2*cfTar.a22(r,c)*x*y^2        + 2*cfTar.a23(r,c)*x*y^3 + ...  % i = 2
                                3*cfTar.a30(r,c)*x^2  + 3*cfTar.a31(r,c)*x^2*y    + 3*cfTar.a32(r,c)*x^2*y^2      + 3*cfTar.a33(r,c)*x^2*y^3;     % i = 3
            
            % derivative to y  
            g_y(row, col) = 0 + cfTar.a01(r,c)        + 2*cfTar.a02(r,c)*y        + 3*cfTar.a03(r,c)*y^2 + ...      % i = 0
                            0 + cfTar.a11(r,c)*x      + 2*cfTar.a12(r,c)*x*y      + 3*cfTar.a13(r,c)*x*y^2 + ...    % i = 1
                            0 + cfTar.a21(r,c)*x^2    + 2*cfTar.a22(r,c)*x^2*y    + 3*cfTar.a23(r,c)*x^2*y^2 + ...  % i = 2
                            0 + cfTar.a31(r,c)*x^3    + 2*cfTar.a32(r,c)*x^3*y    + 3*cfTar.a33(r,c)*x^3*y^2;       % i = 3
            
             % derivative to x^2
             g_xx(row, col) =     0                     + 0                         + 0                             + 0 + ...                     % i = 0
                                0        + 0          + 0            + 0 + ...      % i = 1
                                2*cfTar.a20(r,c)    + 2*cfTar.a21(r,c)*y      + 2*cfTar.a22(r,c)*y^2        + 2*cfTar.a23(r,c)*y^3 + ...  % i = 2
                                6*cfTar.a30(r,c)*x  + 6*cfTar.a31(r,c)*x*y    + 6*cfTar.a32(r,c)*x*y^2      + 6*cfTar.a33(r,c)*x*y^3;     % i = 3
             % derivative to y^2
             g_yy(row, col) = 0 + 0        + 2*cfTar.a02(r,c)        + 6*cfTar.a03(r,c)*y + ...      % i = 0
                            0 + 0      + 2*cfTar.a12(r,c)*x      + 6*cfTar.a13(r,c)*x*y + ...    % i = 1
                            0 + 0    + 2*cfTar.a22(r,c)*x^2    + 6*cfTar.a23(r,c)*x^2*y + ...  % i = 2
                            0 + 0    + 2*cfTar.a32(r,c)*x^3    + 6*cfTar.a33(r,c)*x^3*y;       % i = 3
              % derivative to xy 
             g_xy(row, col) =     0                     + 0                         + 0                             + 0 + ...                         % i = 0
                                0        + cfTar.a11(r,c)          + 2*cfTar.a12(r,c)*y            + 3*cfTar.a13(r,c)*y^2 + ...      % i = 1
                                0    + 2*cfTar.a21(r,c)*x      + 4*cfTar.a22(r,c)*x*y        + 6*cfTar.a23(r,c)*x*y^2 + ...  % i = 2
                                0  + 3*cfTar.a31(r,c)*x^2    + 6*cfTar.a32(r,c)*x^2*y      + 9*cfTar.a33(r,c)*x^2*y^2;     % i = 3
         
        end
    end
    

    % calculate the mean
    gMean = mean2(gValues);
    
    % calculate delta f
    deltag = 0;
    for row = 1:size(rows, 2)
        for col = 1:size(cols, 2)
            deltag = deltag + (gValues(row, col) - gMean)^2;
        end
    end
    deltag = sqrt(deltag);
    
    
    % Return the struct with the reference image data
    gData = struct( ...
        'values', gValues, ...
        'mean', gMean, ...
        'delta', deltag, ...
        'dy', g_y, ...
        'dx', g_x, ...
        'dyy', g_yy, ...
        'dxx', g_xx, ...
        'dxy', g_xy ...
    );
    
end