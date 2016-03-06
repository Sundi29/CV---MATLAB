close all
clear
rooster = imread('file name');
woods = imread('file name');
roosterd = im2double(rooster);
woodsd = im2double(woods);
roosterg = im2double(rgb2gray(rooster));
woodsg = im2double(woods);

%2.0.1 Redundancy in Natural Images
roosterpart = [];
woodspart = [];
coeff = [];
cpixel = [0:30];

roosterpart(:,:,1) = roosterg(1:30,1:30);
roosterpart(:,:,2) = roosterpart(:,:,1);
woodspart(:,:,1) = woodsg(1:30,1:30);
woodspart(:,:,2) = woodspart(:,:,1);

for i = 1:1:6
    coeff(i, :) = [0:30];
end

for coeffpixel = 0:1:30
    for I = 1:1:30
        for J = 1:1:30
            roosterpart(I, J, 2) = roosterg(I, J + coeffpixel);
            %if(I<=75) && (J<=75)
            woodspart(I, J, 2) = woodsg(I, J + coeffpixel);
            %end
        end
    end
    coeff(1, coeffpixel + 1) = corr2(roosterpart(:,:,1), roosterpart(:,:,2));
    coeff(2, coeffpixel + 1) = corr2(woodspart(:,:,1), woodspart(:,:,2));
end

figure(1), subplot(1,1,1), plot(cpixel, coeff(1, :), 'r', cpixel, coeff(2, :), 'b'); xlabel('shift'); ylabel('correlation'); title('correlation between image shifted by pixels: red - rooster, blue - woods');


%3.1.1 Redundancy Reduction

%Using gaussian 6 and 2
gaus1 = fspecial('gaussian', 36, 6);
gaus2 = fspecial('gaussian', 36, 2);
dog1 = gaus2 - gaus1;
roostergredunimage(:,:,1) = conv2(roosterg, dog1, 'same');
woodsgredunimage(:,:,1) = conv2(woodsg, dog1, 'same');

%Using gaussian 4 and 0.5
gaus3 = fspecial('gaussian', 24, 4);
gaus4 = fspecial('gaussian', 24, 0.5);
dog2 = gaus4 - gaus3;
roostergredunimage(:,:,2) = conv2(roosterg, dog2, 'same');
woodsgredunimage(:,:,2) = conv2(woodsg, dog2, 'same');

%Finding coeffecient
roosterpart(:,:,3) = roostergredunimage(1:30,1:30,1);
roosterpart(:,:,4) = roosterpart(:,:,3);
woodspart(:,:,3) = woodsgredunimage(1:30, 1:30, 1);
woodspart(:,:,4) = woodspart(:,:,3);

roosterpart(:,:,5) = roostergredunimage(1:30,1:30,2);
roosterpart(:,:,6) = roosterpart(:,:,5);
woodspart(:,:,5) = woodsgredunimage(1:30,1:30,2);
woodspart(:,:,6) = woodspart(:,:,5);

for coeffpixel = 0:1:30
    for I = 1:1:30
        for J = 1:1:30
            roosterpart(I, J, 6) = roostergredunimage(I, J + coeffpixel, 2);
            roosterpart(I, J, 4) = roostergredunimage(I, J + coeffpixel, 1);
            %if(I<=75) && (J<=75)
            woodspart(I, J, 6) = woodsgredunimage(I, J + coeffpixel, 2);
            woodspart(I, J, 4) = woodsgredunimage(I, J + coeffpixel, 1);
            %end
        end
    end
    coeff(3, coeffpixel + 1) = corr2(roosterpart(:,:,3), roosterpart(:,:,4));
    coeff(4, coeffpixel + 1) = corr2(woodspart(:,:,3), woodspart(:,:,4));
    coeff(5, coeffpixel + 1) = corr2(roosterpart(:,:,5), roosterpart(:,:,6));
    coeff(6, coeffpixel + 1) = corr2(woodspart(:,:,5), woodspart(:,:,6));
end

figure(2), subplot(2,1,1), plot(cpixel, coeff(3, :), 'b',cpixel, coeff(4, :), 'r'); xlabel('shift'); ylabel('correlation'); title('graph coeff rooster vs woods - gaussian 6,2');
figure(2), subplot(2,1,2), plot(cpixel, coeff(5, :), 'b',cpixel, coeff(6, :), 'r'); xlabel('shift'); ylabel('correlation'); title('graph coeff rooster vs woods - gaussian 4, 0.5');
%% 

%3.2.1 Mach Bands
boxes = imread('file name');
boxes = im2double(boxes);

gaus5 = fspecial('gaussian', 18, 3);
gaus6 = fspecial('gaussian', 18, 2);
dog3 = gaus6 - gaus5;
boxesimage1 = conv2(boxes, dog3, 'same');

figure(3), imagesc(boxesimage1); colormap('gray'); title('convoluted boxes image with DoG Mask');

%3.3 Color Opponent Cells
%3.3.1 Centre 2 and Surround 3
gaus7 = fspecial('gaussian', 18, 2);
gaus8 = fspecial('gaussian', 18, 3);

R23_redOn = conv2(roosterd(:,:,1), gaus7, 'same');
R23_greeOn = conv2(roosterd(:,:,2), gaus8, 'same');
RedonGreenOff23 = R23_redOn - R23_greeOn;

G23_greenOn = conv2(roosterd(:,:,2), gaus7, 'same');
G23_redOn = conv2(roosterd(:,:,1), gaus8, 'same');
RedoffGreenon23 = G23_greenOn - G23_redOn;

B23_blueOn = conv2(roosterd(:,:,3), gaus7, 'same');
B23_yellowOn = conv2(mean(roosterd(:,:,1:2), 3), gaus8, 'same');
BlueOnYellowOff23 = B23_blueOn - B23_yellowOn;

Y23_yellowOn = conv2(mean(roosterd(:,:,1:2), 3), gaus7, 'same');
Y23_blueOn = conv2(roosterd(:,:,3), gaus8, 'same');
YellowOnBlueOff23 = Y23_yellowOn - Y23_blueOn;

figure(4), subplot(2,2,1), imagesc(RedonGreenOff23); title('Gaussian 2, 3 - red on, green off')
figure(4), subplot(2,2,2), imagesc(RedoffGreenon23); title('Gaussian 2, 3 - green on, red off')
figure(4), subplot(2,2,3), imagesc(BlueOnYellowOff23); title('Gaussian 2, 3 - blue on, yellow off')
figure(4), subplot(2,2,4), imagesc(YellowOnBlueOff23); title('Gaussian 2, 3 - yellow on, blue off')


%3.3.2 Centre 2 and Surround 2

R22_redOn = conv2(roosterd(:,:,1), gaus7, 'same');
R22_greeOn = conv2(roosterd(:,:,2), gaus7, 'same');
RedonGreenOff22 = R22_redOn - R22_greeOn;

G22_greenOn = conv2(roosterd(:,:,2), gaus7, 'same');
G22_redOn = conv2(roosterd(:,:,1), gaus7, 'same');
RedoffGreenon22 = G22_greenOn - G22_redOn;

B22_blueOn = conv2(roosterd(:,:,3), gaus7, 'same');
B22_yellowOn = conv2(mean(roosterd(:,:,1:2), 3), gaus7, 'same');
BlueOnYellowOff22 = B22_blueOn - B22_yellowOn;

Y22_yellowOn = conv2(mean(roosterd(:,:,1:2), 3), gaus7, 'same');
Y22_blueOn = conv2(roosterd(:,:,3), gaus7, 'same');
YellowOnBlueOff22 = Y22_yellowOn - Y22_blueOn;

figure(5), subplot(2,2,1), imagesc(RedonGreenOff22); title('Gaussian 2, 2 - red on, green off')
figure(5), subplot(2,2,2), imagesc(RedoffGreenon22); title('Gaussian 2, 2 - green on, red off')
figure(5), subplot(2,2,3), imagesc(BlueOnYellowOff22); title('Gaussian 2, 2 - blue on, yellow off')
figure(5), subplot(2,2,4), imagesc(YellowOnBlueOff22); title('Gaussian 2, 2 - yellow on, blue off')


%4. Orientation Selective Cells Modelling using Gabor Masks

elephant = imread('file name');
elephantg = im2double(elephant);
gaborelephant = [];

%4.1 Simple Cells - One Orientation
gaborelephant(:,:,1) = conv2(elephantg, gabor(4, 90, 8, 0, 0.5), 'valid');

%4.2 Complex Cells - One Orientation
gaborelephant(:,:,2) = conv2(elephantg, gabor(4, 90, 8, 90, 0.5), 'valid');
l2norm = sqrt(gaborelephant(:,:,1).^2 + gaborelephant(:,:,2).^2);
i = 15;
%4.3 Complex Cells - Multiple Orientations
for K = 1:1:12
    gabormask1(:, :, K) = gabor(4, i, 8, 0, 0.5);
    gabormask2(:, :, K) = gabor(4, i, 8, 90, 0.5);
    i = i + 15;
end

for K = 1:1:12
    gaborimage1(:,:,K) = conv2(elephantg, gabormask1(:, :, K), 'valid');
    gaborimage2(:,:,K) = conv2(elephantg, gabormask2(:, :, K), 'valid');
    gaborimage(:,:,K) = sqrt(gaborimage1(:,:,K).^2 + gaborimage2(:,:,K).^2);
end


complexcell2 = max(gaborimage1, [], 3);

figure(7), subplot(1,3,1), imagesc(gaborelephant(:,:,1)); colorbar; title('Simple Cell - One Orientation');
figure(7), subplot(1,3,2), imagesc(l2norm); colorbar; title('Complex Cell - One Orientation');
figure(7), subplot(1,3,3), imagesc(complexcell2); colorbar; title('Complex Cell - Multiple Orientation');
