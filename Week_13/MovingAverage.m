function out = MovingAverage(signal, N)

    signal = double(signal);

    persistent buf idx count sumval

    if isempty(buf)
        MAX_N = 200;
        buf    = zeros(MAX_N, 1, 'double');
        idx    = int32(1);
        count  = int32(0);
        sumval = 0.0;
    end

    MAX_N = length(buf);
    Ni = int32(N);
    if Ni < 1
        Ni = int32(1);
    elseif Ni > MAX_N
        Ni = int32(MAX_N);
    end

    old = buf(idx);
    sumval = sumval - old + signal;
    buf(idx) = signal;

    idx = idx + 1;
    if idx > Ni
        idx = int32(1);
    end

    if count < Ni
        count = count + 1;
    end

    out = sumval / double(count);
end
