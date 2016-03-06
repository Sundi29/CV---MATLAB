clear
image1 = imread('Enter file name here');%Reading image into variable image1
output1 = image1;%Assign the output iamge as original image. Will change as the program goes
%Run a for loop to iterate thorugh every pixel of the image
for I = 1:160
    for J = 1:208
        I
        temp = impixel(image1, J, I);
        if((temp(1) > 160) & (temp(2) < 151) & (temp(3) < 150))%If pixel falls within the orange color range - football
            output1(I, J, :) = image1(I, J, :);%Assign the output iamge at that pixel same as in the original image
        elseif (((temp(1) > 126)) & ((temp(2) > 126) & (temp(2) < 190)) & ((temp(3) > 14) & (temp(3) < 100)))%If pixel falls within the yellow color range - goal/beacon
            output1(I, J, :) = image1(I, J, :);%Assign the output iamge at that pixel same as in the original image
        elseif((temp(1) > 235) & (temp(3) > 120))%If pixel falls within the pink color range - beacon
            output1(I, J, :) = image1(I, J, :);%Assign the output iamge at that pixel same as in the original image
        elseif (temp(1) < 18)%If pixel falls within the blue color range - goal/beacon
            output1(I, J, :) = image1(I, J, :);%Assign the output iamge at that pixel same as in the original image
        else%If not in any of the threshold regions then assign output at that pixel to [0 0 0]
            output1(I, J, 1) = 0;
            output1(I, J, 2) = 0;
            output1(I, J, 3) = 0;
        end
    end
end
figure(1), subplot(1,2,1), imagesc(image1);%Dislaying original image
figure(1), subplot(1,2,2), imagesc(output1);%Displaying output image