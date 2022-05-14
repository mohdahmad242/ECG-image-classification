# ECG image classification
***
The ECG classification was done between four distinct categories of Cardiac Patients having - 
1. Abnormal Heartbeat
2. Myocardial Infarction (MI) 
3. Previous History of MI 
4. Normal Person

## Model training and dataset preparation.
1. Border texts were removed before training.
2. Images were resized to `512x512` from there original size.
3. `Pre-trained SqueezeNet with three additional CNN` layers were used.
4. SqueezeNet model weights were freezed only additional 3 CNN layers were trained. 
5. Finally the model weights were saved in `.pth` file and successively converted into mobile optimized model with `.pt` extention.

Dataset - [https://data.mendeley.com/datasets/gwbz3fsgp8/2](https://data.mendeley.com/datasets/gwbz3fsgp8/2)  
Jupyter Notebook of ECG image classification model - [Link](https://github.com/mohdahmad242/ECG-image-classification/blob/main/ECG_Images_Classification.ipynb)
***
Live demo - 
<video src='https://user-images.githubusercontent.com/36775905/168422931-ec6c4912-4e73-4d78-93e2-0789daa832b0.mp4' width=180/>





