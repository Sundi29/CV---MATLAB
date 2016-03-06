clear
image1 = imread('Enter image name here');%Reading the image into variable image1
N = size(image1);%N is an array holding the size of the image
output1 = image1;%Assigning the output image to the original image. Will change as we go through the code
%Assigning the random initial pixel to get the centres for clusters
for i = 1:5
    X = randi(255);
    Y = randi(255);
    Z = randi(255);
    R(i, :) = [X, Y, Z];
end
%Assigning color values to each cluster
intensities = [60 75 90;125 145 150;0 0 0;170 195 190;255 255 255];
%NewC is used to calculate the new centres at the end of each iteration
NewC = zeros(size(R, 1), 3);
%C is to show the nuber of iterations takes to complete the segmentation
C = 0;
%While loop as long as the new centres are not the same as the old ones or
%number of iterations does not go beyond 9
while(NewC ~= R & C<9)
    C = C + 1
    if(C>1)
        R = NewC;%If not the first iteration we assign the old centres as the new ones
    end
    S = zeros(size(R, 1), 4);%Used to get the sum of the color values for each centre. 
    for I = 1:N(1)
        for J = 1:N(2)
            mini = 999;
            minidiffer = 999;
            inten = impixel(image1, J, I);
            for K = 1:size(R, 1)
                differ = sum(abs(R(K, :) - inten));%calculating Sum of absolute difference between centre and pixel
                if(differ<minidiffer)%Checking if first centre or if distance is less than the previous least distance
                    mini  = K;
                    minidiffer = differ;
                end
            end
            %Finding the sum of the color values for each center
            S(mini, 1) = S(mini, 1) + inten(1);%Red color 
            S(mini, 2) = S(mini, 2) + inten(2);%Green color
            S(mini, 3) = S(mini, 3) + inten(3);%Blue color
            S(mini, 4) = S(mini, 4) + 1;%Increasing the length for each centre
            output1(I, J, :) = intensities(mini, :);%Changing the output for that pixel to the intensties corresponding to the centre.
            
        end
    end
    for i = 1:size(R, 1)
        NewC(i, :) = [S(i, 1)/S(i, 4) S(i, 2)/S(i, 4) S(i, 3)/S(i, 4)];%Calculating the new centres
    end
end
%Displaying the images.
figure(1), subplot(2,1,1), imagesc(image1);
figure(1), subplot(2,1,2), imagesc(output1);

        
        
        
        
        
            

    