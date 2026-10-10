classdef ColourImageProcessing_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure           matlab.ui.Figure
        ProcessButton      matlab.ui.control.Button
        SelectImageButton  matlab.ui.control.Button
        UIAxes             matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        OriginalImage % Loaded RGB image
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: SelectImageButton
        function SelectImageButtonPushed(app, event)
            [file, path] = uigetfile( ...
                {'*.png;*.jpg;*.jpeg;*.bmp;*.tif', ...
                'Image Files (*.png, *.jpg, *.bmp, *.tif)'});

            if isequal(file, 0)
                return;
            end

            % Read the selected image
            I = imread(fullfile(path, file));

            % Convert grayscale image to RGB if required
            if ndims(I) == 2
                I = cat(3, I, I, I);
            elseif size(I, 3) > 3
                I = I(:, :, 1:3);
            end

            app.OriginalImage = I;

            % Display the original image
            imshow(I, 'Parent', app.UIAxes);
            title(app.UIAxes, 'Original Image');
        end

        % Button pushed function: ProcessButton
        function ProcessButtonPushed(app, event)
            if isempty(app.OriginalImage)
                uialert(app.UIFigure, ...
                    'Please select an image first.', 'Error');
                return;
            end

            I = app.OriginalImage;

            % Extract RGB channels
            r = size(I, 1);
            c = size(I, 2);

            R = zeros(r, c, 3, 'like', I);
            G = zeros(r, c, 3, 'like', I);
            B = zeros(r, c, 3, 'like', I);

            R(:, :, 1) = I(:, :, 1);
            G(:, :, 2) = I(:, :, 2);
            B(:, :, 3) = I(:, :, 3);

            % Sharpen each individual channel
            processedR = imsharpen(I(:, :, 1));
            processedG = imsharpen(I(:, :, 2));
            processedB = imsharpen(I(:, :, 3));

            % Create RGB display images for processed channels
            PR = zeros(r, c, 3, 'like', I);
            PG = zeros(r, c, 3, 'like', I);
            PB = zeros(r, c, 3, 'like', I);

            PR(:, :, 1) = processedR;
            PG(:, :, 2) = processedG;
            PB(:, :, 3) = processedB;

            % Reconstruct the final RGB image
            finalRGB = cat(3, processedR, ...
                processedG, processedB);

            % Display all results in UIAxes
            cla(app.UIAxes);

            montage({I, R, G, B, PR, PG, PB, finalRGB}, ...
                'Parent', app.UIAxes, ...
                'Size', [2 4]);

            title(app.UIAxes, ...
                'Original, RGB Planes, Processed Channels and Final RGB');
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Colour Image Processing';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Colour Processed')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [49 138 544 314];

            % Create SelectImageButton
            app.SelectImageButton = uibutton(app.UIFigure, 'push');
            app.SelectImageButton.ButtonPushedFcn = createCallbackFcn(app, @SelectImageButtonPushed, true);
            app.SelectImageButton.Position = [101 59 100 23];
            app.SelectImageButton.Text = 'Select Image';

            % Create ProcessButton
            app.ProcessButton = uibutton(app.UIFigure, 'push');
            app.ProcessButton.ButtonPushedFcn = createCallbackFcn(app, @ProcessButtonPushed, true);
            app.ProcessButton.Position = [447 58 100 23];
            app.ProcessButton.Text = 'Process';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ColourImageProcessing_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
