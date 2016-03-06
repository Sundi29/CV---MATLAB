%Inputting Rooster and Boxes image and converting to fray and double scale
Ia = imread('file name');
Ib = imread('file name');
Iag = im2double(rgb2gray(Ia));
Ibg = im2double(Ib);
figure(1), title('Gray Scale');
figure(1), subplot(2,2,1), imagesc(Ia); colorbar
figure(1), subplot(2,2,2), imagesc(Iag); colorbar
figure(1), subplot(2,2,3), imagesc(Ib); colorbar
figure(1), subplot(2,2,4), imagesc(Ibg); colorbar
% 3.1 Box Maskes - Average mask and convolution
avgmask1 = fspecial('average', 5);
avgmask2 = fspecial('average', 25);
avgimagea1 = conv2(Iag, avgmask1, 'same');
avgimageb1 = conv2(Ibg, avgmask1, 'same');
avgimagea2 = conv2(Iag, avgmask2, 'same');
avgimageb2 = conv2(Ibg, avgmask2, 'same');
figure(2), title('Average Mask');
figure(2), subplot(2,2,1), imagesc(avgimagea1); colormap('gray'); title('Conv with Avg mask 1'); colorbar
figure(2), subplot(2,2,2), imagesc(avgimageb1); colormap('gray'); title('Conv with Avg mask 1'); colorbar
figure(2), subplot(2,2,3), imagesc(avgimagea2); colormap('gray'); title('Conv with Avg mask 2'); colorbar
figure(2), subplot(2,2,4), imagesc(avgimageb2); colormap('gray'); title('Conv with Avg mask 2'); colorbar
% 3.2 Gaussian Mask
% Gaussian 2D Mask and convolution with rooster image
gausmask2 = fspecial('gaussian', 60, 10);
gausmask1 = fspecial('gaussian', 11, 1.5);
gausimagea1 = conv2(Iag, gausmask1, 'same');
gausimagea2 = conv2(Iag, gausmask2, 'same');
gausimageb1 = conv2(Ibg, gausmask1, 'same');
gausimageb2 = conv2(Ibg, gausmask2, 'same');
tic;gausimagea2 = conv2(Iag, gausmask2, 'same');time1=toc;
figure(3), title('Guassian 2-D Mask');
figure(3), subplot(2,2,1), imagesc(gausimagea1); colormap('gray'); title('Conv with Gauss Mask 1'); colorbar
figure(3), subplot(2,2,2), imagesc(gausimagea2); colormap('gray'); title('Conv with Gauss Mask 2'); colorbar
figure(3), subplot(2,2,3), imagesc(gausimageb1); colormap('gray'); title('Conv with Gauss Mask 1'); colorbar
figure(3), subplot(2,2,4), imagesc(gausimageb2); colormap('gray'); title('Conv with Gauss Mask 2'); colorbar
%Gaussain 1D Mask and convolution and finding time taken using tic and toc
gausmask1D = fspecial('gaussian', [1 60], 10);
gausmask1DT = transpose(gausmask1D);
gausmaskconv1D = conv2(gausmask1D, gausmask1DT, 'full');
figure(4), subplot(1,2,1), mesh(gausmaskconv1D); colorbar; title('1-D Gaussian Mask Mesh');
figure(4), subplot(1,2,2), mesh(gausmask2); colorbar; title('2-D Gaussian Mask Mesh');
tic;gaus1Dimage = conv2(Iag, gausmask1D, 'same');
gaus1DTimage = conv2(gaus1Dimage, gausmask1DT, 'same');time2=toc;
figure(5), subplot(2,2,1), imagesc(gausimagea2); colorbar; title('2-D Convolution');
figure(5), subplot(2,2,2), imagesc(gaus1DTimage); colorbar; title('1-D Convolution');
time2
time1
% 4.Difference Masks
% 4.1 Difference Masks 1-D : Insight on effect of difference masks on simple 1D signal
y = sin([0:0.01:2*pi]); figure(6), subplot(3,1,1), plot(y); title('sinewave');
yd1 = conv2(y, [-1,1], 'valid'); 
figure(6), subplot(3,1,2), plot(yd1); title('convolving sinewave with a 1st Derivative mask');
yd2 = conv2(y, [-1,2,-1],'valid');
figure(6), subplot(3,1,3), plot(yd2); title('convoling sinewave with a 2nd Derviative mask');
% 4.2 Difference Masks 2-D
lapmask1 = fspecial('laplacian', 0.5).*(-3/8);
lapmask2 = fspecial('laplacian', 0.5).*(-3);
lapimageb1 = conv2(Ibg, lapmask1, 'valid');
lapimageb2 = conv2(Ibg, lapmask2, 'valid');
figure(7), subplot(1,2,1), imagesc(lapimageb1); colormap('gray'); colorbar; title('Laplacian mask 1');
figure(7), subplot(1,2,2), imagesc(lapimageb2); colormap('gray'); colorbar; title('Laplacian mask 2');
% 4.3 Other Difference Masks
%sobel mask and convolution
sobelmask1 = fspecial('sobel');
sobelmask2 = transpose(sobelmask1);
sobelimageb1 = conv2(Ibg, sobelmask1, 'valid');
sobelimageb2 = conv2(Ibg, sobelmask2, 'valid');
figure(8), subplot(2,2,1), imagesc(sobelimageb1); colormap('jet'); colorbar; title('sobel mask');
figure(8), subplot(2,2,2), imagesc(sobelimageb2); colormap('jet'); colorbar; title('transpose sobel mask');
%prewitt mask and convolution
prewittmask1 = fspecial('prewitt');
prewittmask2 = transpose(prewittmask1);
prewittimageb1 = conv2(Ibg, prewittmask1, 'valid');
prewittimageb2 = conv2(Ibg, prewittmask2, 'valid');
figure(8), subplot(2,2,3), imagesc(prewittimageb1);colormap('jet'); colorbar; title('prewitt mask');
figure(8), subplot(2,2,4), imagesc(prewittimageb2);colormap('jet'); colorbar; title('transpose prewitt mask');
% 5 Edge Detection
% 5.1 Gaussian Derivative Masks
gausmask3 = fspecial('gaussian', 38, 5);
gausdermaskx = conv2(gausmask3, [-1, 1], 'same');
gausdermasky = conv2(gausmask3, transpose([-1, 1]), 'same');
% Gaussian Mask SD = 5
figure(9), subplot(2,2,1), mesh(gausdermaskx); title('mesh plot of gaussian mask x axis');
figure(9), subplot(2,2,2), mesh(gausdermasky); title('mesh plot of gaussian mask y axis');
gausimagebx = conv2(Ibg, gausdermaskx, 'same');
gausimageby = conv2(Ibg, gausdermasky, 'same');
figure(9), subplot(2,2,3), imagesc(gausimagebx); colormap('jet'); colorbar; title('Image using Gauss mask x axis');
figure(9), subplot(2,2,4), imagesc(gausimageby); colormap('jet'); colorbar; title('Image using Gauss mask y axis');
%Gaussian Mask SD = 1.5
gausder15maskx = conv2(gausmask1, [-1,1], 'same');
gausder15masky = conv2(gausmask1, transpose([-1,1]), 'same');
figure(10), subplot(2,2,1), mesh(gausder15maskx); title('mesh plot of gaussian mask x axis');
figure(10), subplot(2,2,2), mesh(gausder15masky); title('mesh plot of gaussian mask y axis');
Idgx = conv2(Ibg, gausder15maskx, 'same');
Idgy = conv2(Ibg, gausder15masky, 'same');
figure(10), subplot(2,2,3), imagesc(Idgx); colormap('jet'); colorbar; title('Image using Gauss mask x axis');
figure(10), subplot(2,2,4), imagesc(Idgy); colormap('jet'); colorbar; title('Image using Gauss mask y axis');
Ibdg = sqrt(Idgx.^2 + Idgy.^2);
figure(11), subplot(1,2,1), imagesc(Ibdg); colormap('gray'); colorbar; title('Boxes Image'); 
Iadgx = conv2(Iag, gausder15maskx, 'same');
Iadgy = conv2(Iag, gausder15masky, 'same');
Iadg = sqrt(Iadgx.^2 + Iadgy.^2);
figure(11), subplot(1,2,2), imagesc(Iadg); colormap('gray'); colorbar; title('Rooster Image');
% 5.2 Laplacian of Gaussian Mask
lapmask3 = fspecial('laplacian', 0.5)*(-1);
gausmasklog = fspecial('gaussian', 38, 5);
logmask1 = conv2(gausmask1, lapmask3, 'valid');
figure(13), subplot(2,2,1), mesh(logmask1); title('mesh plot using Gaussian mask SD = 1.5');
logimageb1 = conv2(Ibg, logmask1, 'valid');
figure(12), subplot(2,2,3), imagesc(logimageb1); colormap('jet'); colorbar; title('Boxes image from log mask 1');
log = conv2(gausmasklog, lapmask3, 'valid');
figure(13), subplot(2,2,2), mesh(log); title('mesh plot using Gaussian mask SD = 5');
logimageb2 = conv2(Ibg, log, 'valid');
figure(12), subplot(2,2,4), imagesc(logimageb2); colormap('jet'); colorbar; title('Boxes image from log mask 2');
logimagea1 = conv2(Iag, logmask1, 'valid');
figure(13), subplot(2,2,3), imagesc(logimagea1); colormap('jet'), colorbar; title('Rooster image from log mask 1');
logimagea2 = conv2(Iag, log, 'valid');
figure(13), subplot(2,2,4), imagesc(logimagea2); colormap('jet'), colorbar; title('Rooster image from log mask 2s');
% 5.3 Difference of Gaussian Mask
gausmask4 = fspecial('gaussian', 36, 4);
gausmask5 = fspecial('gaussian', 36, 6);
dog = gausmask5 - gausmask4;
figure(14), subplot(2, 2, 1), mesh(gausmask4); 
figure(14), subplot(2, 2, 2), mesh(gausmask5);
figure(14), subplot(2, 2, 3), mesh(dog);
dog = dog./max(max(dog));
log = log./max(max(log));
sqrt(sum(sum((dog-log).^2)))
k = 0;
for I = 4: 0.01:6
    for J = 5.5: -0.01: 5
        if(I ~= J)
            gausmask6 = fspecial('gaussian', 36, I);
            gausmask7 = fspecial('gaussian', 36, J);
            dog = gausmask7 - gausmask6;
            dog = dog./max(max(dog));
            log = log./max(max(log));
            S = sqrt(sum(sum((dog-log).^2)));
            if(S<0.3)
                if(k == 0)
                    minsq=S;
                    s1 = I;
                    s2 = J;
                    k = k + 1;
                end
                if(S<minsq)
                    minsq=S;
                    s1 = I;
                    s2 = J;
                end
            end
        end
    end
end
minsq, s1, s2
% 6 Multi-Scale Representation
% Gaussian Image Pyramid
gausmask8 = fspecial('gaussian', [1 32], 3);
gausconvl = conv2(gausmask8, gausmask8, 'same');
gausmask9 = fspecial('gaussian', [1 32], sqrt(2)*3);
figure(15), plot(gausconvl, 'color', 'r'); title('Convolution of Gaussian mask with itself'); hold on;
figure(15), plot(gausmask9, 'color', 'b'); title('Single Gaussian mask');
gauspyramidmask1 = fspecial('gaussian', 6, 1);
gauspyramidmask2 = fspecial('gaussian', 6, sqrt(2));
gauspyramidmask3 = fspecial('gaussian', 6, 1);
gauspyramidmask4 = fspecial('gaussian', 6, sqrt(2));
Ia12 = imresize(conv2(Iag, gauspyramidmask1, 'same'), 0.5, 'nearest');
Ia13 = imresize(conv2(Iag, gauspyramidmask2, 'same'), 0.5, 'nearest');
Ia14 = imresize(conv2(Iag, gauspyramidmask3, 'same'), 0.5*0.5, 'nearest');
Ia15 = imresize(conv2(Iag, gauspyramidmask4, 'same'), 0.5*0.5*0.5*0.5, 'nearest');
figure(17), title('Gaussian Image Pyramid'); 
figure(17), subplot(2,2,1), imagesc(Ia12); colorbar;title('level-1'); %axis([0 160 0 160]);
figure(17), subplot(2,2,2), imagesc(Ia13); colorbar;title('level-2'); %axis([0 160 0 160]);
figure(17), subplot(2,2,3), imagesc(Ia14); colorbar;title('level-3'); %axis([0 160 0 160]);
figure(17), subplot(2,2,4), imagesc(Ia15); colorbar;title('level-4'); %axis([0 160 0 160]);
Iagaus22 = imresize(conv2(Iag, gauspyramidmask1, 'same'), 0.5, 'nearest');
Iagaus23 = imresize(conv2(Iagaus22, gauspyramidmask1, 'same'), 0.5, 'nearest');
Iagaus24 = imresize(conv2(Iagaus23, gauspyramidmask1, 'same'), 0.5, 'nearest');
Iagaus25 = imresize(conv2(Iagaus24, gauspyramidmask1, 'same'), 0.5, 'nearest');
figure(18), title('Gaussian Image Pyramid');
figure(18), subplot(2,2,1), imshow(Iagaus22); colorbar;title('level-1'); %axis([0 160 0 160]);
figure(18), subplot(2,2,2), imshow(Iagaus23); colorbar;title('level-2'); %axis([0 160 0 160]);
figure(18), subplot(2,2,3), imshow(Iagaus24); colorbar;title('level-3'); %axis([0 160 0 160]);
figure(18), subplot(2,2,4), imshow(Iagaus25); colorbar;title('level-4'); %axis([0 160 0 160]);


%Laplacian Image Pyramid
Ilap22 = Iagaus22 - conv2(Iagaus22, gauspyramidmask1, 'same');
Ilap23 = Iagaus23 - conv2(Iagaus23, gauspyramidmask1, 'same');
Ilap24 = Iagaus24 - conv2(Iagaus24, gauspyramidmask1, 'same');
Ilap25 = Iagaus25 - conv2(Iagaus25, gauspyramidmask1, 'same');
figure(19), subplot(2,2,1), imagesc(Ilap22); colormap('gray'); colorbar; title('level-1'); %axis([0 160 0 160]);
figure(19), subplot(2,2,2), imagesc(Ilap23); colormap('gray'); colorbar; title('level-2'); %axis([0 160 0 160]);
figure(19), subplot(2,2,3), imagesc(Ilap24); colormap('gray'); colorbar; title('level-3'); %axis([0 160 0 160]);
figure(19), subplot(2,2,4), imagesc(Ilap25); colormap('gray'); colorbar; title('level-4'); %axis([0 160 0 160]);

%Edge detector using canny detector (edge detector function)
image1 = imread('file name');
image2 = imread('file name');
image3 = imread('file name');

outimage1 = edge(image1, 'canny', 0.13);
figure(20), subplot(2,2,1), imshow(outimage1); colorbar

outimage2 = edge(image2, 'canny', 0.13);
figure(20), subplot(2,2,2), imshow(outimage2); colorbar


outimage3 = edge(image3, 'canny', 0.13);
figure(20), subplot(2,2,3), imshow(outimage3); colorbar

 

