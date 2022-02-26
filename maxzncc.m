function [u,v] = maxzncc(i,j,config,ref,tar)
    gridpoints_x = config.gridpoints.rows(i);   %gridpoints_x = config.gridpoints.rows(i)
    gridpoints_y = config.gridpoints.cols(j);   %gridpoints_x = config.gridpoints.rows(j)
    subsize = 32;
    tartemp = imcrop(tar,[gridpoints_y gridpoints_x subsize subsize]);
    try
        r=normxcorr2(tartemp,ref);
       
    [x,y]=find(r==max(max(r)));
    if(size(x,1)>1)
        x = gridpoints_x+subsize;y = gridpoints_y+subsize;
        u=0;v=0;
    else
        xx = [gridpoints_x+subsize/2-1 gridpoints_x+subsize/2-1 gridpoints_x+subsize/2-1 gridpoints_x+subsize/2 gridpoints_x+subsize/2 gridpoints_x+subsize/2 gridpoints_x+subsize/2+1 gridpoints_x+subsize/2+1 gridpoints_x+subsize/2+1];
        yy = [gridpoints_y+subsize/2-1 gridpoints_y+subsize/2 gridpoints_y+subsize/2+1 gridpoints_y+subsize/2-1 gridpoints_y+subsize/2 gridpoints_y+subsize/2+1 gridpoints_y+subsize/2-1 gridpoints_y+subsize/2 gridpoints_y+subsize/2+1];
        zz = [r(x-1,y-1) r(x-1,y) r(x-1,y+1) r(x,y-1) r(x,y) r(x,y+1) r(x+1,y-1) r(x+1,y) r(x+1,y+1)];
        [xData, yData, zData] = prepareSurfaceData( xx, yy, zz );
        ft = fittype( 'poly22' );
        [fitresult] = fit( [xData, yData], zData, ft );
        a1 = fitresult.p10;a2 = fitresult.p01;a3 = fitresult.p20;a4 = fitresult.p11;a5 = fitresult.p02;
        delta = 4*a3*a5-a4*a4;
        if(delta > 0&&a3<0)
            u = (2*a1*a5-a2*a4)/(-delta)-gridpoints_x-subsize/2;
            v = (2*a2*a3-a1*a4)/(-delta)-gridpoints_y-subsize/2;
        else 
            u=0;
            v=0;
        end
    end
    catch ME
        u=0;
        v=0;
        
    end
    
    
end
