classdef ImageMorphology_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure           matlab.ui.Figure
        ClearButton        matlab.ui.control.Button
        DropDown           matlab.ui.control.DropDown
        DropDownLabel      matlab.ui.control.Label
        BrowseImageButton  matlab.ui.control.Button
        UIAxes2            matlab.ui.control.UIAxes
        UIAxes             matlab.ui.control.UIAxes
    end

    properties (Access = private)
        OriginalImage   % stores the original RGB image
    end

    methods (Access = private)

        function applyMorphology(app)

            if isempty(app.OriginalImage)
                return;
            end

            img = app.OriginalImage;
            se = strel('disk', 3);   % default structuring element

            method = app.DropDown.Value;

            switch method
                case 'Erosion'
                    result = imerode(img, se);

                case 'Dilation'
                    result = imdilate(img, se);

                case 'Opening'
                    result = imopen(img, se);

                case 'Closing'
                    result = imclose(img, se);

                case 'Morphological Gradient'
                    result = imdilate(img, se) - imerode(img, se);
                case 'Top-hat'
                    result = imtophat(img, se);

                case 'Bottom-hat'
                    result = imbothat(img, se);

                otherwise
                    result = img;
            end

            % Display result on right axes
            imshow(result, 'Parent', app.UIAxes2);
            title(app.UIAxes2, method);

        end

    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: BrowseImageButton
        function BrowseImageButtonPushed(app, event)

            [file, path] = uigetfile( ...
                {'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff', ...
                 'Image Files'}, ...
                'Select an Image');

            if isequal(file, 0)
                return;
            end

            fullPath = fullfile(path, file);
            app.OriginalImage = imread(fullPath);

            % Show original RGB image on left
            imshow(app.OriginalImage, 'Parent', app.UIAxes);
            title(app.UIAxes, 'Original Image');

            % Apply currently selected morphology operation
            applyMorphology(app);
        end

        % Value changed function: DropDown
        function DropDownValueChanged(app, event)

            applyMorphology(app);

        end

        % Button pushed function: ClearButton
        function ClearButtonPushed(app, event)

            cla(app.UIAxes);
            cla(app.UIAxes2);

            title(app.UIAxes, 'Original Image');
            title(app.UIAxes2, 'Morphology Result');

            app.OriginalImage = [];
            app.DropDown.Value = 'Erosion';   % reset to first item

        end

    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 900 500];
            app.UIFigure.Name = 'Image Morphology';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Original Image');
            xlabel(app.UIAxes, 'X');
            ylabel(app.UIAxes, 'Y');
            zlabel(app.UIAxes, 'Z');
            app.UIAxes.Position = [40 120 380 300];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Morphology Result');
            xlabel(app.UIAxes2, 'X');
            ylabel(app.UIAxes2, 'Y');
            zlabel(app.UIAxes2, 'Z');
            app.UIAxes2.Position = [480 120 380 300];

            % Create BrowseImageButton
            app.BrowseImageButton = uibutton(app.UIFigure, 'push');
            app.BrowseImageButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseImageButtonPushed, true);
            app.BrowseImageButton.Position = [60 50 100 23];
            app.BrowseImageButton.Text = 'Browse Image';

            % Create DropDownLabel
            app.DropDownLabel = uilabel(app.UIFigure);
            app.DropDownLabel.HorizontalAlignment = 'right';
            app.DropDownLabel.Position = [230 50 65 22];
            app.DropDownLabel.Text = 'Operation';

            % Create DropDown
            app.DropDown = uidropdown(app.UIFigure);
            app.DropDown.Items = {'Erosion', 'Dilation', 'Opening', 'Closing', 'Morphological Gradient', 'Top-hat', 'Bottom-hat'};

            app.DropDown.ValueChangedFcn = createCallbackFcn(app, @DropDownValueChanged, true);

            app.DropDown.Position = [310 50 180 22];
            app.DropDown.Value = 'Erosion';

            % Create ClearButton
            app.ClearButton = uibutton(app.UIFigure, 'push');
            app.ClearButton.ButtonPushedFcn = createCallbackFcn(app, @ClearButtonPushed, true);
            app.ClearButton.Position = [740 50 100 23];
            app.ClearButton.Text = 'Clear';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ImageMorphology_exported

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
