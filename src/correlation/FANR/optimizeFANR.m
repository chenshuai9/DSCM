

function [result, p, c, iterations, convHist, time_icgn, time_cc] = optimizeFANR(initialp, row, col, config)

    rowNumber = find(config.gridpoints.rows==row);
    colNumber = find(config.gridpoints.cols==col);

    %
    % Calculate the values of the reference image and the hessian
    %
    wb = waitbar(0, sprintf('Setting up IC-GN for gridpoint (%d, %d)', rowNumber, colNumber));
    [rows, cols] = getRowsCols(row, col, config);
    fData = getReferenceValues(rows, cols, config);
    gData = getTargetValues(rows, cols, config);

    % dp = [u u_x u_y v v_x v_y]
    iterations = 0;
    overflown = 0;
    pisnan = 0;
    p = initialp;
    convHist = zeros(config.maxIterations, 1);
    time_cc = NaN;
    time_icgn = NaN;
    set( get(findobj(wb,'type','axes'),'title'), 'string', sprintf('Calculating p for gridpoint (%d, %d)', rowNumber, colNumber));
    waitbar(1/3, wb);
    start_icgn = toc;
    %initial dp
    dp = getDeltaPFromGdata(row, col, rows, cols, config, fData, gData);
    while(iterations < config.maxIterations && criterionSatisfied(dp) == false)
        
        p = getUpdatedPvector(p, dp);
        if(p.u_x~=0&&p.v_x~=0&&p.u_y~=0&&p.v_y~=0)
            dp = getDeltaPFANR(row, col, rows, cols, config, p ,fData, gData);
        else dp =getDeltaPFromGdata(row, col, rows, cols, config, fData, gData);
        end
        
        convHist(iterations+1) = currentConvergence(dp);
        iterations = iterations + 1;
        %percentage = 1/3+min(2/3,1/(log10(convHist(iterations+1)/config.convergenceCriterion)+1));
        %waitbar(percentage, wb);  
    end
    time_icgn = toc - start_icgn;
    close(wb);
    
    % return the correct status & values
    c = Inf;
    pInf = createPvector(Inf, Inf, Inf, Inf, Inf, Inf);
    
    satisfied = criterionSatisfied(dp);
    if(satisfied == false)
        result = DicConstants.RESULT_NO_CONVERGENCE;
        %p = pInf;
        return;
    end
    result = DicConstants.RESULT_OK;
    start_cc = toc;
    c = calculateZNSSD(row, col, config, p);
    time_cc = toc - start_cc;

    %
    % This function sets satisfied to true if delta p has converged,
    % otherwise satisfied is false.
    %
    function satisfied = criterionSatisfied(dp)
       satisfied = false; 
       incr = dp.u^2 + dp.v^2;
       incr = incr + (((config.subsetSize.width - 1) / 2) * dp.u_x)^2;
       incr = incr + (((config.subsetSize.width - 1) / 2) * dp.v_x)^2;
       incr = incr + (((config.subsetSize.height - 1) / 2) * dp.u_y)^2;
       incr = incr + (((config.subsetSize.height - 1) / 2) * dp.v_y)^2;
       incr = sqrt(incr);
       if(incr < config.convergenceCriterion)
           satisfied = true;
       end
    end

    %
    % Current convergence function.
    %
    function convergence = currentConvergence(dp)   %迭代的dp模长
       convergence = dp.u^2 + dp.v^2;
       convergence = convergence + (((config.subsetSize.width - 1) / 2) * dp.u_x)^2;
       convergence = convergence + (((config.subsetSize.width - 1) / 2) * dp.v_x)^2;
       convergence = convergence + (((config.subsetSize.height - 1) / 2) * dp.u_y)^2;
       convergence = convergence + (((config.subsetSize.height - 1) / 2) * dp.v_y)^2;
       convergence = sqrt(convergence);
    end
   
    %
    % This function merges the newly found delta p with the current known
    % p vector according to Wnew = Wold * inv(Wdp);
    %
    function newPvector = getUpdatedPvector(p, dp)
        newPvector=struct('u',0,'u_x',0,'u_y',0,'v',0,'v_x',0,'v_y',0);
        newPvector.u = p.u+dp.u;
        newPvector.v = p.v+dp.v;
        newPvector.u_x = p.u_x+dp.u_x;
        newPvector.u_y = p.u_y+dp.u_y;
        newPvector.v_x = p.v_x+dp.v_x;
        newPvector.v_y = p.v_y+dp.v_y;
    end

end
