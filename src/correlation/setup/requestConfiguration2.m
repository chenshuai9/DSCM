%
% J.T. Ouwerling <j.t.ouwerling@student.rug.nl>, University of Groningen
% Date created: June 3, 2015
%
% This file shows the configuration screen and handles the input. It returns the input as a struct.
% 
% Input: none
% 
% Output:
% A success indicator (1 for succes, 0 for failire) and a struct, with the following fields
% 
% * imReference.file: the file of the reference image
% * imTarget.file: the file of the target image
% * subsetSize: a substruct with width and height
% * gridSpacing: a substruct with fields rows and cols
% * convergenceCriterion: when |dp| is smaller than this, stop optimizing
% * maxIterations: stop optimizing after this no. of iterations
% * precision: the pixel precision
% 
% function [config, success] = requestConfiguration()
%

function [config, success] = requestConfiguration2(defFile2)
    success = 0;
    config = [];
    % Request input from a prompt.
    defFile = 'data\four400080_256\0.jpg';
    def = {defFile, '33', '33', '11', '11', '0.001', '20', '0.01'};
    
    imReference = char(def(1));
    
    % Create a subset size vector and check if the values are valid.
    subsetSize = struct('height', str2double(def(3)), ...
                        'width', str2double(def(2)));
                    
    % Fetch the grid spacing
    gridSpacing = struct('rows', str2double(def(5)), ... 
                         'cols', str2double(def(4)));
    if( isnan(gridSpacing.rows) || isnan(gridSpacing.cols) )
        errordlg('The input subset sizes are not valid integers.');
        return;
    end
    
    % Convergence criterion
    convergenceCriterion = str2double(def(6));
    if( isnan(convergenceCriterion) ) 
        errordlg('The convergence criterion is not a valid double.');
        return;
    end
    
    % Convergence criterion
    maxIterations = str2double(def(7));
    if( isnan(maxIterations) ) 
        errordlg('The number of max iterations is not a valid integer.');
        return;
    end
    
    % Pixel precision
    precision = str2double(def(8));
    if( isnan(precision) )
        errordlg('The precision is not a valid double.');
        return;
    end    
    
    imRefStruct = struct('file', imReference);
    imTargetStruct = struct('file', defFile2);
    
    % Set up the config struct and return with success!
    config = struct('imReference', imRefStruct, ...
                    'imTarget', imTargetStruct, ...
                    'subsetSize', subsetSize, ...
                    'gridSpacing', gridSpacing, ...
                    'convergenceCriterion', convergenceCriterion, ...
                    'maxIterations', maxIterations, ...
                    'precision', precision);
    success = 1;
    
end