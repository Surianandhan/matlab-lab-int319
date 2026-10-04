classdef app4 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure           matlab.ui.Figure
        DropDown           matlab.ui.control.DropDown
        DropDownLabel      matlab.ui.control.Label
        BrowseImageButton  matlab.ui.control.Button
        UIAxes2            matlab.ui.control.UIAxes
        UIAxes             matlab.ui.control.UIAxes
    end

    properties (Access = private)
        OriginalImage  % Stores the original RGB image
    end

    methods (Access = private)

        function applySharpening(app)

            if isempty(app.OriginalImage)
                return;
            end

            img = im2double(app.OriginalImage);
            method = app.DropDown.Value;

            switch method

                case 'imsharpen'
                    result = imsharpen(img);
                case 'Unsharp Mask'
                    h = fspecial('unsharp');
                    result = imfilter(img, h, 'replicate');
                case 'Laplacian'
                    h = fspecial('laplacian');

                    % Proper sharpening formula
                    result = img - imfilter(img, h, 'replicate');

                case 'LoG'
                    h = fspecial('log', 5, 0.5);
                    result = img - imfilter(img, h, 'replicate');
                case 'Gaussian'
                    h = fspecial('gaussian');
                    result = imfilter(img, h, 'replicate');
                case 'Sobel'
                    h = fspecial('sobel');
                    result = imfilter(img, h, 'replicate');
                    result = abs(result);  % Take absolute value for edges

                otherwise
                    result = img;
            end

            % Auto-scale display for filters that produce negative values
            imshow(result, [], 'Parent', app.UIAxes2);
            title(app.UIAxes2, ['Sharpened (', method, ')']);
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: BrowseImageButton
        function BrowseImageButtonPushed(app, event)
            [file, path] = uigetfile( ...
                {'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff', 'Image Files'}, ...
                'Select an Image');
            if isequal(file, 0)
                return;
            end
            fullPath = fullfile(path, file);
            app.OriginalImage = imread(fullPath);

            % Show original RGB image on left axes
            imshow(app.OriginalImage, 'Parent', app.UIAxes);
            title(app.UIAxes, 'Original Image');

            % Apply currently selected sharpening method
            applySharpening(app);
        end

        % Value changed function: DropDown
        function DropDownValueChanged(app, event)
            applySharpening(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title');
            xlabel(app.UIAxes, 'X');
            ylabel(app.UIAxes, 'Y');
            zlabel(app.UIAxes, 'Z');
            app.UIAxes.Position = [9 149 300 185];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Title');
            xlabel(app.UIAxes2, 'X');
            ylabel(app.UIAxes2, 'Y');
            zlabel(app.UIAxes2, 'Z');
            app.UIAxes2.Position = [328 149 300 185];

            % Create BrowseImageButton
            app.BrowseImageButton = uibutton(app.UIFigure, 'push');
            app.BrowseImageButton.ButtonPushedFcn = ...
                createCallbackFcn(app, @BrowseImageButtonPushed, true);
            app.BrowseImageButton.Position = [271 70 100 23];
            app.BrowseImageButton.Text = 'Browse Image';

            % Create DropDownLabel
            app.DropDownLabel = uilabel(app.UIFigure);
            app.DropDownLabel.HorizontalAlignment = 'right';
            app.DropDownLabel.Position = [231 410 65 22];
            app.DropDownLabel.Text = 'Drop Down';

            % Create DropDown
            app.DropDown = uidropdown(app.UIFigure);
            app.DropDown.Items = { ...
                'imsharpen', ...
                'Unsharp Mask', ...
                'Laplacian', ...
                'LoG', ...
                'Gaussian', ...
                'Sobel'};

            app.DropDown.ValueChangedFcn = ...
                createCallbackFcn(app, @DropDownValueChanged, true);

            app.DropDown.Position = [311 410 100 22];
            app.DropDown.Value = 'imsharpen';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app4

            % Create UIFigure and components
            createComponents(app);

            % Register the app with App Designer
            registerApp(app, app.UIFigure);
            if nargout == 0
                clear app;
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure);
        end
    end
end
