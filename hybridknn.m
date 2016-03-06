clear%clearing the previous variables
image1 = imread('Enter image name with extention');%reading image into the varaible image1
N = size(image1);%Assigning the size of image to N
figure(1), subplot(2,1,1), imagesc(image1);%displaying the image
output1 = image1;%Assigning output image output1 as original image. Will Change it along the code. 
%5 arrays c1...c5 to store the pixels within a thresholds. c1 to store
%first threshold, c2 to store pixels in the second thresold range and so
%on.
c1 = [];
c2 = [];
c3 = [];
c4 = [];
c5 = [];
%L is to keep track of the lengths of the above arrays
L = [0 0 0 0 0]
%Run a for loop to iterate through each pixel in the image
for I = 1:N(1)
    for J = 1:N(2)
        I %displaying the row at which we are iterating through
        temp = impixel(image1, J, I);%Storing the [R G B] color values at image1(I, J, :) to temp
        if((temp(1) > 160) & (temp(2) < 151) & (temp(3) < 150))%Checking if it is within the threshold range of the football
            L(1) = L(1) + 1; %if so add to color values to c1 array
            c1(L(1), :) = temp;
        elseif (((temp(1) > 126)) & ((temp(2) > 126) & (temp(2) < 190)) & ((temp(3) > 14) & (temp(3) < 100)))%Checking if the pixel is within the threshold of the yellow colors
            L(2) = L(2) + 1;%if so add to color values to c2 array
            c2(L(2), :) = temp;
        elseif((temp(1) > 235) & (temp(3) > 120))%Checking if it is within the threshold range of the pink colors
            L(3) = L(3) + 1;%if so add to color values to c3 array
            c3(L(3), :) = temp;
        elseif (temp(1) < 18)%Checking if it is within the threshold range of the blue colors
            L(4) = L(4) + 1;%if so add to color values to c4 array
            c4(L(4), :) = temp;
        else%Checking if it is within the threshold range of the rest of image
            L(5) = L(5) + 1;%if so add to color values to c5 array
            c5(L(5), :) = temp;
        end
    end
end
%Calculating average of all color values within a threshold and storing it
%in R
R(1, :) = (sum(c1, 1)./size(c1, 1));
R(2, :) = (sum(c2, 1)./size(c2, 1));
R(3, :) = (sum(c3, 1)./size(c3, 1));
R(4, :) = (sum(c4, 1)./size(c4, 1));
R(5, :) = (sum(c5, 1)./size(c5, 1));
%Assigning each cluster to a color value
intensities = [0 0 0;75 85 100;135 150 150;170 195 190;255 255 255];
%Run a nested for loop to iterate through every pixel in the image. 
%below part is the K-nearest neighbour part 
for I = 1:N(1)
    for J = 1:N(2)
        I%displaying the row at which we are iterating through
        mini = 0; 
        minidiffer = 0;
        inten = impixel(image1, J, I);
        for K = 1:size(R, 1)
            differ = abs((R(K, 1) - inten(1))) + abs((R(K, 2) - inten(2))) + abs((R(K, 3) - inten(3)));%calculating Sum of absolute difference between centre and pixel
            if(K == 1 | differ<minidiffer)%Checking if first centre or if distance is less than the previous least distance
                mini  = K;
                minidiffer = differ;
            end
        end
        output1(I, J, :) = intensities(mini, :);%Assigning the color values to the respective cluster using the intensities
    end
end

figure(1), subplot(2,1,2), imagesc(output1);%Displaying the output image