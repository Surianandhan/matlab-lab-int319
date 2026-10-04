classdef PlottingFromCSV_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        StatsLabel               matlab.ui.control.Label
        PlotButton               matlab.ui.control.Button
        Column2DropDown          matlab.ui.control.DropDown
        Column2DropDownLabel     matlab.ui.control.Label
        Column1DropDown          matlab.ui.control.DropDown
        Column1DropDownLabel     matlab.ui.control.Label
        PlotTypeDropDown         matlab.ui.control.DropDown
        PlotTypeDropDownLabel    matlab.ui.control.Label
        FileLabel                matlab.ui.control.Label
        LoadTextFileButton       matlab.ui.control.Button
        LoadCSVButton            matlab.ui.control.Button
        PlotPanel                matlab.ui.container.Panel
    end

    properties (Access = private)
        T % Table read from the CSV file
        Text % Contents of the text file
    end

    methods (Access = private)

        function updateColumnLabels(app)
            switch app.PlotTypeDropDown.Value
                case {'Bar Plot', 'Pie Chart'}
                    labels = {'Labels', 'Values'};
                case {'Line Plot', 'Scatter Plot'}
                    labels = {'X', 'Y'};
                case {'Box Plot', 'Histogram'}
                    labels = {'', 'Data'};
                case 'Geographic Plot'
                    labels = {'Latitude', 'Longitude'};
                otherwise
                    labels = {'', ''};
            end
            app.Column1DropDownLabel.Text = labels{1};
            app.Column1DropDown.Enable = ~isempty(labels{1});
            app.Column2DropDownLabel.Text = labels{2};
            app.Column2DropDown.Enable = ~isempty(labels{2});
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadCSVButton
        function LoadCSVButtonPushed(app, event)
            [f,p] = uigetfile('*.csv');

            if isequal(f,0)
                return;
            end

            app.T = readtable(fullfile(p,f));
            names = app.T.Properties.VariableNames;
            app.FileLabel.Text = f;

            % Column drop-downs list the column names; Value is the column number
            app.Column1DropDown.Items = names;
            app.Column1DropDown.ItemsData = 1:numel(names);
            app.Column2DropDown.Items = names;
            app.Column2DropDown.ItemsData = 1:numel(names);
            app.Column2DropDown.Value = min(2, numel(names));
        end

        % Button pushed function: LoadTextFileButton
        function LoadTextFileButtonPushed(app, event)
            [f,p] = uigetfile('*.txt');

            if isequal(f,0)
                return;
            end

            app.Text = fileread(fullfile(p,f));
            app.FileLabel.Text = f;
            app.PlotTypeDropDown.Value = 'Word Cloud';
            updateColumnLabels(app);
        end

        % Value changed function: PlotTypeDropDown
        function PlotTypeDropDownValueChanged(app, event)
            updateColumnLabels(app);
        end

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
            delete(app.PlotPanel.Children);
            app.StatsLabel.Text = '';
            plotType = app.PlotTypeDropDown.Value;

            % Word cloud from the text file
            if strcmp(plotType, 'Word Cloud')
                if isempty(app.Text)
                    uialert(app.UIFigure, 'Please load a text file first.', 'No Text File');
                    return;
                end
                t = replace(app.Text,[".","?","!",",",";",":"]," ");
                w = split(t);
                w = w(w ~= "");
                wc = wordcloud(app.PlotPanel, categorical(w));
                wc.Title = 'Word Cloud';
                return;
            end

            if isempty(app.T)
                uialert(app.UIFigure, 'Please load a CSV file first.', 'No CSV File');
                return;
            end

            T = app.T;
            a = app.Column1DropDown.Value;
            b = app.Column2DropDown.Value;

            % Geographic plot needs geographic axes
            if strcmp(plotType, 'Geographic Plot')
                gx = geoaxes(app.PlotPanel);
                geoplot(gx, T{:,a}, T{:,b}, 'r-o');
                geobasemap(gx, 'streets');
                title(gx, 'Geographic Plot');
                return;
            end

            ax = uiaxes(app.PlotPanel);
            ax.Position = [10 10 600 480];

            switch plotType
                case 'Bar Plot'
                    bar(ax, T{:,b});
                    xticks(ax, 1:height(T));
                    xticklabels(ax, string(T{:,a}));

                case 'Line Plot'
                    plot(ax, T{:,a}, T{:,b}, '-o');
                    xlabel(ax, T.Properties.VariableNames{a});
                    ylabel(ax, T.Properties.VariableNames{b});
                    grid(ax, 'on');

                case 'Scatter Plot'
                    scatter(ax, T{:,a}, T{:,b}, 'filled');
                    xlabel(ax, T.Properties.VariableNames{a});
                    ylabel(ax, T.Properties.VariableNames{b});
                    grid(ax, 'on');

                case 'Box Plot'
                    boxchart(ax, T{:,b});
                    ylabel(ax, T.Properties.VariableNames{b});
                    grid(ax, 'on');

                case 'Histogram'
                    d = T{:,b};
                    histogram(ax, d);
                    xlabel(ax, T.Properties.VariableNames{b});
                    ylabel(ax, 'Frequency');
                    app.StatsLabel.Text = sprintf('Mean %.2f Median %.2f Std %.2f Min %.2f Max %.2f', ...
                        mean(d), median(d), std(d), min(d), max(d));

                case 'Pie Chart'
                    pie(ax, T{:,b}, cellstr(string(T{:,a})));
            end

            title(ax, plotType);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 900 560];
            app.UIFigure.Name = 'Plotting from CSV';

            % Create PlotPanel
            app.PlotPanel = uipanel(app.UIFigure);
            app.PlotPanel.Position = [250 20 630 520];

            % Create LoadCSVButton
            app.LoadCSVButton = uibutton(app.UIFigure, 'push');
            app.LoadCSVButton.ButtonPushedFcn = createCallbackFcn(app, @LoadCSVButtonPushed, true);
            app.LoadCSVButton.Position = [20 510 210 23];
            app.LoadCSVButton.Text = 'Load CSV';

            % Create LoadTextFileButton
            app.LoadTextFileButton = uibutton(app.UIFigure, 'push');
            app.LoadTextFileButton.ButtonPushedFcn = createCallbackFcn(app, @LoadTextFileButtonPushed, true);
            app.LoadTextFileButton.Position = [20 475 210 23];
            app.LoadTextFileButton.Text = 'Load Text File';

            % Create FileLabel
            app.FileLabel = uilabel(app.UIFigure);
            app.FileLabel.Position = [20 440 210 22];
            app.FileLabel.Text = 'No file loaded';

            % Create PlotTypeDropDownLabel
            app.PlotTypeDropDownLabel = uilabel(app.UIFigure);
            app.PlotTypeDropDownLabel.HorizontalAlignment = 'right';
            app.PlotTypeDropDownLabel.Position = [20 395 60 22];
            app.PlotTypeDropDownLabel.Text = 'Plot';

            % Create PlotTypeDropDown
            app.PlotTypeDropDown = uidropdown(app.UIFigure);
            app.PlotTypeDropDown.Items = {'Bar Plot', 'Line Plot', 'Scatter Plot', 'Box Plot', 'Histogram', 'Pie Chart', 'Geographic Plot', 'Word Cloud'};
            app.PlotTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @PlotTypeDropDownValueChanged, true);
            app.PlotTypeDropDown.Position = [90 395 140 22];
            app.PlotTypeDropDown.Value = 'Bar Plot';

            % Create Column1DropDownLabel
            app.Column1DropDownLabel = uilabel(app.UIFigure);
            app.Column1DropDownLabel.HorizontalAlignment = 'right';
            app.Column1DropDownLabel.Position = [20 355 60 22];
            app.Column1DropDownLabel.Text = 'Labels';

            % Create Column1DropDown
            app.Column1DropDown = uidropdown(app.UIFigure);
            app.Column1DropDown.Items = {};
            app.Column1DropDown.Position = [90 355 140 22];

            % Create Column2DropDownLabel
            app.Column2DropDownLabel = uilabel(app.UIFigure);
            app.Column2DropDownLabel.HorizontalAlignment = 'right';
            app.Column2DropDownLabel.Position = [20 315 60 22];
            app.Column2DropDownLabel.Text = 'Values';

            % Create Column2DropDown
            app.Column2DropDown = uidropdown(app.UIFigure);
            app.Column2DropDown.Items = {};
            app.Column2DropDown.Position = [90 315 140 22];

            % Create PlotButton
            app.PlotButton = uibutton(app.UIFigure, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.Position = [20 270 210 23];
            app.PlotButton.Text = 'Plot';

            % Create StatsLabel
            app.StatsLabel = uilabel(app.UIFigure);
            app.StatsLabel.VerticalAlignment = 'top';
            app.StatsLabel.WordWrap = 'on';
            app.StatsLabel.Position = [20 170 210 80];
            app.StatsLabel.Text = '';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = PlottingFromCSV_exported

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
