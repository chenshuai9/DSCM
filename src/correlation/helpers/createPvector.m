%
% J.T. Ouwerling <j.t.ouwerling@student.rug.nl>, University of Groningen
% Date created: June 3, 2015
%
% create the "infamous" P vector which describes a displ. in a subset.
%
% function [p] = createPvector(u, v, u_x, u_y, v_x, v_y)
%

function [p] = createPvector(u, v, u_x, u_y, v_x, v_y)

    p = struct( ...
        'u', u, ...
        'v', v, ...
        'u_x', u_x, ...
        'u_y', u_y, ...
        'v_x', v_x, ...
        'v_y', v_y  ...
    );

end