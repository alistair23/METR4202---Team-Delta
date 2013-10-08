function main()
%% Start Colour Calibration
% %Get a picture from the kinect
% capture_image(false, true, 30);
% im = imread('ColourPhoto.png');
% 
% %Crop the region of the colourchecker
% [squaresIm, cropRect] = imcrop(im);
% close;
% 
% % Convert chart image to black and white
% gray = rgb2gray(squaresIm);     % Convert to grayscale
% J = histeq(gray);               % Equalize the histogram
% threshold = graythresh(J);      % Threshold
% bw = im2bw(J, threshold);       % Convert to B&W
% 
% % Remove white pixels along the border, then dilate and erode to fill in
% % solids.
% bw2 = imclearborder(bw);
% se = strel('square', 25);
% bw2 = imopen(bw2, se);
% 
% % Automatically find the centroid of all unique objects in the image.
% labeled = bwlabel(bw2);
% s = regionprops(labeled,'Centroid');
% centroids = cat(1, s.Centroid);
% 
% % Use custom algorithm to find missing squares on the chart.
% squareLocations = findAllChartSquares(centroids, squaresIm);
% 
% RGB_Yellow = impixel(squaresIm, round(squareLocations{2}(6, 1)), round(squareLocations{2}(6, 2)));
% RGB_Silver = impixel(squaresIm, round(squareLocations{4}(3, 1)), round(squareLocations{4}(3, 2)));
% 
% YCbCr_Yellow = rgb2ycbcr(RGB_Yellow);
% YCbCr_Silver = rgb2ycbcr(RGB_Silver);
% 
% HSV_Yellow = rgb2hsv(RGB_Yellow);
% HSV_Silver = rgb2hsv(RGB_Silver);

%% Start Intrisic Calibration
% for i=1:7
%     %Get a picture from the kinect
%     %capture_image(false, true, i);
% end
% 
% ima_read_calib();
% add_suppress();
% click_calib();
% go_calib_optim();
% ext_calib();
% 
% fprintf(1,'Extrinsic parameters:\n\n');
% fprintf(1,'Translation vector: Tc_ext = [ %3.6f \t %3.6f \t %3.6f ]\n',Tckk);
% fprintf(1,'Rotation vector:   omc_ext = [ %3.6f \t %3.6f \t %3.6f ]\n',omckk);
% fprintf(1,'Rotation matrix:    Rc_ext = [ %3.6f \t %3.6f \t %3.6f\n',Rckk(1,:)');
% fprintf(1,'                               %3.6f \t %3.6f \t %3.6f\n',Rckk(2,:)');
% fprintf(1,'                               %3.6f \t %3.6f \t %3.6f ]\n',Rckk(3,:)');

%% Capture the image of the scene
%Get a picture from the kinect
capture_image(false, true, 40);
 
im = imread('CoinPhoto_c.png');
im_d = imread('CoinPhoto_d.png');

% Convert to grey scale
imgrey = rgb2gray(im);
im_c = imread('Test.png');
 
%% Rectify the Image
% % Select four control points as shown in the figure,
% % then select File > Export Points to Workspace
% %[input_points, output_points] = cpselect(imgrey, im_c, 'Wait', true);
% 
% output_circle = houghcircles(im_c, 110, 120, 0.33, 12, 350, 500, 300, 450);
% output_points = [output_circle(1) - output_circle(3), output_circle(2); output_circle(1), output_circle(2) + output_circle(3); output_circle(1) + output_circle(3), output_circle(2); output_circle(1), output_circle(2) - output_circle(3)];
% 
% input_circle = houghcircles(imgrey, 130, 160, 0.2, 30, 350, 500, 300, 450);
% input_circle = sortrows(input_circle, -3);
% if size(input_circle, 1) ~= 1
%     input_points = [input_circle(1, 1) - input_circle(1, 3), input_circle(1, 2);
%         input_circle(1, 1), input_circle(1, 2) + input_circle(1, 3);
%         input_circle(1, 1) + input_circle(1, 3), input_circle(1, 2);
%         input_circle(1, 1), input_circle(1, 2) - input_circle(1, 3)];
% elseif size(input_circle, 1) == 0
%     input_circle = houghcircles(imgrey, 110, 160, 0.2, 30, 350, 500, 300, 450);
%     input_circle = sortrows(input_circle, -3);
% else
%     input_points = [min(input_circle(1, 1), input_circle(2, 1)) - input_circle(1, 3), min(input_circle(1, 2), input_circle(2, 2));
%         mean(input_circle(1, 1), input_circle(2, 1)), max(input_circle(1, 2) + input_circle(1, 3), input_circle(2, 2) + input_circle(2, 3));
%         max(input_circle(1, 1) + input_circle(1, 3),input_circle(2, 1) + input_circle(2, 3)), input_circle(1, 2);
%         mean(input_circle(1, 1), input_circle(2, 1)), min(input_circle(1, 2) - input_circle(1, 3), input_circle(2, 2) - input_circle(2, 3))];
% end
% 
% tform = cp2tform(input_points, output_points, 'projective');
% 
% % Transform the grayscale image
% Igft = imtransform(imgrey, tform, 'XYScale', 1);
% Ift = imtransform(im, tform, 'XYScale', 1);
% Idft = imtransform(im_d, tform, 'XYScale', 1);
% 
% %% Detect Circles
% min_radius = 8;
% max_radius = 20;
% 
% % Detect and show circles
% circles = houghcircles(Igft, min_radius, max_radius, 0.4, 30, 350, 500, 300, 450);
% 
% %% Determine the colour of each circle
% for i=1:size(circles, 1)
%     circles_RGB(i, :) = impixel(Ift, circles(i, 1), circles(i, 2));
%     circles_hsv(i, :) = rgb2hsv(circles_RGB(i, 1:3));
%     if circles_hsv(i, 1) > 0.04 && circles_hsv(i, 1) < 0.17
%         if circles_hsv(i, 2) > 0.28 && circles_hsv(i, 2) < 0.63
%                 circles_colour(i) = 'G';
%                 continue;
%         end
%     end
%     if circles_hsv(i, 1) > (0.1484*0.5) && circles_hsv(i, 1) < (0.1484*1.5)
%         if circles_hsv(i, 2) > (0.5079*0.01) && circles_hsv(i, 2) < (0.5079*0.7)
%                 circles_colour(i) = 'S';
%                 continue;
%         end
%     end
%     % Can't identify the coin colour
%     circles_colour(i) = 'U';
% end
% 
% %% Estimate the value of the money
% num_coins = [0, 0, 0, 0, 0, 0]; %($2, $1, 50c, 20c, 10c, 5c)
% total_value = 0;
% 
% for i=1:size(circles, 1)
%     intensity = rgb2hsv(impixel(Idft, circles(i, 1), circles(i, 2)));
%     diameter_of_coin(i) = circles(i, 3) * intensity(3);
%     diameter_of_coin(i) = round((0.0113*diameter_of_coin(i)) - 32.023);
%     
%     if diameter_of_coin(i) < 20 && circles_colour(i) == 'G'
%         % $2
%         num_coins(1) = num_coins(1) + 1;
%         total_value = total_value + 2;
%     elseif diameter_of_coin(i) > 19 && circles_colour(i) == 'G'
%         % $1
%         num_coins(2) = num_coins(2) + 1;
%         total_value = total_value + 1;
%     elseif diameter_of_coin(i) > 31 && circles_colour(i) == 'S'
%         % 50c
%         num_coins(3) = num_coins(3) + 1;
%         total_value = total_value + 0.5;
%     elseif diameter_of_coin(i) > 21 && diameter_of_coin(i) < 32 && circles_colour(i) == 'S'
%         % 20c
%         num_coins(4) = num_coins(4) + 1;
%         total_value = total_value + 0.2;
%     elseif diameter_of_coin(i) > 14 && diameter_of_coin(i) < 22 && circles_colour(i) == 'S'
%         % 10c
%         num_coins(5) = num_coins(5) + 1;
%         total_value = total_value + 0.1;
%     elseif diameter_of_coin(i) > 10 && diameter_of_coin(i) < 15 && circles_colour(i) == 'S'
%         % 5c
%         num_coins(6) = num_coins(6) + 1;
%         total_value = total_value + 0.05;
%     elseif circles_colour(i) == 'G'
%         % Guess $1 as that seems to be common
%         num_coins(2) = num_coins(2) + 1;
%         total_value = total_value + 1;
%     elseif circles_colour(i) == 'S'
%         % Guess 50c as that seems to be common
%         num_coins(3) = num_coins(3) + 1;
%         total_value = total_value + 0.5;
%     else
%         % Just screwed!
%         fprintf(1, '\nUnidentified Coin!\n');
%     end
% end
% fprintf(1,'\nThe Total value of money is: %3.6f \n\n', total_value);

%% Detect the CalTag
[wPt, iPt] = caltag( im, 'caltag.mat', false );
end

