unit_8 = [ 256, 256, 256; 256, 256, 256; 256, 256, 256];
P = [91 98 98; 91 98 98; 108 111 97 ];
D = abs(P - P(2,2));

C = (255-D).^2;
C = floor(C ./ unit_8);

C = C.^2;
C = floor(C ./ unit_8);

C = C.^2;
C = floor(C ./ unit_8);

div_a = floor(sum(sum(C.*P)) / 16);
div_b = floor(sum(sum(C)) / 16);

div_a = bitshift(div_a, -1); % right shift 1 bit
div_b = bitshift(div_b, -1); % right shift 1 bit

Pixcel_out = floor(div_a / div_b);
    