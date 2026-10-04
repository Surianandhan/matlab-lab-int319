classdef HistogramEqualization_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure         matlab.ui.Figure
        HistogramButton  matlab.ui.control.Button
        UploadButton     matlab.ui.control.Button
        UIAxes2          matlab.ui.control.UIAxes
        UIAxes           matlab.ui.control.UIAxes
    end

    properties (Access = private)
        Image % Uploaded image
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: UploadButton
        function UploadButtonPushed(app, event)
            [filename, filepath] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif', 'Image Files'}, 'Select file to open');
            if isequal(filename, 0)
                return;
            end
            app.Image = imread(fullfile(filepath, filename));
            imagesc(app.UIAxes, app.Image);
        end

        % Button pushed function: HistogramButton
        function HistogramButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            I = app.Image;
            % Convert RGB to grayscale if necessary
            if size(I, 3) == 3
                I = rgb2gray(I);
            end
            % Histogram Equalization
            I_histeq = histeq(I);
            imagesc(app.UIAxes2, I_histeq);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Histogram Equalization';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Original Image')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [213 242 417 239];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Histogram Equalized Image')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [213 10 416 223];

            % Create UploadButton
            app.UploadButton = uibutton(app.UIFigure, 'push');
            app.UploadButton.ButtonPushedFcn = createCallbackFcn(app, @UploadButtonPushed, true);
            app.UploadButton.Position = [82 338 100 23];
            app.UploadButton.Text = 'Upload';

            % Create HistogramButton
            app.HistogramButton = uibutton(app.UIFigure, 'push');
            app.HistogramButton.ButtonPushedFcn = createCallbackFcn(app, @HistogramButtonPushed, true);
            app.HistogramButton.Position = [82 109 100 23];
            app.HistogramButton.Text = 'Histogram';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = HistogramEqualization_exported

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
