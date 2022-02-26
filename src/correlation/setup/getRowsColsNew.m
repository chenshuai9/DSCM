function [rows, cols] = getRowsColsNew(rowInit, colInit, config)
    rowStart = rowInit - (config.subsetSize.height + 1)/2;      %12-£¨21+1£©/2
    rowEnd = rowInit + (config.subsetSize.height - 1)/2-2;
    colStart = colInit - (config.subsetSize.width + 1)/2;
    colEnd = colInit + (config.subsetSize.width - 1)/2-2;
    rows = rowStart:config.precision:rowEnd;
    cols = colStart:config.precision:colEnd;
end