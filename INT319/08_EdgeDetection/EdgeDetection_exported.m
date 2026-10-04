classdef EdgeDetection_exported < matlab.apps.AppBase
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        ExecutemethodButton  matlab.ui.control.Button
        DropDown             matlab.ui.control.DropDown
        DropDownLabel        matlab.ui.control.Label
        LoadImageButton      matlab.ui.control.Button
        UIAxes2              matlab.ui.control.UIAxes
        UIAxes               matlab.ui.control.UIAxes
    end

    properties (Access = private)
        Image % Loaded grayscale image
    end

    % Callbacks that handle component events
    methods (Access = private)
        % Button pushed function: LoadImageButton
        function LoadImageButtonPushed(app, event)
            try
                [filename, path] = uigetfile({'*.png;*.jpg;*.jpeg;*.bmp', 'Image Files'}, 'Select Image');
                if isequal(filename, 0)
                    return;
                end
                img = imread(fullfile(path, filename));
                if size(img, 3) == 3
                    img = rgb2gray(img);
                end
                app.Image = img;
                % Show in Original Image area
                imshow(img, 'Parent', app.UIAxes);
                title(app.UIAxes, 'Original Image', 'FontSize', 14);
            catch ME
                uialert(app.UIFigure, ['Error loading image: ' ME.message], 'Error');
            end
        end
        % Button pushed function: ExecutemethodButton
        function ExecutemethodButtonPushed(app, event)
            try
                % Get current image
                currentImage = app.Image;
                if isempty(currentImage)
                    uialert(app.UIFigure, 'Please load an image first!', 'Warning', 'Icon', 'warning');
                    return;
                end
                % Get selected method from Drop Down
                method = app.DropDown.Value;
                % Apply edge detection
                switch method
                    case 'Sobel'
                        edges = edge(currentImage, 'Sobel');
                        titleText = 'Sobel';
                    case 'Prewitt'
                        edges = edge(currentImage, 'Prewitt');
                        titleText = 'Prewitt';
                    case 'Roberts'
                        edges = edge(currentImage, 'Roberts');
                        titleText = 'Roberts';
                    case 'Log'
                        edges = edge(currentImage, 'log');
                        titleText = 'Laplacian of Gaussian';
                    case 'Canny'
                        edges = edge(currentImage, 'Canny');
                        titleText = 'Canny';
                    case 'Zero Crossing'
                        edges = edge(currentImage, 'zerocross');
                        titleText = 'Zero Crossing';
                    otherwise
                        edges = currentImage;
                        titleText = 'Original';
                end
                % Show result in Resultant Image area
                imshow(edges, 'Parent', app.UIAxes2);
                title(app.UIAxes2, titleText, 'FontSize', 14);
            catch ME
                uialert(app.UIFigure, ['Error: ' ME.message], 'Error');
            end
        end
    end
    % Component initialization
    methods (Access = private)
        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Edge Detection Techniques';
            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Original Image')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [17 271 300 185];
            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Resultant Image')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [257 31 300 185];
            % Create LoadImageButton
            app.LoadImageButton = uibutton(app.UIFigure, 'push');
            app.LoadImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButtonPushed, true);
            app.LoadImageButton.Position = [357 383 100 23];
            app.LoadImageButton.Text = 'Load Image';
            % Create DropDownLabel
            app.DropDownLabel = uilabel(app.UIFigure);
            app.DropDownLabel.HorizontalAlignment = 'right';
            app.DropDownLabel.Position = [357 303 65 22];
            app.DropDownLabel.Text = 'Method';
            % Create DropDown
            app.DropDown = uidropdown(app.UIFigure);
            app.DropDown.Items = {'Sobel', 'Prewitt', 'Roberts', 'Log', 'Canny', 'Zero Crossing'};
            app.DropDown.Position = [437 303 100 22];
            app.DropDown.Value = 'Sobel';
            % Create ExecutemethodButton
            app.ExecutemethodButton = uibutton(app.UIFigure, 'push');
            app.ExecutemethodButton.ButtonPushedFcn = createCallbackFcn(app, @ExecutemethodButtonPushed, true);
            app.ExecutemethodButton.Position = [490 382 102 23];
            app.ExecutemethodButton.Text = 'Execute method';
            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end
    % App creation and deletion
    methods (Access = public)
        % Construct app
        function app = EdgeDetection_exported
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
