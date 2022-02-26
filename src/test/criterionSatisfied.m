   
    function satisfied = criterionSatisfied(dp,config2)
       satisfied = false; 
       incr = dp.u^2 + dp.v^2;
       incr = incr + (((config2.subsetSize.width - 1) / 2) * dp.u_x)^2;
       incr = incr + (((config2.subsetSize.width - 1) / 2) * dp.v_x)^2;
       incr = incr + (((config2.subsetSize.height - 1) / 2) * dp.u_y)^2;
       incr = incr + (((config2.subsetSize.height - 1) / 2) * dp.v_y)^2;
       incr = sqrt(incr);
       if(incr < config2.convergenceCriterion)
           satisfied = true;
       end
    end