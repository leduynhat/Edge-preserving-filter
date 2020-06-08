function Y = edge_preserving_filter(X, ks, p)
  [H, W] = size(X);
  X = uint8(X);
  
  %unit_8 is a 3x3 matric which is used to get rid of 8 unnecessary right
  %bit of 16 when multiple operation occer
  unit_8 = [ 256, 256, 256; 256, 256, 256; 256, 256, 256]
  
  % Zero padding matrix
  % ph?n n�y padding zero cho ma tr?n X[256,256] th�nh A[258,258]
  pad = floor((ks+1)/2) - 1;
  A = zeros(H + 2*pad, W + 2*pad);
  for i = 1 : (H+2*pad)
    for j = 1 : (W+2*pad)
      if (i>=1+pad) && (i<=H+pad) && (j>=1+pad) && (j<=W+pad)
        A(i,j) = X(i - pad, j - pad);
      elseif (i<1+pad) && (j<1+pad)
        A(i,j) = X(1,1);
      elseif (i>H+pad) && (j<1+pad)
        A(i,j) = X(H,1);
      elseif (i<1+pad) && (j>W+pad)
        A(i,j) = X(1,W);
      elseif (i>H+pad) && (j>W+pad)
        A(i,j) = X(H,W);
      elseif (i<1+pad) && (j>=1+pad) && (j<=W+pad)
        A(i,j) = X(1,j-pad);
      elseif (i>H+pad) && (j>=1+pad) && (j<=W+pad)
        A(i,j) = X(H,j-pad);
      elseif (i>=1+pad) && (i<=H+pad) && (j<1+pad)
        A(i,j) = X(i-pad,1);
      elseif (i>=1+pad) && (i<=H+pad) && (j>W+pad)
        A(i,j) = X(i-pad,W);
      end
    end
  end
  
  % Convolution
  % qu�t t?ng � m?t trong ?nh g?c
  Y = zeros(H, W); % ?nh out put
  for i = 1:H
   for j = 1:W
     P = A(i:i+ks-1, j:j+ks-1); % P l� ma tr?n 3x3 v?i P5 l� Y(i,j)
     D = abs(P-P(pad+1, pad+1)); % D l� ma tr?n m� c�c ?i?m D(i,j) = P(i,j) - P(2,2) 
     %C = (255-D).^p;  % K?t qu? ???c m? 8 l�n (do p = 8), 
                      %nh?ng do trong code verilog ta s? d?ng l�m tr�n n�n
                      %s? kh�ng l�m nh? n�y
               
    % A(i+pad,j+pad) = uint8(sum(sum(C.*P)) / sum(sum(C)));
    % Y(i,j) = A(i+pad,j+pad);
    % Ta l�m nh? sau, b�nh ph??ng sau ?� l�m tr�n 
    
    C = (255-D).^2;
    C = floor(C ./ unit_8);
    
    C = C.^2;
    C = floor(C ./ unit_8);
    
    C = C.^2;
    C = floor(C ./ unit_8);
        
    Y(i,j) = floor(sum(sum(C.*P)) / sum(sum(C)));
   end
  end
end