function maxcorr = maxcorr(x)
    global r;
    x(1) = floor(x(1));
    x(2) = floor(x(2));
    y = r(x(1),x(2));
    maxcorr = y;
end