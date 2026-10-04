classdef app5_thresholding < matlab.apps.AppBase

    properties (Access = public)
        UIFigure
        UIAxes
        UIAxes2
        BrowseButton
        DropDown
    end

    properties (Access = private)
        I
    end
    methods (Access = private)

        function BrowseButtonPushed(app, event)
            [f, p] = uigetfile({'*.jpg;*.png;*.bmp;*.tif'});

            if isequal(f, 0)
                return;
            end

            app.I = im2gray(imread(fullfile(p, f)));
            imshow(app.I, 'Parent', app.UIAxes);
        end

        function DropDownValueChanged(app, event)
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
        end

    end

    methods (Access = public)

        function app = app5_thresholding
            app.UIFigure = uifigure( ...
                'Position', [100 100 800 450], ...
                'Name', 'Ex 5');

            app.UIAxes = uiaxes( ...
                app.UIFigure, ...
                'Position', [20 90 370 340]);

            app.UIAxes2 = uiaxes( ...
                app.UIFigure, ...
                'Position', [410 90 370 340]);

            app.BrowseButton = uibutton( ...
                app.UIFigure, ...
                'Position', [180 30 120 30], ...
                'Text', 'Browse', ...
                'ButtonPushedFcn', ...
                createCallbackFcn(app, @BrowseButtonPushed, true));

            app.DropDown = uidropdown( ...
                app.UIFigure, ...
                'Position', [420 30 200 30], ...
                'Items', { ...
                    'Otsu (global)', ...
                    'Fixed 0.4', ...
                    'Adaptive', ...
                    'Multilevel', ...
                    'Inverted'}, ...
                'ValueChangedFcn', ...
                createCallbackFcn(app, @DropDownValueChanged, true));

            registerApp(app, app.UIFigure);
        end

        function delete(app)
            delete(app.UIFigure);
        end

    end

end
