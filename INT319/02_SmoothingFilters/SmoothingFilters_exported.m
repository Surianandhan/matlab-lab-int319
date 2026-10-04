classdef SmoothingFilters_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        FilterDropDown       matlab.ui.control.DropDown
        FilterDropDownLabel  matlab.ui.control.Label
        NoiseDropDown        matlab.ui.control.DropDown
        NoiseDropDownLabel   matlab.ui.control.Label
        BrowseImageButton    matlab.ui.control.Button
        UIAxes3              matlab.ui.control.UIAxes
        UIAxes2              matlab.ui.control.UIAxes
        UIAxes               matlab.ui.control.UIAxes
    end

    properties (Access = private)
        Image % Grayscale input image
    end

    methods (Access = private)

        function applyFilter(app)
            if isempty(app.Image)
                return;
            end
            I = app.Image;

            % Add the selected noise
            switch app.NoiseDropDown.Value
                case 'Salt & Pepper'
                    J = imnoise(I, 'salt & pepper', 0.02);
                case 'Gaussian'
                    J = imnoise(I, 'gaussian', 0, 0.025);
            end

            % Apply the selected smoothing filter
            switch app.FilterDropDown.Value
                case 'Mean'
                    K = filter2(fspecial('average', 3), J) / 255;
                case 'Median'
                    K = medfilt2(J);
                case 'Wiener'
                    K = wiener2(J, [5 5]);
                case 'Gaussian'
                    K = imgaussfilt(J, 2);
            end

            imshow(J, 'Parent', app.UIAxes2);
            title(app.UIAxes2, [app.NoiseDropDown.Value ' Noise']);
            imshow(K, 'Parent', app.UIAxes3);
            title(app.UIAxes3, [app.FilterDropDown.Value ' Filter Output']);
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
            app.Image = im2uint8(im2gray(imread(fullfile(path, file))));
            imshow(app.Image, 'Parent', app.UIAxes);
            title(app.UIAxes, 'Original Image');
            applyFilter(app);
        end

        % Value changed function: NoiseDropDown
        function NoiseDropDownValueChanged(app, event)
            applyFilter(app);
        end

        % Value changed function: FilterDropDown
        function FilterDropDownValueChanged(app, event)
            applyFilter(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 900 420];
            app.UIFigure.Name = 'Image Smoothing Filters';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Original Image')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [20 100 280 290];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Noisy Image')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [310 100 280 290];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.UIFigure);
            title(app.UIAxes3, 'Filter Output')
            xlabel(app.UIAxes3, 'X')
            ylabel(app.UIAxes3, 'Y')
            zlabel(app.UIAxes3, 'Z')
            app.UIAxes3.Position = [600 100 280 290];

            % Create BrowseImageButton
            app.BrowseImageButton = uibutton(app.UIFigure, 'push');
            app.BrowseImageButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseImageButtonPushed, true);
            app.BrowseImageButton.Position = [60 40 110 23];
            app.BrowseImageButton.Text = 'Browse Image';

            % Create NoiseDropDownLabel
            app.NoiseDropDownLabel = uilabel(app.UIFigure);
            app.NoiseDropDownLabel.HorizontalAlignment = 'right';
            app.NoiseDropDownLabel.Position = [240 40 45 22];
            app.NoiseDropDownLabel.Text = 'Noise';

            % Create NoiseDropDown
            app.NoiseDropDown = uidropdown(app.UIFigure);
            app.NoiseDropDown.Items = {'Salt & Pepper', 'Gaussian'};
            app.NoiseDropDown.ValueChangedFcn = createCallbackFcn(app, @NoiseDropDownValueChanged, true);
            app.NoiseDropDown.Position = [295 40 140 22];
            app.NoiseDropDown.Value = 'Salt & Pepper';

            % Create FilterDropDownLabel
            app.FilterDropDownLabel = uilabel(app.UIFigure);
            app.FilterDropDownLabel.HorizontalAlignment = 'right';
            app.FilterDropDownLabel.Position = [500 40 45 22];
            app.FilterDropDownLabel.Text = 'Filter';

            % Create FilterDropDown
            app.FilterDropDown = uidropdown(app.UIFigure);
            app.FilterDropDown.Items = {'Mean', 'Median', 'Wiener', 'Gaussian'};
            app.FilterDropDown.ValueChangedFcn = createCallbackFcn(app, @FilterDropDownValueChanged, true);
            app.FilterDropDown.Position = [555 40 140 22];
            app.FilterDropDown.Value = 'Mean';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SmoothingFilters_exported

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
