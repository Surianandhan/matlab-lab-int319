classdef DeepLearningClassification_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        AccuracyLabel        matlab.ui.control.Label
        RunButton            matlab.ui.control.Button
        SelectDatasetButton  matlab.ui.control.Button
        UIAxes               matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        DatasetPath % Folder with one subfolder per class
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: SelectDatasetButton
        function SelectDatasetButtonPushed(app, event)
            folder = uigetdir(pwd, 'Select Sign Dataset Folder');

            if isequal(folder, 0)
                return;
            end

            app.DatasetPath = folder;
            app.AccuracyLabel.Text = 'Dataset selected. Click Run.';
        end

        % Button pushed function: RunButton
        function RunButtonPushed(app, event)
            % Check whether a dataset folder has been selected
            if isempty(app.DatasetPath) || ~isfolder(app.DatasetPath)
                uialert(app.UIFigure, ...
                    'Please select the dataset folder first.', ...
                    'Dataset Error');
                return;
            end
        
            % Load the image dataset
            imds = imageDatastore(app.DatasetPath, ...
                'IncludeSubfolders', true, ...
                'LabelSource', 'foldernames');
        
            % Check whether the dataset contains images
            if isempty(imds.Files)
                uialert(app.UIFigure, ...
                    'The selected folder contains no images.', ...
                    'Dataset Error');
                return;
            end
        
            % Count the images in each class
            classCounts = countEachLabel(imds);
        
            % Check that every class has at least two images
            if any(classCounts.Count < 2)
                uialert(app.UIFigure, ...
                    'Each class must contain at least two images.', ...
                    'Dataset Error');
                return;
            end
        
            % Determine the number of classes automatically
            numClasses = numel(categories(imds.Labels));
        
            % Split the dataset into training and validation sets
            [imdsTrainOriginal, imdsValidationOriginal] = ...
                splitEachLabel(imds, 0.8, 'randomized');
        
            % Resize images to 124 x 124 pixels
            imdsTrain = augmentedImageDatastore( ...
                [124 124], imdsTrainOriginal, ...
                'ColorPreprocessing', 'gray2rgb');
        
            imdsValidation = augmentedImageDatastore( ...
                [124 124], imdsValidationOriginal, ...
                'ColorPreprocessing', 'gray2rgb');
        
            % Define the CNN architecture
            layers = [
                imageInputLayer([124 124 3])
        
                convolution2dLayer(3, 8, 'Padding', 'same')
                batchNormalizationLayer
                reluLayer
        
                maxPooling2dLayer(2, 'Stride', 2)
        
                convolution2dLayer(3, 16, 'Padding', 'same')
                batchNormalizationLayer
                reluLayer
        
                maxPooling2dLayer(2, 'Stride', 2)
        
                convolution2dLayer(3, 32, 'Padding', 'same')
                batchNormalizationLayer
                reluLayer
        
                fullyConnectedLayer(numClasses)
                softmaxLayer
                classificationLayer
            ];
        
            % Configure training options
            options = trainingOptions('sgdm', ...
                'MiniBatchSize', 32, ...
                'MaxEpochs', 50, ...
                'InitialLearnRate', 1e-4, ...
                'Shuffle', 'every-epoch', ...
                'ValidationData', imdsValidation, ...
                'ValidationFrequency', 3, ...
                'Plots', 'training-progress', ...
                'Verbose', false);
        
            % Train the CNN model
            net = trainNetwork(imdsTrain, layers, options);
        
            % Predict the validation image classes
            YPred = classify(net, imdsValidation);
        
            % Get the actual validation labels
            YValidation = imdsValidationOriginal.Labels;
        
            % Calculate validation accuracy
            accuracy = mean(YPred == YValidation) * 100;
        
            % Display accuracy in the app
            app.AccuracyLabel.Text = sprintf( ...
                'Validation Accuracy: %.2f%%', accuracy);
        
            % Generate the confusion matrix
            classNames = categories(imds.Labels);
        
            confMat = confusionmat(YValidation, YPred, ...
                'Order', categorical(classNames));
        
            % Display confusion matrix in UIAxes
            cla(app.UIAxes);
        
            imagesc(app.UIAxes, confMat);
            colorbar(app.UIAxes);
        
            title(app.UIAxes, 'CNN Confusion Matrix');
            xlabel(app.UIAxes, 'Predicted Class');
            ylabel(app.UIAxes, 'Actual Class');
        
            % Set axis labels
            app.UIAxes.XTick = 1:numClasses;
            app.UIAxes.YTick = 1:numClasses;
        
            app.UIAxes.XTickLabel = classNames;
            app.UIAxes.YTickLabel = classNames;
        
            app.UIAxes.XTickLabelRotation = 45;
        
            axis(app.UIAxes, 'equal');
            axis(app.UIAxes, 'tight');
        
            % Display matrix values inside each cell
            for row = 1:size(confMat, 1)
                for col = 1:size(confMat, 2)
        
                    text(app.UIAxes, col, row, ...
                        num2str(confMat(row, col)), ...
                        'HorizontalAlignment', 'center', ...
                        'Color', 'w');
        
                end
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
            app.UIFigure.Name = 'Image Classification using Deep Learning';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [47 127 547 337];

            % Create SelectDatasetButton
            app.SelectDatasetButton = uibutton(app.UIFigure, 'push');
            app.SelectDatasetButton.ButtonPushedFcn = createCallbackFcn(app, @SelectDatasetButtonPushed, true);
            app.SelectDatasetButton.Position = [83 74 100 23];
            app.SelectDatasetButton.Text = 'Select Dataset';

            % Create RunButton
            app.RunButton = uibutton(app.UIFigure, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.Position = [440 74 100 23];
            app.RunButton.Text = 'Run';

            % Create AccuracyLabel
            app.AccuracyLabel = uilabel(app.UIFigure);
            app.AccuracyLabel.HorizontalAlignment = 'center';
            app.AccuracyLabel.Position = [83 31 511 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = DeepLearningClassification_exported

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
