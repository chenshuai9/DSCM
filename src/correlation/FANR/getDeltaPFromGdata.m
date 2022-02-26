%
% J.T. Ouwerling <j.t.ouwerling@student.rug.nl>, University of Groningen
% Date created: June 10, 2015
%
% This function calculates the delta p step in the IC GN optimization of the 
% p vector. The theory behind it can be found in the report. 
% 
% Input: 
%
% * rowInit: the row of the gridpoint
% * colInit: the column of the gridpoint
% * rows: a discrete set of row values. Calculated based on subsetsize and precision.
% * cols: "..." of column values "..."
% * config: the config structure.
% * p: the current best p vector
% * fData: a struct with reference image values, mean and delta
% * hessian: the pre-computed hessian
% 
% Output:
% 
% * dp: the delta p vector which need to be inverted and applied to p.
% 
% function [dp] = getDeltaP(rowInit, colInit, rows, cols, config, p, fData, hessian)
% 

function [outdp] = getDeltaPFromGdata(rowInit, colInit, rows, cols, config, fData, gData)
    beishu = 1/config.precision;
    cfTar = config.imTarget.interpolation;
    cfRef = config.imReference.interpolation;
    maxR = size(cfTar.a00,1);
    maxC = size(cfTar.a00,2);
    
    dsdp = zeros(6,1);
    
    dssdpp = zeros(6,6);
    fsquare = 0;gsquare = 0;fg = 0;
    for row = 1:size(rows,2)
        for col = 1:size(cols, 2)
            fsquare = fsquare+fData.values(row, col)*fData.values(row, col);
            gsquare = gsquare+gData.values(row, col)*gData.values(row, col);
            fg = fg+fData.values(row, col)*gData.values(row, col);
        end
    end
    %º∆À„g*dg/dp(i),f*dg/dp(i)
    g_x = gData.dx;
    g_y = gData.dy;
    g_xx = gData.dxx;
    g_yy = gData.dyy;
    g_xy = gData.dxy;
    gdgdp = zeros(6,1);
    fdgdp = zeros(6,1);
    dgdgdpdp = zeros(6,6);
    gdggdpp = zeros(6,6);
    fdggdpp = zeros(6,6);
    for row = 1:size(rows,2)
        for col = 1:size(cols, 2)  
                deltax = (row-beishu*(config.subsetSize.height - 1)/2-1)/beishu;
                deltay = (col-beishu*(config.subsetSize.height - 1)/2-1)/beishu;
                
                dxdp = [1;deltax;deltay;0;0;0];
                dydp = [0;0;0;1;deltax;deltay];
                %dgdp£∫6*1
                gdgdp = gdgdp+[g_x(row, col)*gData.values(row, col);deltax*g_x(row, col)*gData.values(row, col);deltay*g_x(row, col)*gData.values(row, col);g_y(row, col)*gData.values(row, col);deltax*g_y(row, col)*gData.values(row, col);deltay*g_y(row, col)*gData.values(row, col)];
                fdgdp = fdgdp+[g_x(row, col)*fData.values(row, col);deltax*g_x(row, col)*fData.values(row, col);deltay*g_x(row, col)*fData.values(row, col);g_y(row, col)*fData.values(row, col);deltax*g_y(row, col)*fData.values(row, col);deltay*g_y(row, col)*fData.values(row, col)];
                %%d2g/dp2:6*6æÿ’Û
                %for i=1:1:6
                %    for j=1:1:6
                %        dggdpp(i,j) = g_xx*dxdp(i,1)*dxdp(j,1)+g_xy*(dxdp(i,1)*dydp(j,1)+dxdp(j,1)*dxdp(i,1))+g_yy*dydp(i,1)*dydp(j,1);
                %    end
                %end
                
              
                for i=1:1:6
                    for j=1:1:6
                        %dg/dp *dg/dp
                        dgdgdpdp(i,j) =dgdgdpdp(i,j)+ (g_x(row,col)*dxdp(i,1)+g_y(row,col)*dydp(i,1))*(g_x(row,col)*dxdp(j,1)+g_y(row,col)*dydp(j,1));
                        gdggdpp(i,j) =gdggdpp(i,j)+ gData.values(row, col)*(g_xx(row,col)*dxdp(i,1)*dxdp(j,1)+g_xy(row,col)*(dxdp(i,1)*dydp(j,1)+dxdp(j,1)*dxdp(i,1))+g_yy(row,col)*dydp(i,1)*dydp(j,1));
                        fdggdpp(i,j) =fdggdpp(i,j)+ fData.values(row, col)*(g_xx(row,col)*dxdp(i,1)*dxdp(j,1)+g_xy(row,col)*(dxdp(i,1)*dydp(j,1)+dxdp(j,1)*dxdp(i,1))+g_yy(row,col)*dydp(i,1)*dydp(j,1));                   
                    end
                end
                
        end
    end
    %º∆À„ds/dp
    dsdp = [(gdgdp(1,1)*fsquare*fg-fdgdp(1,1)*fsquare*gsquare)/(fsquare*gsquare)^(3/2);...
            (gdgdp(2,1)*fsquare*fg-fdgdp(2,1)*fsquare*gsquare)/(fsquare*gsquare)^(3/2);...
            (gdgdp(3,1)*fsquare*fg-fdgdp(3,1)*fsquare*gsquare)/(fsquare*gsquare)^(3/2);...
            (gdgdp(4,1)*fsquare*fg-fdgdp(4,1)*fsquare*gsquare)/(fsquare*gsquare)^(3/2);...
            (gdgdp(5,1)*fsquare*fg-fdgdp(5,1)*fsquare*gsquare)/(fsquare*gsquare)^(3/2);...
            (gdgdp(6,1)*fsquare*fg-fdgdp(6,1)*fsquare*gsquare)/(fsquare*gsquare)^(3/2)];
     %º∆À„dss/dpipj  
     dssdpp = zeros(6,6);
     for i=1:1:6
         for j=1:1:6
            dssdpp(i,j) = fsquare^(-1/2)*gsquare^(-3/2)*((dgdgdpdp(i,j)+gdggdpp(i,j))*fg+2*gdgdp(i,1)*gdgdp(j,1))-3*fsquare^(-1/2)*gsquare^(-5/2)*(gdgdp(i,1)*gdgdp(j,1))*fg-fsquare^(-1/2)*gsquare^(-1/2)*fdggdpp(i,j);
         end
     end
     
     dp = -inv(dssdpp)*dsdp;
     
     outdp = struct('u',dp(1,1),'u_x',dp(2,1),'u_y',dp(3,1),'v',dp(4,1),'v_x',dp(5,1),'v_y',dp(6,1));
end