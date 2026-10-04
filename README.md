# MATLAB Programming Lab (INT319)

This repository contains MATLAB Programming lab programs implemented as MATLAB scripts and App Designer applications as part of the INT319 course.

## Overview

The programs demonstrate image processing and data visualization in MATLAB, including contrast enhancement, smoothing and sharpening filters, morphological operations, thresholding, plotting data from files, statistical and texture feature extraction, edge detection, clustering-based segmentation, and image classification with machine learning.

## Topics Covered

### Image Enhancement
- Histogram equalization with histeq() in an App Designer GUI
- Noise removal with Mean, Median, Wiener and Gaussian filters
- Sharpening with imsharpen, Unsharp Mask, Laplacian, LoG, Gaussian and Sobel filters

### Morphology and Segmentation
- Erosion, Dilation, Opening, Closing, Morphological Gradient, Top-hat and Bottom-hat
- Otsu, fixed, adaptive, multilevel and inverted thresholding
- Colour image clustering with K-Means, Fuzzy C-Means and K-Medoids

### Feature Extraction and Edge Detection
- First-order statistical features (mean, median, standard deviation, variance, skewness, kurtosis, RMS, entropy, energy, coefficient of variation)
- GLCM texture features (contrast, correlation, energy, homogeneity)
- Sobel, Prewitt, Roberts, Laplacian of Gaussian, Canny and Zero-Crossing edge detectors

### Data Visualization
- Reading CSV and text files with readtable() and fileread()
- Bar, line, scatter, box, histogram, pie and geographic plots
- Word clouds from text

### Machine Learning
- HOG feature extraction from an image datastore
- Neural network classifier (fitcnet), accuracy and confusion matrix

## Project Structure

```
matlab-lab-int319/
│
├── INT319/
│   ├── 01_HistogramEqualization/
│   ├── 02_SmootheningFilters/
│   ├── 03_SharpeningFilters/
│   ├── 04_ImageMorphology/
│   ├── 05_ImageThresholding/
│   ├── 06_PlottingFromCSV/
│   ├── 07_StatisticalFeatures/
│   ├── 08_EdgeDetection/
│   ├── 09_ImageClustering/
│   └── 10_ImageClassification/
│
└── README.md
```

Each folder contains the App Designer app (a `classdef` `.m` file) or script(s) for one experiment.

## How to Run

1. Open MATLAB (R2021a or later) and set an experiment folder as the **Current Folder**.
2. Type the file name in the Command Window and press Enter:

| Experiment | Run |
|---|---|
| 01 Histogram Equalization | `lab1` |
| 02 Smoothening Filters | `smoothening_filters` |
| 03 Sharpening Filters | `app4` (app), `sharpening_demo` (script) |
| 04 Image Morphology | `MorphologyApp` |
| 05 Image Thresholding | `app5_thresholding` |
| 06 Plotting from CSV | `bar_plot`, `line_plot`, `scatter_plot`, `box_plot`, `histogram_stats`, `pie_chart`, `geographic_plot`, `word_cloud` |
| 07 Statistical Features | `app6` |
| 08 Edge Detection | `exp8` |
| 09 Image Clustering | `app9` |
| 10 Image Classification | `app10` |

3. In the apps, use the Upload / Browse button to pick any image (MATLAB sample images such as `peppers.png` are in `matlabroot/toolbox/images/imdata`).

> Note: All image experiments need the **Image Processing Toolbox**. Experiments 06 (box plot), 07, 09 and 10 also need the **Statistics and Machine Learning Toolbox**, Experiment 09 needs the **Fuzzy Logic Toolbox** (`fcm`), and Experiment 10 needs the **Computer Vision Toolbox** (`extractHOGFeatures`).
>
> Experiment 06: select `sample_data.csv` (columns: 1 ID, 2 City, 3 Latitude, 4 Longitude, 5 Temperature, 6 AQI) or `sample_text.txt` for the word cloud, then enter column numbers when prompted. The geographic plot needs an internet connection for the basemap.
>
> Experiment 10: select a dataset folder that has one subfolder per class (the subfolder names become the labels). Keep the dataset small — HOG with 4×4 cells on 224×224 images gives about 108,900 features per image.

## Purpose

- Learn MATLAB scripting and GUI development with App Designer
- Apply image enhancement, segmentation and feature extraction techniques
- Visualize data read from external files
- Build and evaluate a simple image classifier

## Notes

The code was extracted from the lab records (lines wrapped by the PDF were re-joined) and corrected so it runs on current MATLAB versions:
- Experiment 01: the equalized image was drawn into a 2×2-pixel axes placed off-screen, so it never appeared; the uploaded image now shows in the top axes and the result in the bottom axes, as in the record's output. Cancelling the file dialog, pressing Histogram before uploading, and clicking the lower axes (its callback used `I` without `global I`) no longer throw errors
- Experiment 03: `sharpening_demo.m` holds the imsharpen steps from the record's procedure; a `figure;` was added so the `rice.png` step no longer draws over the sharpened image from step 2
- Experiment 04: the record only had the code-view part of the app; the `classdef`, UI components, constructor and `delete` method were added (layout taken from the record's screenshots) so it runs
- Experiment 05: choosing a method before loading an image no longer throws an error
- Experiment 06: the eight plots are split into separate scripts, and `sample_data.csv` / `sample_text.txt` were added (the histogram of the AQI column reproduces the statistics printed in the record)
- Experiment 08: the "Please load an image first!" warning now appears; reading `Children.CData` from the empty axes used to fail first and show a generic error dialog
- Experiment 09: grayscale images are converted to 3 channels before clustering (`reshape(img, [], 3)` failed on them)

## Future Improvements

- Add screenshots of outputs for each experiment
- Provide the App Designer `.mlapp` files
- Add comments explaining each program

## Author

Surianandhan Sridhar
