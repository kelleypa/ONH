# ONH
An approach for optic nerve head (ONH) detection and segmentation which is a necessary step in the development of automated diagnosing systems to locate anatomical components in retinal images. The proposed method is based on combination of morphological operations, an unsupervised method, and using the concept of deep learning. 

![image](https://github.com/kelleypa/ONH/assets/107891103/35b7f321-0742-42ba-9064-82b9bd8c66d6)


# Steps
1) The code begins with ONH_OPTIMALIZE_ALL.m which creates the vessel reconstruction in ONH/preprocessedImages and candidates in the image database folders, taken from five publicly available retinal image databases DRIVE, STARE, DIARETDB1, CHASE_DB1, MESSIDOR and one local MUMS-DB Database. It also needs the radon transformation (RT) of vessels code: MainVesselRT.m and LocRadVes.m. 

Reference of RT: 
* Tavakoli, Meysam, et al. "Automated microaneurysms detection in retinal images using radon transform and supervised learning: application to mass screening of diabetic retinopathy." IEEE Access 9 (2021): 67302-67314.
* Tavakoli, M., et al. "Radon transform technique for linear structures detection: application to vessel detection in fluorescein angiography fundus images." 2011 IEEE Nuclear Science Symposium Conference Record. IEEE, 2011.

3) ONH_Training.m performs supervised learning .One of our machine learning implements supervised learning, which is comprised of computing first the bag of features then categorizing this bag of features using a support vector machine (SVM).
4) ONH_TrainStackedAutoencoders performs unsupervised deep learning.

  1) Input Layer: specify image size (eg in our case 28-by-28-by-1, corresponds to height, width, channel size where 1 = grayscale and 3 = RGB values)
  2) Convolutional Layer:first argumement is filter size (height and width of filter used while scanning along image), second argument is number of filters (number of neurons connecting to region of the output)
     * ReLU Layer: rectified linear unit function 
     * Max-Pooling Layer: down-sampling operation to reduce number of parameters, to avoid overfitting
     * Fully Connected Layer: last fully connected layer, combining to classify the images
  4) Softmax Layer: the last activation function for a fully connected layer to normalize the probabilistic output
  5) Classification Layer: final classification of input into one of the defined mutually exclusive classes, using the probabilities returned by softmax

![neuralnet](https://github.com/kelleypa/ONH/assets/107891103/f98cf840-9b17-4d41-9c78-374c9af1497f)


The results for the deep neural network can be improved by performing back-propagation on the whole multilayer network. This process is often referred to as fine tuning.


![backpropagation](https://github.com/kelleypa/ONH/assets/107891103/96229a95-e4a6-4dbf-85f7-538c9526c8f1)




6) ONH_Segmentation.m uses the trained features or networks to do segmentation on the images. 
