classdef ImageThresholding_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure       matlab.ui.Figure
        DropDown       matlab.ui.control.DropDown
        DropDownLabel  matlab.ui.control.Label
        BrowseButton   matlab.ui.control.Button
        UIAxes2        matlab.ui.control.UIAxes
        UIAxes         matlab.ui.control.UIAxes
    end

    properties (Access = private)
        I % Grayscale input image
    end

    methods (Access = private)

        function applyThreshold(app)
            I = app.I;

            if isempty(I)
                return;
            end

            switch app.DropDown.Value

                case 'Otsu (global)'
                    R = imbinarize(I, graythresh(I));

                case 'Fixed 0.4'
                    R = imbinarize(I, 0.4);

                case 'Adaptive'
                    R = imbinarize(I, 'adaptive');

                case 'Multilevel'
                    R = label2rgb(imquantize(I, multithresh(I, 2)));

                case 'Inverted'
                    R = ~imbinarize(I, graythresh(I));

            end

            imshow(R, 'Parent', app.UIAxes2);
            title(app.UIAxes2, app.DropDown.Value);
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: BrowseButton
        function BrowseButtonPushed(app, event)
            [f, p] = uigetfile({'*.jpg;*.png;*.bmp;*.tif'});

            if isequal(f, 0)
                return;
            end

            app.I = im2gray(imread(fullfile(p, f)));
            imshow(app.I, 'Parent', app.UIAxes);
            title(app.UIAxes, 'Original Image');
            applyThreshold(app);
        end

        % Value changed function: DropDown
        function DropDownValueChanged(app, event)
            applyThreshold(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 800 450];
            app.UIFigure.Name = 'Image Thresholding';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Original Image')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [20 90 370 340];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Thresholded Image')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [410 90 370 340];

            % Create BrowseButton
            app.BrowseButton = uibutton(app.UIFigure, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.Position = [180 30 120 30];
            app.BrowseButton.Text = 'Browse';

            % Create DropDownLabel
            app.DropDownLabel = uilabel(app.UIFigure);
            app.DropDownLabel.HorizontalAlignment = 'right';
            app.DropDownLabel.Position = [350 34 60 22];
            app.DropDownLabel.Text = 'Method';

            % Create DropDown
            app.DropDown = uidropdown(app.UIFigure);
            app.DropDown.Items = {'Otsu (global)', 'Fixed 0.4', 'Adaptive', 'Multilevel', 'Inverted'};
            app.DropDown.ValueChangedFcn = createCallbackFcn(app, @DropDownValueChanged, true);
            app.DropDown.Position = [420 30 200 30];
            app.DropDown.Value = 'Otsu (global)';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ImageThresholding_exported

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
