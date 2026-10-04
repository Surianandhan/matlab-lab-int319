classdef app9 < matlab.apps.AppBase
   % Properties that correspond to app components
   properties (Access = public)
       UIFigure       matlab.ui.Figure
       DropDown       matlab.ui.control.DropDown
       DropDownLabel  matlab.ui.control.Label
       ClearButton    matlab.ui.control.Button
       UploadButton   matlab.ui.control.Button
       UIAxes2        matlab.ui.control.UIAxes
       UIAxes         matlab.ui.control.UIAxes
   end

   properties (Access = private)
       OriginalImage % Description
   end

   methods (Access = private)
       function applyClustering(app)
           if isempty(app.OriginalImage)
               return;
           end
           img = imresize(app.OriginalImage, 0.5);
           if size(img, 3) == 1
               img = repmat(img, 1, 1, 3);
           end
           data = double(reshape(img, [], 3));
           k = 3;
           method = app.DropDown.Value;
           switch method
               case 'K-Means'
                   [idx, ~] = kmeans(data, k, ...
                       'MaxIter', 100, ...
                       'Replicates', 3);
                   result = reshape(idx, size(img,1), size(img,2));
               case 'Fuzzy C-Means'
                   [~, U] = fcm(data, k);
                   [~, idx] = max(U);
                   result = reshape(idx, size(img,1), size(img,2));
               case 'K-Medoids'
                   [idx, ~] = kmedoids(data, k);
                   result = reshape(idx, size(img,1), size(img,2));
               otherwise
                   result = img;
           end
           imagesc(app.UIAxes2, result);
           axis(app.UIAxes2, 'image');
           axis(app.UIAxes2, 'off');
           title(app.UIAxes2, method);
           colormap(app.UIAxes2, jet);
       end
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
           applyClustering(app);
       end
       % Value changed function: DropDown
       function DropDownValueChanged(app, event)
           applyClustering(app);
       end
       % Button pushed function: ClearButton
       function ClearButtonPushed(app, event)
           cla(app.UIAxes);
           cla(app.UIAxes2);
           title(app.UIAxes, 'Original Image');
           title(app.UIAxes2, 'Clustering Result');
           app.OriginalImage = [];
           app.DropDown.Value = 'K-Means';
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
           title(app.UIAxes, 'Original Image')
           xlabel(app.UIAxes, 'X')
           ylabel(app.UIAxes, 'Y')
           zlabel(app.UIAxes, 'Z')
           app.UIAxes.Position = [9 253 333 214];
           % Create UIAxes2
           app.UIAxes2 = uiaxes(app.UIFigure);
           title(app.UIAxes2, 'K Means')
           xlabel(app.UIAxes2, 'X')
           ylabel(app.UIAxes2, 'Y')
           zlabel(app.UIAxes2, 'Z')
           app.UIAxes2.Position = [308 18 321 205];
           % Create UploadButton
           app.UploadButton = uibutton(app.UIFigure, 'push');
           app.UploadButton.ButtonPushedFcn = createCallbackFcn(app, @UploadButtonPushed, true);
           app.UploadButton.Position = [419 407 100 23];
           app.UploadButton.Text = 'Upload';
           % Create ClearButton
           app.ClearButton = uibutton(app.UIFigure, 'push');
           app.ClearButton.ButtonPushedFcn = createCallbackFcn(app, @ClearButtonPushed, true);
           app.ClearButton.Position = [419 327 100 23];
           app.ClearButton.Text = 'Clear';
           % Create DropDownLabel
           app.DropDownLabel = uilabel(app.UIFigure);
           app.DropDownLabel.HorizontalAlignment = 'right';
           app.DropDownLabel.Position = [86 134 66 22];
           app.DropDownLabel.Text = 'Drop Down';
           % Create DropDown
           app.DropDown = uidropdown(app.UIFigure);
           app.DropDown.Items = {'K-Means', 'Fuzzy C-Means', 'K-Medoids'};
           app.DropDown.ValueChangedFcn = createCallbackFcn(app, @DropDownValueChanged, true);
           app.DropDown.Position = [167 134 100 22];
           app.DropDown.Value = 'K-Means';
           % Show the figure after all components are created
           app.UIFigure.Visible = 'on';
       end
   end
   % App creation and deletion
   methods (Access = public)
       % Construct app
       function app = app9
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
