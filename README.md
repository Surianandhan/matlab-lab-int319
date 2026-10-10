# MATLAB Programming Lab (INT319)

This repository contains MATLAB Programming lab programs implemented as MATLAB App Designer applications as part of the INT319 course.

## Overview

The programs demonstrate image processing and data visualization in MATLAB, including contrast enhancement, smoothing and sharpening filters, morphological operations, thresholding, plotting data from files, statistical and texture feature extraction, edge detection, clustering-based segmentation, colour image processing, and image classification with machine learning and deep learning (CNN). Every experiment is provided in two versions: an App Designer file (`.mlapp`) and the same app as a plain MATLAB code file (`.m`).

## Topics Covered

### Image Enhancement
- Histogram equalization with histeq()
- Noise removal with Mean, Median, Wiener and Gaussian filters on Salt & Pepper or Gaussian noise
- Sharpening with imsharpen, Unsharp Mask, Laplacian, LoG, Gaussian and Sobel filters

### Morphology and Segmentation
- Erosion, Dilation, Opening, Closing, Morphological Gradient, Top-hat and Bottom-hat
- Otsu, fixed, adaptive, multilevel and inverted thresholding
- Colour image clustering with K-Means, Fuzzy C-Means and K-Medoids

### Colour Image Processing
- Splitting an RGB image into its red, green and blue planes
- Sharpening each channel separately with imsharpen and recombining them into the final RGB image
- Showing the original, the planes, the processed channels and the result together with montage()

### Feature Extraction and Edge Detection
- First-order statistical features (mean, median, standard deviation, variance, skewness, kurtosis, RMS, entropy, energy, coefficient of variation)
- GLCM texture features (contrast, correlation, energy, homogeneity)
- Sobel, Prewitt, Roberts, Laplacian of Gaussian, Canny and Zero-Crossing edge detectors

### Data Visualization
- Reading CSV and text files with readtable() and fileread()
- Bar, line, scatter, box, histogram, pie and geographic plots
- Word clouds from text

### Machine Learning and Deep Learning
- HOG feature extraction from an image datastore
- Neural network classifier (fitcnet), accuracy and confusion matrix
- Convolutional neural network (convolution, batch normalization, ReLU, max pooling, fully connected and softmax layers) trained with trainNetwork and SGDM
- Validation accuracy, training-progress plot and CNN confusion matrix

## Project Structure

```
matlab-lab-int319/
│
├── INT319/
│   ├── 01_HistogramEqualization/
│   ├── 02_SmoothingFilters/
│   ├── 03_SharpeningFilters/
│   ├── 04_ImageMorphology/
│   ├── 05_ImageThresholding/
│   ├── 06_PlottingFromCSV/
│   ├── 07_StatisticalFeatures/
│   ├── 08_EdgeDetection/
│   ├── 09_ImageClustering/
│   ├── 10_ImageClassification/
│   ├── 11_ColourImageProcessing/
│   └── 12_DeepLearningClassification/
│
└── README.md
```

Each experiment folder contains two versions of the same app:
- `<Name>.mlapp` — the App Designer file (open it in App Designer to see the layout and edit callbacks)
- `<Name>_exported.m` — the same app as a plain MATLAB class file (App Designer's "Export to .m file" format)

## How to Run

1. Open MATLAB (R2021a or later) and set an experiment folder as the **Current Folder**.
2. Run either version from the Command Window:

| Experiment | App Designer version | Code version |
|---|---|---|
| 01 Histogram Equalization | `HistogramEqualization` | `HistogramEqualization_exported` |
| 02 Smoothing Filters | `SmoothingFilters` | `SmoothingFilters_exported` |
| 03 Sharpening Filters | `SharpeningFilters` | `SharpeningFilters_exported` |
| 04 Image Morphology | `ImageMorphology` | `ImageMorphology_exported` |
| 05 Image Thresholding | `ImageThresholding` | `ImageThresholding_exported` |
| 06 Plotting from CSV | `PlottingFromCSV` | `PlottingFromCSV_exported` |
| 07 Statistical Features | `StatisticalFeatures` | `StatisticalFeatures_exported` |
| 08 Edge Detection | `EdgeDetection` | `EdgeDetection_exported` |
| 09 Image Clustering | `ImageClustering` | `ImageClustering_exported` |
| 10 Image Classification | `ImageClassification` | `ImageClassification_exported` |
| 11 Colour Image Processing | `ColourImageProcessing` | `ColourImageProcessing_exported` |
| 12 Deep Learning Classification | `DeepLearningClassification` | `DeepLearningClassification_exported` |

   To edit an app, double-click the `.mlapp` file (or run `appdesigner('<Name>.mlapp')`).

3. In the apps, use the Upload / Browse / Select Image button to pick any image (MATLAB sample images such as `peppers.png`, `eight.tif` and `saturn.png` are in `matlabroot/toolbox/images/imdata`).

> Note: All image experiments need the **Image Processing Toolbox**. Experiments 07, 09 and 10 also need the **Statistics and Machine Learning Toolbox**, Experiment 09 needs the **Fuzzy Logic Toolbox** (`fcm`), and Experiment 10 needs the **Computer Vision Toolbox** (`extractHOGFeatures`). Experiment 12 needs the **Deep Learning Toolbox**.
>
> Experiment 06: click **Load CSV** and pick `sample_data.csv` (or **Load Text File** and pick `sample_text.txt` for the word cloud), choose the plot type and columns, then click **Plot**. The geographic plot needs an internet connection for the basemap.
>
> Experiment 10: select a dataset folder that has one subfolder per class (the subfolder names become the labels). Keep the dataset small — HOG with 4×4 cells on 224×224 images gives about 108,900 features per image.
>
> Experiment 12: select a dataset folder with one subfolder per class (at least two images per class); images are resized to 124×124 and 80% are used for training. Training runs for 50 epochs and opens MATLAB's training-progress window; the validation accuracy and confusion matrix then appear in the app.

## Purpose

- Learn MATLAB programming and GUI development with App Designer
- Apply image enhancement, segmentation and feature extraction techniques
- Visualize data read from external files
- Build and evaluate a simple image classifier and a convolutional neural network

## Notes

The code was extracted from the lab records and reorganised so every experiment is an App Designer app with a `.mlapp` and an exported `.m` version:
- Files and classes were renamed after the experiment (e.g. `lab1` → `HistogramEqualization`, `app4` → `SharpeningFilters`, `app6` → `StatisticalFeatures`, `exp8` → `EdgeDetection`), with proper window titles and labels ("Method", "Operation", "Noise", "Filter") instead of the App Designer defaults
- Experiment 01: the equalized image was drawn into a 2×2-pixel axes placed off-screen; the unused axes and empty callbacks were removed, the uploaded image is kept in an app property instead of a `global`, and the original/result appear in the top/bottom axes as in the record's output
- Experiment 02: the record's script is now an app — load an image, pick the noise (Salt & Pepper 0.02 or Gaussian 0, 0.025) and the filter (Mean 3×3, Median, Wiener 5×5, Gaussian σ = 2); the filters and parameters are the record's
- Experiment 03: the `imsharpen` Radius 2 / Amount 1 step from the record's procedure was added to the method list
- Experiment 04: the record only had the code-view part of the app; the UI components, constructor and `delete` method were added (layout taken from the record's screenshots)
- Experiment 05: rebuilt in App Designer style; the selected method is now applied as soon as an image is loaded, and choosing a method before loading an image no longer throws an error
- Experiment 06: the record's eight plotting scripts are now one app with Load CSV / Load Text File, plot type and column drop-downs instead of `input()` prompts; the box plot uses `boxchart` (works in app axes). `sample_data.csv` and `sample_text.txt` were added — the histogram of the AQI column reproduces the statistics printed in the record
- Experiment 08: the loaded image is kept in an app property, so the "Please load an image first!" warning now appears; dialogs use `uialert` instead of `warndlg`/`errordlg`
- Experiment 09: grayscale images are converted to 3 channels before clustering (`reshape(img, [], 3)` failed on them)
- Experiment 11: the lab record for this experiment repeats Experiment 10's code, so the app was taken from the original App Designer file (`app11.mlapp`); it was renamed and the "Upload" button relabelled "Select Image"
- Experiment 12: `app12` was renamed and the "Select" button relabelled "Select Dataset". It uses `trainNetwork`/`classificationLayer` as in the record; MATLAB marks these "not recommended" since R2024a (in favour of `trainnet`), but they still run in R2026b
- The `.mlapp` files were generated with MATLAB's App Designer serializer (R2026a for Experiments 01–10, R2026b for 11–12) and checked by loading each one with App Designer's file loader and running it; they open in App Designer releases back to R2018a (the code itself needs R2021a or later)

## Future Improvements

- Add screenshots of outputs for each experiment
- Add comments explaining each program
- Let the apps save their results to image files

## Author

Surianandhan Sridhar
