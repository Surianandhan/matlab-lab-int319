classdef app6 < matlab.apps.AppBase
   % Properties that correspond to app components
   properties (Access = public)
       UIFigure                 matlab.ui.Figure
       FeatureExtractionButton  matlab.ui.control.Button
       UploadButton             matlab.ui.control.Button
       FeaturesTextArea         matlab.ui.control.TextArea
       FeaturesTextAreaLabel    matlab.ui.control.Label
       UIAxes                   matlab.ui.control.UIAxes
   end

   properties (Access = private)
       OriginalImage % Description
   end

   % Callbacks that handle component events
   methods (Access = private)
       % Button pushed function: UploadButton
       function UploadButtonPushed(app, event)
           [file, path] = uigetfile( ...
               {'*.jpg;*.jpeg;*.png;*.bmp;*.tif', 'Image Files'}, ...
               'Select an Image');
           if isequal(file, 0)
               return;
           end
           app.OriginalImage = imread(fullfile(path, file));
           imshow(app.OriginalImage, 'Parent', app.UIAxes);
           title(app.UIAxes, 'Original Image');
           app.FeaturesTextArea.Value = "";
       end
       % Button pushed function: FeatureExtractionButton
       function FeatureExtractionButtonPushed(app, event)
           if isempty(app.OriginalImage)
               uialert(app.UIFigure, ...
                   'Please load an image first.', ...
                   'No Image');
               return;
           end
           % Convert to grayscale
           if size(app.OriginalImage, 3) == 3
               I = rgb2gray(app.OriginalImage);
           else
               I = app.OriginalImage;
           end
           I = double(I);
           pixels = I(:);
           % ===== First-order statistical features =====
           feat.Mean = mean(pixels);
           feat.Median = median(pixels);
           feat.StandardDeviation = std(pixels);
           feat.Variance = var(pixels);
           feat.Minimum = min(pixels);
           feat.Maximum = max(pixels);
           feat.Range = feat.Maximum - feat.Minimum;
           feat.Skewness = skewness(pixels);
           feat.Kurtosis = kurtosis(pixels);
           feat.RMS = rms(pixels);
           feat.Entropy = entropy(uint8(I));
           feat.Energy = sum(pixels.^2);
           feat.CoeffOfVariation = feat.StandardDeviation / feat.Mean;
           % ===== GLCM (Second-order) features =====
           glcm = graycomatrix(uint8(I));
           stats = graycoprops(glcm, ...
               {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
           feat.GLCM_Contrast = stats.Contrast;
           feat.GLCM_Correlation = stats.Correlation;
           feat.GLCM_Energy = stats.Energy;
           feat.GLCM_Homogeneity = stats.Homogeneity;
           % ===== Display results in Text Area =====
           resultText = {
               '===== First-order Statistical Features ====='
               sprintf('Mean : %.4f', feat.Mean)
               sprintf('Median : %.4f', feat.Median)
               sprintf('Standard Deviation : %.4f', feat.StandardDeviation)
               sprintf('Variance : %.4f', feat.Variance)
               sprintf('Minimum : %.4f', feat.Minimum)
               sprintf('Maximum : %.4f', feat.Maximum)
               sprintf('Range : %.4f', feat.Range)
               sprintf('Skewness : %.4f', feat.Skewness)
               sprintf('Kurtosis : %.4f', feat.Kurtosis)
               sprintf('RMS : %.4f', feat.RMS)
               sprintf('Entropy : %.4f', feat.Entropy)
               sprintf('Energy : %.4f', feat.Energy)
               sprintf('Coeff of Variation : %.4f', feat.CoeffOfVariation)
               ' '
               '===== GLCM Texture Features ====='
               sprintf('Contrast : %.4f', feat.GLCM_Contrast)
               sprintf('Correlation : %.4f', feat.GLCM_Correlation)
               sprintf('Energy : %.4f', feat.GLCM_Energy)
               sprintf('Homogeneity : %.4f', feat.GLCM_Homogeneity)
               };
           app.FeaturesTextArea.Value = resultText;
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
           title(app.UIAxes, {''; 'image'})
           xlabel(app.UIAxes, 'X')
           ylabel(app.UIAxes, 'Y')
           zlabel(app.UIAxes, 'Z')
           app.UIAxes.Position = [1 235 351 205];
           % Create FeaturesTextAreaLabel
           app.FeaturesTextAreaLabel = uilabel(app.UIFigure);
           app.FeaturesTextAreaLabel.HorizontalAlignment = 'right';
           app.FeaturesTextAreaLabel.Position = [351 416 51 22];
           app.FeaturesTextAreaLabel.Text = 'Features';
           % Create FeaturesTextArea
           app.FeaturesTextArea = uitextarea(app.UIFigure);
           app.FeaturesTextArea.Position = [417 45 211 395];
           % Create UploadButton
           app.UploadButton = uibutton(app.UIFigure, 'push');
           app.UploadButton.ButtonPushedFcn = createCallbackFcn(app, @UploadButtonPushed, true);
           app.UploadButton.Position = [116 82 100 22];
           app.UploadButton.Text = 'Upload';
           % Create FeatureExtractionButton
           app.FeatureExtractionButton = uibutton(app.UIFigure, 'push');
           app.FeatureExtractionButton.ButtonPushedFcn = createCallbackFcn(app, @FeatureExtractionButtonPushed, true);
           app.FeatureExtractionButton.Position = [109 33 113 22];
           app.FeatureExtractionButton.Text = 'Feature Extraction';
           % Show the figure after all components are created
           app.UIFigure.Visible = 'on';
       end
   end
   % App creation and deletion
   methods (Access = public)
       % Construct app
       function app = app6
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
