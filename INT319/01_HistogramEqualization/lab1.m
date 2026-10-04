classdef lab1 < matlab.apps.AppBase
   % Properties that correspond to app components
   properties (Access = public)
       UIFigure         matlab.ui.Figure
       HistogramButton  matlab.ui.control.Button
       UploadButton     matlab.ui.control.Button
       UIAxes3          matlab.ui.control.UIAxes
       UIAxes2          matlab.ui.control.UIAxes
       UIAxes           matlab.ui.control.UIAxes
   end
   % Callbacks that handle component events
   methods (Access = private)
       % Button pushed function: UploadButton
       function UploadButtonPushed(app, event)
           global I;
           [filename,filepath]=uigetfile({'*.*;*.jpg;*.png;*.oct;*.bmp'},'Select file to open');
           if isequal(filename,0)
               return;
           end
           image=[filepath,filename];
           I=imread(image);
           imagesc(app.UIAxes3,I);
       end
       % Button down function: UIAxes3
       function UIAxes3ButtonDown(app, event)
           I = imread('peppers.png');
       end
       % Button down function: UIAxes
       function UIAxesButtonDown(app, event)
           global I;
           if isempty(I)
               return;
           end
           % Convert RGB to grayscale if necessary
           if size(I,3) == 3
               I = rgb2gray(I);
           end
           % Histogram Equalization
           I_histeq = histeq(I);
           % Adaptive Histogram Equalization (CLAHE)
           I_adapthisteq = adapthisteq(I);
       end
       % Button pushed function: HistogramButton
       function HistogramButtonPushed(app, event)
           global I;
           if isempty(I)
               return;
           end
           % Convert RGB to grayscale if necessary
           if size(I,3) == 3
               I = rgb2gray(I);
           end
           % Histogram Equalization
           I_histeq = histeq(I);
           % Adaptive Histogram Equalization (CLAHE)
           I_adapthisteq = adapthisteq(I);
           imagesc(app.UIAxes,I_histeq);
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
           title(app.UIAxes, 'Title')
           xlabel(app.UIAxes, 'X')
           ylabel(app.UIAxes, 'Y')
           zlabel(app.UIAxes, 'Z')
           app.UIAxes.ButtonDownFcn = createCallbackFcn(app, @UIAxesButtonDown, true);
           app.UIAxes.Position = [213 10 416 223];
           % Create UIAxes2
           app.UIAxes2 = uiaxes(app.UIFigure);
           title(app.UIAxes2, 'Title')
           xlabel(app.UIAxes2, 'X')
           ylabel(app.UIAxes2, 'Y')
           zlabel(app.UIAxes2, 'Z')
           app.UIAxes2.Position = [-165 743 2 2];
           % Create UIAxes3
           app.UIAxes3 = uiaxes(app.UIFigure);
           title(app.UIAxes3, 'Title')
           xlabel(app.UIAxes3, 'X')
           ylabel(app.UIAxes3, 'Y')
           zlabel(app.UIAxes3, 'Z')
           app.UIAxes3.ButtonDownFcn = createCallbackFcn(app, @UIAxes3ButtonDown, true);
           app.UIAxes3.Position = [213 242 417 239];
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
       function app = lab1
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
