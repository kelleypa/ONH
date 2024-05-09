# ONH
An approach for optic nerve head (ONH) detection and segmentation which is a necessary step in the development of automated diagnosing systems to locate anatomical components in retinal images. The proposed method is based on combination of morphological operations, an unsupervised method, and using the concept of deep learning. 

![image](https://github.com/kelleypa/ONH/assets/107891103/35b7f321-0742-42ba-9064-82b9bd8c66d6)


# Steps
1) The code begins with ONH_OPTIMALIZE_ALL.m which creates the vessel reconstruction in ONH/preprocessedImages and candidates in the image database folders, taken from five publicly available retinal image databases DRIVE, STARE, DIARETDB1, CHASE_DB1, MESSIDOR and one local MUMS-DB Database. It also needs the radon transformation (RT) of vessels code: MainVesselRT.m and LocRadVes.m. 

Reference of RT: 
* Tavakoli, Meysam, et al. "Automated microaneurysms detection in retinal images using radon transform and supervised learning: application to mass screening of diabetic retinopathy." IEEE Access 9 (2021): 67302-67314.
* Tavakoli, M., et al. "Radon transform technique for linear structures detection: application to vessel detection in fluorescein angiography fundus images." 2011 IEEE Nuclear Science Symposium Conference Record. IEEE, 2011.

3) ONH_Training.m performs supervised learning .One of our machine learning implements supervised learning, which is comprised of computing first the bag of features then categorizing this bag of features using a support vector machine (SVM).
<p align="center" width="100%">
  <img width="50%" src="https://github.com/kelleypa/ONH/assets/107891103/e0c82d5b-a3c1-400b-9078-3ab9cd24ffee">
</p>
Setting aside 20% of the training set as the training test set, a validation accuracy of 0.9282 was achieved. This means that out of the 2716 candidate images, the trained classifier tested 543 candidates to achieve an accuracy of about 92%. When viewing the confusion matrix which reveals the percentage of true and false positive detections of the ONH vs nonONH, it equally missed ONHs and nonONHs at 8% of the time. But with multiple multiple candidates that contain part or the whole ONH, this is acceptable error since the other candidates are likely to be spotted. 

![image](https://github.com/kelleypa/ONH/assets/107891103/9d375086-9eb9-4290-ad20-fe33af150b16)



4) ONH_TrainStackedAutoencoders performs unsupervised deep learning.
<p align="center" width="100%">
![neuralnet](https://github.com/kelleypa/ONH/assets/107891103/f98cf840-9b17-4d41-9c78-374c9af1497f)
</p>
  1) Input Layer: specify image size (eg in our case 28-by-28-by-1, corresponds to height, width, channel size where 1 = grayscale and 3 = RGB values)
  2) Convolutional Layer:first argumement is filter size (height and width of filter used while scanning along image), second argument is number of filters (number of neurons connecting to region of the output)
     * ReLU Layer: rectified linear unit function 
     * Max-Pooling Layer: down-sampling operation to reduce number of parameters, to avoid overfitting
     * Fully Connected Layer: last fully connected layer, combining to classify the images
  4) Softmax Layer: the last activation function for a fully connected layer to normalize the probabilistic output
  5) Classification Layer: final classification of input into one of the defined mutually exclusive classes, using the probabilities returned by softmax


The results for the deep neural network can be improved by performing back-propagation on the whole multilayer network. This process is often referred to as fine tuning.


![backpropagation](https://github.com/kelleypa/ONH/assets/107891103/96229a95-e4a6-4dbf-85f7-538c9526c8f1)




6) ONH_Segmentation.m uses the trained features or networks to do segmentation on the images.

![segmentation](https://github.com/kelleypa/ONH/assets/107891103/bd8a85aa-0ea1-40f5-9f4d-00d69e6ad001)

