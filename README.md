# ONH
An approach for optic nerve head (ONH) detection and segmentation which is a necessary step in the development of automated diagnosing systems to locate anatomical components in retinal images. The proposed method is based on combination of morphological operations, an unsupervised method, and using the concept of deep learning. 

# Steps
1) The code begins with ONH_OPTIMALIZE_ALL.m which creates the vessel reconstruction in ONH/preprocessedImages and candidates in the image database folders. It also needs the MainVesselRT.m and LocRadVes.m. 
2) ONH_Training.m performs supervised learning. ONH_TrainStackedAutoencoders performs unsupervised deep learning.
3) ONH_Segmentation.m uses the trained features or networks to do segmentation on the images. 
