classdef app10 < matlab.apps.AppBase
   % Properties that correspond to app components
   properties (Access = public)
       UIFigure             matlab.ui.Figure
       AccuracyLabel        matlab.ui.control.Label
       RunButton            matlab.ui.control.Button
       SelectDatasetButton  matlab.ui.control.Button
       UIAxes               matlab.ui.control.UIAxes
   end

   properties (Access = private)
       DatasetPath % Description
   end

   % Callbacks that handle component events
   methods (Access = private)
       % Button pushed function: SelectDatasetButton
       function SelectDatasetButtonPushed(app, event)
           folder = uigetdir;
           if folder ~= 0
               app.DatasetPath = folder;
           end
       end
       % Button pushed function: RunButton
       function RunButtonPushed(app, event)
           if isempty(app.DatasetPath)
               uialert(app.UIFigure, ...
                   'Please select the dataset folder first.', ...
                   'Error');
               return;
           end
           % Load dataset
           imds = imageDatastore(app.DatasetPath, ...
               'IncludeSubfolders', true, ...
               'LabelSource', 'foldernames');
           % Split dataset
           [trainingSet, testSet] = splitEachLabel(imds, 0.8, 'randomized');
           % HOG feature settings
           cellSize = [4 4];
           % Read first image
           img = readimage(trainingSet, 1);
           img = imresize(img, [224 224]);
           img = im2gray(img);
           % Extract HOG features
           hogFeature = extractHOGFeatures(img, ...
               'CellSize', cellSize);
           hogFeatureSize = length(hogFeature);
           % Training features
           numImages = numel(trainingSet.Files);
           trainingFeatures = zeros(numImages, hogFeatureSize, 'single');
           for i = 1:numImages
               img1 = readimage(trainingSet, i);
               img1 = imresize(img1, [224 224]);
               img1 = im2gray(img1);
               trainingFeatures(i, :) = extractHOGFeatures(img1, ...
                   'CellSize', cellSize);
           end
           trainingLabels = trainingSet.Labels;
           % Train classifier
           classifier = fitcnet(trainingFeatures, trainingLabels);
           % Testing features
           numTest = numel(testSet.Files);
           testFeatures = zeros(numTest, hogFeatureSize, 'single');
           for j = 1:numTest
               imgTest = readimage(testSet, j);
               imgTest = imresize(imgTest, [224 224]);
               imgTest = im2gray(imgTest);
               testFeatures(j, :) = extractHOGFeatures(imgTest, ...
                   'CellSize', cellSize);
           end
           testLabels = testSet.Labels;
           % Predict
           predictedLabels = predict(classifier, testFeatures);
           % Calculate accuracy
           accuracy = mean(predictedLabels == testLabels) * 100;

           % Display accuracy in the app
           app.AccuracyLabel.Text = sprintf('Classification Accuracy: %.2f%%', accuracy);
           % Confusion matrix
           confMat = confusionmat(testLabels, predictedLabels);

           % Display confusion matrix in UIAxes
           cla(app.UIAxes);

           imagesc(app.UIAxes, confMat);

           colorbar(app.UIAxes);
           xlabel(app.UIAxes, 'Predicted Label');
           ylabel(app.UIAxes, 'True Label');

           title(app.UIAxes, 'Confusion Matrix');

           axis(app.UIAxes, 'equal');
           axis(app.UIAxes, 'tight');

           % Add values inside each cell
           for row = 1:size(confMat, 1)
               for col = 1:size(confMat, 2)
                   text(app.UIAxes, col, row, ...
                       num2str(confMat(row, col)), ...
                       'HorizontalAlignment', 'center');
               end
           end

           % Set labels
           classes = categories(testLabels);

           app.UIAxes.XTick = 1:length(classes);
           app.UIAxes.YTick = 1:length(classes);

           app.UIAxes.XTickLabel = classes;
           app.UIAxes.YTickLabel = classes;
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
           title(app.UIAxes, 'Classifier')
           xlabel(app.UIAxes, 'X')
           ylabel(app.UIAxes, 'Y')
           zlabel(app.UIAxes, 'Z')
           app.UIAxes.Position = [51 132 540 330];
           % Create SelectDatasetButton
           app.SelectDatasetButton = uibutton(app.UIFigure, 'push');
           app.SelectDatasetButton.ButtonPushedFcn = createCallbackFcn(app, @SelectDatasetButtonPushed, true);
           app.SelectDatasetButton.Position = [102 78 100 23];
           app.SelectDatasetButton.Text = 'Dataset Upload';
           % Create RunButton
           app.RunButton = uibutton(app.UIFigure, 'push');
           app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
           app.RunButton.Position = [436 78 100 23];
           app.RunButton.Text = 'Run';
           % Create AccuracyLabel
           app.AccuracyLabel = uilabel(app.UIFigure);
           app.AccuracyLabel.HorizontalAlignment = 'center';
           app.AccuracyLabel.Position = [201 30 236 22];
           app.AccuracyLabel.Text = 'Accuracy: --';
           % Show the figure after all components are created
           app.UIFigure.Visible = 'on';
       end
   end
   % App creation and deletion
   methods (Access = public)
       % Construct app
       function app = app10
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
