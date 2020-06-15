clear;
clc;
close all;

clean_im = imread('lena.tif');
clean_im = double(clean_im);

[H, W] = size(clean_im);

noise = 10 * randn(H, W);
noise = double(noise);
m
noisy_im = clean_im + noise;
fil_im = edge_preserving_filter(noisy_im, 3);

figure;
subplot(1,4,1); imshow(uint8(clean_im)); title('Clean image');
subplot(1,4,2); imshow(uint8(noise)); title('Noise');
subplot(1,4,3); imshow(uint8(noisy_im)); title('Noisy image');
subplot(1,4,4); imshow(uint8(fil_im)); title('Filtered image');

imwrite(uint8(noise), 'noise.png');
imwrite(uint8(noisy_im), 'noisy_lena.png');
imwrite(uint8(fil_im), 'fil_lena.png');

function Y = edge_preserving_filter(X, ks)
  [H, W] = size(X);
  X = double(X);
  
  % Zero padding matrix
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
  Y = zeros(H, W);
  for i = 1:H
   for j = 1:W
     P = A(i:i+ks-1, j:j+ks-1);
     D = abs(P-P(pad+1, pad+1));
     C = (255.0-D);
     mul_1 = floor(C.^2/256);
     mul_2 = floor(mul_1.^2/256);
     mul_3 = floor(mul_2.^2/256);
     mul_4 = mul_3.*P;
     N = floor(sum(sum(mul_4))/16);
     M = floor(sum(sum(mul_3))/16);
     div_a = floor(N/2);
     div_b = floor(M/2);
     output = div_a/div_b;
     output = floor(output);
     A(i+pad,j+pad) = output;
     Y(i,j) = A(i+pad,j+pad);
   end
  end
end