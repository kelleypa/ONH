%% Scene Identification Using Image Data
% Image classification involves determining if an image contains some 
% specific object, feature, or activity. The goal of this example is to
% provide a strategy to construct a classifier that can automatically 
% detect which scene we are looking at
% This example uses function from the Computer Vision System Toolbox and
% Statistics and Machine Learning
% Copyright (c) 2016, MathWorks, Inc.
% This Runs in 2016B and newer
% Please note: this will not run in 2016A or prior!

clear all
close all
clc

% 0 - Not Trained ; 1 - Trained
LIVE = 0;
% 0 - Use New Bag ; 1 - ReUse Bag
UseReUse = 0;
% 0 - 3 Categories/Classes (ONH,nonONH, or partialONH); 
% 1 - 2 Categories/Classes (ONH or nonONH)
% ONLY MATTERS WHEN LIVE = 1
TWOCLASS = 1;
%%
if(~LIVE)
    %% clear all
    close all
%     clear all
    clc

    %% Description of the Data
    % The dataset contains 4 scenes: Field, Auditorium, Beach ,Restaurant
    % The images are photos of the scenes that have been taken from different
    % angles, positions, and different lighting conditions. These variations make 
    % this a challenging task.
    %%%
    %% 
    % Data needs to be downloaded in order for this demo to run
    % Please use your own data or download a database online
    % Here's an example of a good source of scene data
    % http://groups.csail.mit.edu/vision/SUN/
    %% Load image data
    % This assumes you have a directory: Scene_Categories
    % with each scene in a subdirectory
%     imds = imageDatastore('C:\Users\kelleypa\Desktop\ONH\Deep Learning Machine Learning for Object Recognition\Images\DB3',...
%         'IncludeSubfolders',true,'LabelSource','foldernames');              %#ok
    imds = imageDatastore('C:\Users\kelleypa\Desktop\ONH\Candidate ML + Segmentation\trainingimages',...
        'IncludeSubfolders',true,'LabelSource','foldernames');  
    %% Display Class Names and Counts
    tbl = countEachLabel(imds)                                             %#ok
    categories = tbl.Label; 
    minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category
    % Use splitEachLabel method to trim the set.
    imds = splitEachLabel(imds, minSetCount, 'randomize');
    % Notice that each set now has exactly the same number of images.
    countEachLabel(imds)

    %% Display Sampling of Image Data
    figure(1);
    sample = splitEachLabel(imds,2);

    montage(sample.Files(1:2));
    title(char(tbl.Label(1)));

    %% Show sampling of all data
%     figure(1);
%     for ii = 1:4
%         sf = (ii-1)*16 +1;
%         ax(ii) = subplot(2,2,ii);
%         montage(sample.Files(sf:sf+3));
%         title(char(tbl.Label(ii)));
%     end
    %%  Pick 20% of images from each set for the training data and the remainder, 80%, for the validation data
    [training_set, test_set] = splitEachLabel(imds,0.2,'randomized');
    % now make sure that 200 files each for test
%     test_set = splitEachLabel(test_set, 98 ,'randomized');

    %% Create Visual Vocabulary 
    % While this is training, you can pull up bagOfFeatures doc to explain what
    % is happening or refer to bagOfFeatures slide in presentation
    % if exist('BoF.mat', 'file') == 2

    if(UseReUse)
        if size(categories,1)> 2
            load('BoF.mat')
        else
            load('BoF2.mat')
        end
    else
        tic
        if size(categories,1) > 2
%             bag = bagOfFeatures(imageSet(training_set.Files));
            bag = bagOfFeatures(imageSet(training_set.Files),...
                'VocabularySize',250,'PointSelection','Detector');
            scenedata = double(encode(bag, imageSet(training_set.Files)));
            toc
            save('C:\Users\kelleypa\Desktop\ONH\Candidate ML + Segmentation\BoF.mat','bag','scenedata');  
        else
%             bag = bagOfFeatures(imageSet(training_set.Files));
            bag = bagOfFeatures(imageSet(training_set.Files),...
                'VocabularySize',250,'PointSelection','Detector');
            scenedata = double(encode(bag, imageSet(training_set.Files)));
            toc
            save('C:\Users\kelleypa\Desktop\ONH\Candidate ML + Segmentation\BoF2.mat','bag','scenedata');  
           
        end
    end
    %% Visualize Feature Vectors 
    rand4imgs = splitEachLabel(training_set,2,'randomized');

    img = rand4imgs.readimage(1);
    featureVector = encode(bag, img);

    figure, subplot(4,2,1); imshow(img);
    subplot(4,2,2); 
    bar(featureVector);title('Visual Word Occurrences');xlabel('Visual Word Index');ylabel('Frequency');

    img = rand4imgs.readimage(2);
    featureVector = encode(bag, img);
    subplot(4,2,3); imshow(img);
    subplot(4,2,4); 
    bar(featureVector);title('Visual Word Occurrences');xlabel('Visual Word Index');ylabel('Frequency');

    img = rand4imgs.readimage(3);
    featureVector = encode(bag, img);
    subplot(4,2,5); imshow(img);
    subplot(4,2,6); 
    bar(featureVector);title('Visual Word Occurrences');xlabel('Visual Word Index');ylabel('Frequency');

    img = rand4imgs.readimage(4);
    featureVector = encode(bag, img);
    subplot(4,2,7); imshow(img);
    subplot(4,2,8); 
    bar(featureVector);title('Visual Word Occurrences');xlabel('Visual Word Index');ylabel('Frequency');
    %% Create a Table using the encoded features
    SceneImageData = array2table(scenedata);
    SceneImageData.sceneType = training_set.Labels;

    %% Use the new features to train a model and assess its performance using 
    % use classification learner app to create a classifier
    % The remaining code in this demo assumes you have created a trained
    % classifier called 'trainedClassifier'

    classificationLearner
%     
%     if size(categories,1)> 2
%         [trainedClassifier, validationAccuracy] = trainClassifier(SceneImageData)
%         save('C:\Users\kelleypa\Desktop\ONH\Candidate ML + Segmentation\trainedClassifier.mat');
%     else 
%         [trainedClassifier, validationAccuracy] = trainClassifier2(SceneImageData)
%         save('C:\Users\kelleypa\Desktop\ONH\Candidate ML + Segmentation\trainedClassifier2.mat');
%     end
    
%     save('file2save.mat','trainedClassifier');

    %% When we looked at confusion matrix, sometimes Beach and Fields were misclassified
    % Can we look at Beaches and Fields and see why they are misidentified?
    % rand2imgs = splitEachLabel(training_set,2,'randomized');
    % figure(2);
    % imshowpair(rand2imgs.readimage(2),rand2imgs.readimage(3),'montage')
    % title('ONH vs. nonONH');
    %% Test out accuracy on test set!
    tic
    testSceneData = double(encode(bag, imageSet(test_set.Files)));
    testSceneData = array2table(testSceneData,'VariableNames',trainedClassifier.RequiredVariables);
    actualSceneType = test_set.Labels;

    predictedOutcome = trainedClassifier.predictFcn(testSceneData);

    correctPredictions = (predictedOutcome == actualSceneType);
    validationAccuracy = sum(correctPredictions)/length(predictedOutcome) %#ok
    toc
    %% Visualize how the classifier works
    figure(3);
    ii = randi(length(test_set.Files));

    img = test_set.readimage(ii);

    imshow(img)
    % Add code here to invoke the trained classifier
    imagefeatures = double(encode(bag, img));
    % Find two closest matches for each feature
    [bestGuess, score] = predict(trainedClassifier.ClassificationSVM,imagefeatures);
    % Display the string label for img
    if strcmp(char(bestGuess),char(test_set.Labels(ii)))
        titleColor = [0 0.8 0];
    else
        titleColor = 'r';
    end
    title(sprintf('Best Guess: %s; Actual: %s',...
        char(bestGuess),test_set.Labels(ii)),...
        'color',titleColor)
    
    %% Confusion matrix
%     plotconfusion(actualSceneType,predictedOutcome)
%%
else
    %%
    images = imageDatastore('C:\Users\kelleypa\Desktop\ONH\Candidate ML + Segmentation\testingimages',...
        'IncludeSubfolders',true,'LabelSource','foldernames');
    if TWOCLASS == 1
        load('C:\Users\kelleypa\Desktop\ONH\Candidate ML + Segmentation\trainedClassifier2.mat')
    else
        load('C:\Users\kelleypa\Desktop\ONH\Candidate ML + Segmentation\trainedClassifier.mat')
    end
%%
%     [training_set, testing_set] = splitEachLabel(imds,100,'randomized');
    % now make sure that 200 files each for test
    testing_set = splitEachLabel(images, 10 ,'randomized');
    
    %% Test out accuracy on test set!
    tic
    testingSceneData = double(encode(bag, imageSet(testing_set.Files)));
    testingSceneData = array2table(testingSceneData,'VariableNames',trainedClassifier.RequiredVariables);
    actualtestingSceneType = testing_set.Labels;
    
    predictOutcome = trainedClassifier.predictFcn(testingSceneData);
    
    % Remove the DB# before ONH, nonONH, partialONH
    predictedOutcome = {};
    actualTesting = {};
    for i = 1:length(actualtestingSceneType)
        bG = char(predictOutcome(i));
        predictedOutcome{i,1} = bG(4:end);
        tL = char(actualtestingSceneType(i));
        actualTesting{i,1} = tL(4:end);
    end
    
    correctPredictions = zeros(size(predictedOutcome,1),1);
    for i = 1:size(predictedOutcome,1)
            if strcmp(predictedOutcome{i,1},actualTesting{i,1})
                correctPredictions(i,1) =1;
            elseif strcmp(predictedOutcome{i,1},'partialONH') && strcmp(actualTesting{i,1},'ONH') || strcmp(actualTesting{i,1},'partialONH') && strcmp(predictedOutcome{i,1},'ONH')
                correctPredictions(i,1) =1;
            else
                correctPredictions(i,1) =0;
            end

        correctPredictions(i,1) = strcmp(predictedOutcome{i,1},actualTesting{i,1});
    end
    validationAccuracy = sum(correctPredictions)/length(predictedOutcome) %#ok
    toc

    %% Visualize how the classifier works
    figure(3);
    ii = randi(length(testing_set.Files));

    img = testing_set.readimage(ii);
%     nameimg = testing_set.Files{ii}
    imshow(img)
    % Add code here to invoke the trained classifier
    imagefeatures = double(encode(bag, img));
    % Find two closest matches for each feature
    [bestGuess, score] = predict(trainedClassifier.ClassificationSVM,imagefeatures);
%     Display the string label for img
    % Remove the DB# before ONH, nonONH, partialONH
    bG = char(bestGuess);
    bG = bG(4:end);
    tL = char(testing_set.Labels(ii));
    tL = tL(4:end);
    if strcmp(bG,tL)
        titleColor = [0 0.8 0];
    elseif strcmp(bG,'partialONH') && strcmp(tL,'ONH') || strcmp(tL,'partialONH') && strcmp(bG,'ONH')
        titleColor = 'y';
    else
        titleColor = 'r';
    end
%     if bestGuess == 'DB1ONHpatches'
%         bestGuess = 'ONH';
%     elseif bestGuess == 'DB1nonONHpatches'
%         bestGuess = 'notONH';
%     end
%     titleColor = [0 0.8 0];
    title(sprintf('Best Guess: %s; Actual: %s',...
        bG,tL),'color',titleColor)

    %%
end
    

