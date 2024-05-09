# ONH
An approach for optic nerve head (ONH) detection and segmentation which is a necessary step in the development of automated diagnosing systems to locate anatomical components in retinal images. The proposed method is based on combination of morphological operations, an unsupervised method, and using the concept of deep learning. 

![image](https://github.com/kelleypa/ONH/assets/107891103/35b7f321-0742-42ba-9064-82b9bd8c66d6)


# Steps
1) The code begins with ONH_OPTIMALIZE_ALL.m which creates the vessel reconstruction in ONH/preprocessedImages and candidates in the image database folders, taken from five publicly available retinal image databases DRIVE, STARE, DIARETDB1, CHASE_DB1, MESSIDOR and one local MUMS-DB Database. It also needs the radon transformation (RT) of vessels code: MainVesselRT.m and LocRadVes.m. 

Reference of RT: 
* Tavakoli, Meysam, et al. "Automated microaneurysms detection in retinal images using radon transform and supervised learning: application to mass screening of diabetic retinopathy." IEEE Access 9 (2021): 67302-67314.
* Tavakoli, M., et al. "Radon transform technique for linear structures detection: application to vessel detection in fluorescein angiography fundus images." 2011 IEEE Nuclear Science Symposium Conference Record. IEEE, 2011.

3) ONH_Training.m performs supervised learning. ONH_TrainStackedAutoencoders performs unsupervised deep learning.
4) ONH_Segmentation.m uses the trained features or networks to do segmentation on the images. 
