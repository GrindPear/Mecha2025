function [enc1, enc2] = SerialParser(data, status)

HEADER  = uint8(170);
TAIL    = uint8(85);
BUF_LEN = int32(64);

enc1 = int32(0);
enc2 = int32(0);

persistent buf len last_enc1 last_enc2
if isempty(buf)
    buf       = zeros(1, BUF_LEN, 'uint8');
    len       = int32(0);
    last_enc1 = int32(0);
    last_enc2 = int32(0);
end

enc1 = last_enc1;
enc2 = last_enc2;

if status ~= 0
    return;
end

N = numel(data);
for k = 1:N
    b = data(k);
    if len < BUF_LEN
        len = len + 1;
        buf(len) = b;
    else
        buf(1:BUF_LEN-1) = buf(2:BUF_LEN);
        buf(BUF_LEN) = b;
        len = BUF_LEN;
    end
end

i = int32(1);

while i <= len - 9
    if (buf(i) == HEADER) && (buf(i+9) == TAIL)

        b0 = uint32(buf(i+1)) ...
           + bitshift(uint32(buf(i+2)), 8) ...
           + bitshift(uint32(buf(i+3)), 16) ...
           + bitshift(uint32(buf(i+4)), 24);
        v0 = typecast(b0, 'int32');
        enc1_tmp = v0(1);

        b1 = uint32(buf(i+5)) ...
           + bitshift(uint32(buf(i+6)), 8) ...
           + bitshift(uint32(buf(i+7)), 16) ...
           + bitshift(uint32(buf(i+8)), 24);
        v1 = typecast(b1, 'int32');
        enc2_tmp = v1(1);

        last_enc1 = enc1_tmp;
        last_enc2 = enc2_tmp;
        enc1 = last_enc1;
        enc2 = last_enc2;

        leftover = len - (i + 9);
        if leftover > 0
            buf(1:leftover) = buf((i+10):(i+9+leftover));
        end
        len = leftover;

        i = int32(1);
    else
        i = i + 1;
    end
end
