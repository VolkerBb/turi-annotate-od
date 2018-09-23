# turi-annotate-od
Simple Mac App to create annotations and prepare images for Object Detection training with Turi Create

Purpose
--------------

When you need to prepare your images and add annotations for training with [Turi Create](https://github.com/apple/turicreate), you can use this little Mac App ("ImagePreparation").

## Installation

Just clone this project and run ```pod install```.
Open the created workspace in Xcode 10 on your Mac and build and run the ImagePreparation target.

## Usage

After starting up, you'll see an empty window. You can import your images now by selecting ```File -> Import Pictures...```.
For each imported picture you can now draw a bounding box and enter a label in the text field. You can save and open your ongoing work
as 'mlp' files. When you're ready to go, you can select ```File -> Export ML Data...```. 
This will export your work in a folder called MLExport. In addition, it will add a python script and [Jupyter Notebook](http://jupyter.org) file.

Note: I'm using [Anaconda](https://www.anaconda.com) with Python 3.6 and have set up a virtual environment where i installed version 5.0 of Turi Create. You can 
start Jupyter Notebook from your export folder and use the included script to train your model.

