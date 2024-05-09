%SOURCE:
% https://www.mathworks.com/help/nnet/examples/training-a-deep-neural-network-for-digit-classification.html
% http://web.engr.oregonstate.edu/~sinisa/courses/OSU/CS556/lectures/CS556_10.pdf
warning off;
clc
clear all
close all

% Flash drive memory = 1 (true) or = 0 on PC (false)
flash = 0;

if flash == 1
    
    candidateDirectory = 'F:\ONH\TrainedONH & Segmentation\Candidates\testingimages';
    imageDirectory = 'F:\ONH\TrainedONH & Segmentation\Candidates';
    trainedDirectory = 'F:\ONH\Candidate ML + Segmentation\trainedClassifier2.mat';
else
    trainingDirectory = 'C:\Users\kelleypa\Desktop\ONH\Candidate ML + Segmentation\trainingimages';
    candidateDirectory = 'C:\Users\kelleypa\Desktop\ONH\Candidate ML + Segmentation\testingimages';
    imageDirectory = 'C:\Users\kelleypa\Desktop\ONH\DRIVE';
    trainedDirectory = 'C:\Users\kelleypa\Desktop\ONH\Candidate ML + Segmentation\trainedClassifier2.mat';
end

% Database Used
imagefiledirectory = 'DRIVE';

% 0 - Not Trained ; 1 - Trained
LIVE = 0;
% 0 - Use New Bag ; 1 - ReUse Bag
UseReUse = 0;
% 0 - 3 Categories/Classes (ONH,nonONH, or partialONH); 
% 1 - 2 Categories/Classes (ONH or nonONH)
% ONLY MATTERS WHEN LIVE = 1
TWOCLASS = 1;
% TRAINING SET DATABASE:
% imagefiledirectory = 'Messidor';
%%
if(~LIVE)
%     digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos',...
%     'nndatasets','digittest_dataset');
    imds = imageDatastore(trainingDirectory,...
        'IncludeSubfolders',true,'LabelSource','foldernames');  

%     net = helperImportMatConvNet(cnnMatFile);
else
    % Load AlexNet from Hardware Support Package
%     net = alexnet;
    imds = imageDatastore(trainingDirectory,...
        'IncludeSubfolders',true,'LabelSource','foldernames');  

end

%Display some of the images in the datastore
figure;
perm = randperm(size(imds.Files,1),20);
for i = 1:20
    subplot(4,5,i);
    imshow(imds.Files{perm(i)});
end

%% RESIZING
for k = 1:size(imds.Files,1)
   rgb = readimage(imds,k);
   rgb = mat2gray(rgb(:,:,1));
   rgb = imresize(rgb, [28 28]);
%    imshow(rgb);
   imwrite(rgb, imds.Files{k});
%    close all
end
%% CREATE CUSTOM NETWORK
%% Equalize number of images of each class in training set
%Check the number of images in each category
tbl = countEachLabel(imds);
%or
CountLabel = imds.countEachLabel;

img = readimage(imds,10);
size(img)

% minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category
minSetCount = min(tbl{:,2});

%Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount);

% Notice that each set now has exactly the same number of images.
countEachLabel(imds)
img = readimage(imds,60);
size(img)

[trainingDS, testDS] = splitEachLabel(imds, 0.8,'randomize');
% % Convert labels to categoricals
% trainingDS.Labels = categorical(trainingDS.Labels);
% trainingDS.ReadFcn = @readFunctionTrain;
% 
% % Setup test data for validation
% testDS.Labels = categorical(testDS.Labels);
% testDS.ReadFcn = @readFunctionValidation;
%% Put image matrix into correct orientation
% SOURCE: https://www.youtube.com/watch?v=h5TqF03CIU8&t=0s
training_set = {};
for i = 1:size(trainingDS.Files,1)
    trainingimage = im2double(imread(trainingDS.Files{i}));
%     trainingimage = transpose(trainingimage(:));
    training_set{i} = trainingimage;
    
end
% training_set = transpose(training_set);

testing_set = {};
for i = 1:size(testDS.Files,1)
    testingimage = im2double(imread(testDS.Files{i}));
%     testingimage = transpose(testingimage(:));
    testing_set{i} = testingimage;
end
% testing_set = transpose(testing_set);

target = zeros(size(trainingDS.Labels,1),2);
for i = 1:size(trainingDS.Labels,1)
    if strcmp(char(trainingDS.Labels(i)),'DB3ONH')
        target(i,1) = 1;
    elseif strcmp(char(trainingDS.Labels(i)),'DB3nonONH')
        target(i,2) = 1;
    end
end
target = transpose(target);

testtarget = zeros(size(testDS.Labels,1),2);
for i = 1:size(testDS.Labels,1)
    if strcmp(char(testDS.Labels(i)),'DB3ONH')
        testtarget(i,1) = 1;
    elseif strcmp(char(testDS.Labels(i)),'DB3nonONH')
        testtarget(i,2) = 1;
    end
end
testtarget = transpose(testtarget);

%% EXAMPLE THAT WORKS
% [xTrainImages, tTrain] = digittrain_dataset; 
%%
xTrainImages = training_set;
tTrain = target;
% Display some of the training images
figure;
for i = 1:20
    subplot(4,5,i);
    imshow(xTrainImages{i});
end

%%
rng('default')

hiddenSize1 = 100;
autoenc1 = trainAutoencoder(xTrainImages,hiddenSize1, ...
    'MaxEpochs',400, ...
    'L2WeightRegularization',0.004, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.15, ...
    'ScaleData', false);

view(autoenc1)


figure()
plotWeights(autoenc1);
%%
feat1 = encode(autoenc1,xTrainImages);
hiddenSize2 = 50;
autoenc2 = trainAutoencoder(feat1,hiddenSize2, ...
    'MaxEpochs',100, ...
    'L2WeightRegularization',0.002, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.1, ...
    'ScaleData', false);
%%
feat2 = encode(autoenc2,feat1);
softnet = trainSoftmaxLayer(feat2,tTrain,'MaxEpochs',400);
view(softnet)
%%
deepnet = stack(autoenc1,autoenc2,softnet);
view(deepnet)

%%
% Get the number of pixels in each image
imageWidth = 28;
imageHeight = 28;
inputSize = imageWidth*imageHeight;

xTestImages = testing_set;
tTest = testtarget;
% Load the test images
% [xTestImages,tTest] = digitTestCellArrayData;

% Turn the test images into vectors and put them in a matrix
xTest = zeros(inputSize,numel(xTestImages));
for i = 1:numel(xTestImages)
    xTest(:,i) = xTestImages{i}(:);
end
%% 
y = deepnet(xTest);
figure;
plotconfusion(tTest,y);
%% Fine-Tuning
% Turn the training images into vectors and put them in a matrix
xTrain = zeros(inputSize,numel(xTrainImages));
for i = 1:numel(xTrainImages)
    xTrain(:,i) = xTrainImages{i}(:);
end
%%
% Perform fine tuning
deepnet = train(deepnet,xTrain,tTrain);
%% visualize the fine-tuned ( Error Backpropagation) results  
y = deepnet(xTest);
figure;
plotconfusion(tTest,y);

save('trainedDeepNet.mat','deepnet')
% save('testDS.mat','testDS')



performance = perform(deepnet,testtarget,y)
view(deepnet)














%% Neural Network
% SOURCE: https://www.youtube.com/watch?v=lBUrB6ZG-tA
% SOURCE: https://www.youtube.com/watch?v=QU-dnb12eRg
% Party SOURCE: https://www.youtube.com/watch?v=yA-wznHkR8w
% nntool

%%


% net = load(network);
%%
% net = MyNetwork;
% % % Extract test features using the CNN
% outputs = MyNetwork(testing_set);
% errors = gsubtract(testtarget,outputs);
% performance = perform(net,testtarget,outputs)
% plotconfusion(testtarget,outputs)
%%
% Pass CNN image features to trained classifier
% predictedLabels = predict(classifier, testFeatures);
% 
% % Get the known labels
% testLabels = testSet.Labels;
% 
% % Tabulate the results using a confusion matrix.
% confMat = confusionmat(testLabels, predictedLabels);
% 
% % Convert confusion matrix into percentage form
% confMat = bsxfun(@rdivide,confMat,sum(confMat,2))
%%
% nb1 = 19;   %number of hidden neurons in the first layer
% nb2 = 17;   %number of hidden neurons in the second layer
% nb3 = 2;    %number of neurons in the ouput layer
% nb = [nb1  nb2  nb3];
% % net = newff(minmax(training_set),nb,{'logsig', 'logsig', 'purelin'}, 'trainlimm');
% net = network;
% % net.trainParam.show = 50;
% net.numInputs = size(training_set,2);
% net.numLayers = 2;
% net.trainFcn = 'traingd';
% net.trainParam.epochs = 10;
% net.inputs{1}
% %%
% net = train(net,training_set,target);
% view(net)
% % y = net(x);
% % perf = perform(net,y,t)
% %% Fine-tune the Network
% tic
% miniBatchSize = 1; % Only increase this if your GPU doesn't run out of memory
% numImages = numel(trainingDS.Files);
% 
% % Run training for 5000 iterations. Convert 20000 iterations into the
% % number of epochs this will be.
% maxEpochs = 20; % one complete pass through the training data
% % batch size is the number of images it processes at once. Training
% % algorithm chunks into manageable sizes. 
% lr = 0.0001;
% opts = trainingOptions('sgdm', ...
%     'LearnRateSchedule', 'none',...
%     'InitialLearnRate', lr,... 
%     'MaxEpochs', maxEpochs, ...
%     'MiniBatchSize', miniBatchSize);
% %%
% %Define the convolutional neural network architecture.
% 
% layers = [imageInputLayer([28, 28, 1])
%           convolution2dLayer(2,16)
%           reluLayer()
%           maxPooling2dLayer(2,'Stride',2)
%           fullyConnectedLayer(2)
%           softmaxLayer()
%           classificationLayer()];
% % options = trainingOptions('sgdm','MaxEpochs',15, ...
% % 	'InitialLearnRate',0.0001);    
% options = trainingOptions('sgdm');
% %%
% net = trainNetwork(trainingDS, layers, options);
% save('trainedNet.mat','net')
% save('testDS.mat','testDS')
% % This could take over an hour to run, so lets stop and load a pre-traiend
% % version that used the same data
% toc
% 
% %Run the trained network on the test set that was not used to train the network and predict the image labels (digits)
% YTest = classify(net,testDS);
% TTest = testDS.Labels;
% %Calculate the accuracy
% accuracy = sum(YTest == TTest)/numel(TTest)
% 

% return % the script will stop here if you run the entire file













%% Load in a previously saved network and test set
% load('trainedNet_restaurant16B.mat');
% % imageDatastore doesn't allow for relative paths, so we need a quick
% % workaround
% % create testDS image datastore with absolute filenames for new location
% load('testDS_filenames_16B.mat');
% testDS = imageDatastore(names,'IncludeSubfolders',1,...
%    'LabelSource','foldernames');
% testDS.ReadFcn = @readFunctionValidation;
% %% Please note that depending on your GPU, this test set might be too large
% % % to create a smaller test set, uncomment these lines
% % num_files = 5; % per category
% % testDS = splitEachLabel(testDS,num_files,'randomize',true);
% 
% %% Test 5-class classifier on  validation set
% % Now run the network on the test data set to see how well it does:
% % please note this takes a long time to run with a larger test set
% % consider reducing size of test set with code in section above
% if(~LIVE)
%     tic
% 
%     [labels,err_test] = classify(net, testDS, 'MiniBatchSize', 1); 
%     toc
%     % Note: the MiniBatchSize depends solely on the 'beefy-ness' of your GPU
%     % keep this number at 1 and test before you increase this to make sure you
%     % don't run out of memory
% 
%     confMat = confusionmat(testDS.Labels, labels);
%     confMat = bsxfun(@rdivide,confMat,sum(confMat,2));
%     save('transferConfMat.mat','confMat')
% else
%     load('transferConfMat.mat')
% end
% confMat
% mean(diag(confMat))
% 
% %% Optional: Can we tell anything about the misses?
% % % take a look at the lowest percentage of correct predictions
% % % this was in the middle column, which corresponds to 'hamburger' 
% % % this is optional step: pull out only the labels of 'hamburger' and
% % % 'misses' and visualize why these are being misclassified
% 
% % idx = find(testDS.Labels == 'hamburger');
% % misses_only = find(labels(idx) ~= testDS.Labels(idx));
% % misses_only = idx(misses_only);
% % 
% % % Check for misses
% % for ii = 1: length(misses_only)
% %     idx = misses_only(ii); 
% %     extra = ' ';
% %     imshow(imread(testDS.Files{idx})); 
% %     title(sprintf('%s',char(labels(idx))));
% %     
% %     pause;
% % end
% 
% %% Choose a random image and visualize the results
% figure(1);
% randNum = randi(length(testDS.Files));
% im = readAndPreprocessImage(testDS.Files{randNum}) ;
% label = char(classify(net,im)); % classify with deep learning 
% imshow(im);
% title(label,'interpreter','none');
% %% Adding confidence to the image
% figure(2);
% randNum = randi(length(testDS.Files));
% im = readAndPreprocessImage(testDS.Files{randNum}) ;
% [label,score] = classify(net,im); % classify with deep learning 
% imshow(im);
% interesting_title = char(label);
% [max_score,idx] = sort(score,'descend');
% 
% xlabel(sprintf('confidence: %.1f%%',max_score(1)*100));
% title(interesting_title,'interpreter','none');
% 
% %% Detect FOOD using CNN classification
% videoReader = vision.VideoFileReader('../VIDEO_OF_FOOD2.mp4');
% videoPlayer = vision.DeployableVideoPlayer;
% position = [10 600];
% position2 = [35 650];
% position3 = [10 40];
% sMeasFps = MeasFps('AveragingCount', 5); % adding an fps counter
% %% Play through video and classify object
% while ~isDone(videoReader)
%     
%     frame = step(videoReader);
%     im = im2uint8(imresize(frame, [227 227],'bilinear')) ;
%   
%     [label,score] = classify(net,im); % classify with deep learning
%    
%     % Adding predction, confidence and framerate to the video output
%     RGB = insertText(frame,position,char(label),'FontSize',18,'TextColor'...
%         ,'white','BoxColor','black');
%     RGB = insertText(RGB,position2,sprintf('%.2f',round(max(score),2)),...
%         'FontSize',18,'TextColor','white','BoxColor','green');
%     RGB = insertText(RGB, position3, sprintf('%2.1f fps', step(sMeasFps)),  ...
%      'BoxOpacity', 1, 'FontSize', 14, 'TextColor', 'red');
%     
%     step(videoPlayer,RGB);
%     
%     
% end 
% %%
% release(videoReader);
% release(videoPlayer);
