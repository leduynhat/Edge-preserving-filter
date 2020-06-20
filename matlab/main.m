clear;
clc;
close all;

%Test = [255, 255, 256; 1,1 ,1;1,1,1]

%Read input image inform unsign interger 8-bit
clean_im = imread('lena.tif');
clean_im = uint8(clean_im);

%H and W is the height and width of the input matrix
[H, W] = size(clean_im);

%create noise for image
noise = 10 * randn(H, W);
noise = uint8(noise);

%Add noise to the input image matrix 
noisy_im = clean_im + noise;

%Now let the noisy image matrix go through the edge filer
fil_im = uint8(edge_preserving_filter(noisy_im, 3, 8));

%Export data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%export input data for VLSI
fid = fopen('noisy_im.mem', 'wt');

for ii = 1: size(noisy_im, 1)       
    fprintf(fid, '%2x ', noisy_im(ii,:));
    fprintf(fid, '\n');
end
fclose(fid);

%export output data to compare
fid = fopen('fil_im.mem', 'wt');

for ii = 1: size(fil_im, 1)       
    fprintf(fid, '%2x ', fil_im(ii,:));
    fprintf(fid, '\n');
end
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%divide output into 4 parts
  fid = fopen('fil_im1.mem', 'wt');
  A1 = fil_im([1:128],[1:128]);
  for ii = 1: size(A1, 1)       
    fprintf(fid, '%2x ', A1(ii,:));
    fprintf(fid, '\n');
  end
  fclose(fid);
  
    fid = fopen('fil_im2.mem', 'wt');
  A1 = fil_im([1:128],[129:256]);
  for ii = 1: size(A1, 1)       
    fprintf(fid, '%2x ', A1(ii,:));
    fprintf(fid, '\n');
  end
  fclose(fid);
  
    fid = fopen('fil_im3.mem', 'wt');
  A1 = fil_im([129:256],[1:128]);
  for ii = 1: size(A1, 1)       
    fprintf(fid, '%2x ', A1(ii,:));
    fprintf(fid, '\n');
  end
  fclose(fid);
  
    fid = fopen('fil_im4.mem', 'wt');
  A1 = fil_im([129:256],[129:256]);
  for ii = 1: size(A1, 1)       
    fprintf(fid, '%2x ', A1(ii,:));
    fprintf(fid, '\n');
  end
  fclose(fid);
%Show out the results
figure;
subplot(1,4,1); imshow(uint8(clean_im)); title('Clean image');
subplot(1,4,2); imshow(uint8(noise)); title('Noise');
subplot(1,4,3); imshow(uint8(noisy_im)); title('Noisy image');
subplot(1,4,4); imshow(uint8(fil_im)); title('Filtered image');

%Output the result
imwrite(uint8(noise), 'noise.png');
imwrite(uint8(noisy_im), 'noisy_lena.png');
imwrite(uint8(fil_im), 'fil_lena.png');



