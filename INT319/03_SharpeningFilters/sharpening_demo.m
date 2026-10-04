%% 1. Read and Display an Image
% Read an image into the workspace and display it.
a = imread('hestain.png');
imshow(a);
title('Original Image');

%% 2. Sharpen the Image
% Sharpen the image using the imsharpen function and display it.
b = imsharpen(a);
figure;
imshow(b);
title('Sharpened Image');

%% 3. Control the Amount of Sharpening at the Edges
% Read an image into the workspace and display it.
a = imread('rice.png');
figure;
imshow(a);
title('Original Image');
% Sharpen the image by specifying the radius and amount parameters.
b = imsharpen(a, 'Radius', 2, 'Amount', 1);
figure;
imshow(b);
title('Sharpened Image');
