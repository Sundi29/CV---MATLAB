clear
segment = imread('Enter image name here');%Inputting the image to variable image1
image1 = imresize(segment1, 0.5, 'nearest');%resizing the image to half to improve computation time
N = size(image1);%getting size of the image
new_regions = [];%Used to store the pixels which belong to the new regions
neighbours = [];%Used to store the neighbouring pixels part of the same regions
output1 = image1;%Assigning output image to original image. Will change during the processing of image.
category = 1;%Number of regions code finds. May be high due to noisy pixels. 
T = [0, 0];%to keep track of the lengths of the new_regions and neighbours arrays
%3-D matrix used to assign the region for each pixel and also the state of
%each pixel
label(:, :, 1) = zeros(N(1), N(2));%Used to assign a region to each pixel
label(:, :, 2) = zeros(N(1), N(2));%tell us the state of each pixel (-1 - new region have to reexplore, 0 - not reached yet, 1 - categorised but has to check its neighbours, 2 categorised and neighbours have been checked)
I = randi(N(1)) %Start with a random pixel
J = randi(N(2))
T(1) = T(1) + 1
neigh = [-1 -1; -1 0; -1 1;0 -1;0 -1;0 1;1 -1;1 0;1 1]%Used to calculate the indices of the neighbouring pixels
new_regions(T(1),:) = [I, J];
while(size(new_regions, 1) ~= 0)%While loop until all pixels have been explored
    I = new_regions(1, 1);%Get the row and column of first pixel in region growing
    J = new_regions(1, 2);
    new_regions(1, :) = [];%Delete it from the new_region array
    T(1) = T(1) - 1;
    if(label(I, J, 2) ~= 2)%Check if it has been explored or not
        label(I, J, 1) = category;%Categorise the pixel
        category = category + 1;
        val = impixel(image1, J, I);%Get the color vlaues at that pixel
        T(2) = T(2) + 1;
        neighbours(1, 1) = I;%Store the original region pixel into the neighbours array
        neighbours(1, 2) = J;
        while(size(neighbours, 1) ~= 0)%While loop till all pixels within a region has been explored
            I2 = neighbours(1, 1)%Take the first pixel in the neighbours array
            J2 = neighbours(1, 2)
            neighbours(1,:) = [];%Delete it from the list
            T(2) = T(2) - 1;
            if(label(I2, J2, 2) ~= 2)%Check if already been explored or not
                label(I2, J2, 2) = 2;%If not mark as explored
                inten = impixel(image1, J2, I2);%Get the color values
                for i = 1:size(neigh, 1)%Calculating its neighbouring pixels 
                    I1 = I2 + neigh(i, 1);
                    J1 = J2 + neigh(i, 2);
                    [I1 J1]%Displaying the pixels
                    if(I1>0 & I1<=N(1) & J1>0 & J1<=N(2))%Checking if the pixel is in the frame of the image. 
                        if((label(I1, J1, 2) ~= 1) && (label(I1, J1, 2) ~= 2))%Checking if the pixel has already been categorised and explored
                            int1 = impixel(image1, J1, I1);%Get color vlaues of neighbouring pixel
                            SAD = abs(inten(1) - int1(1));%Calculating the difference using sum of absolute difference (SAD)
                            if(SAD <= 10)% Checking if difference is less than the threshold 
                                label(I1, J1, 1) = label(I2, J2, 1);%If so labelling it as same region
                                label(I1, J1, 2) = 1;%Marking it as categorised
                                T(2) = T(2) + 1;
                                neighbours(T(2), :) = [I1, J1];%Adding it to the neighbouring array
                                output1(I1, J1, :) = val;%assigning the pixel at output same as the first original pixel of region
                            else
                                if(label(I1, J1, 2) == 0)%If not in the threshold and if not reached
                                    label(I1, J1, 2) = -1;%Mark as new_region
                                    T(1) = T(1) + 1;
                                    new_regions(T(1), :) = [I1, J1];%Added it to the new region array
                                end                                
                            end
                        end
                    end
                end          
            end
        end
    end
end
figure(100), subplot(2,1,1), imagesc(image1); %display the image and output.
figure(100), subplot(2,1,2), imagesc(output1); %display the image and output.
                
        
            
        