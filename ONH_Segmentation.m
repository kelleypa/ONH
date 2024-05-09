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
    candidateDirectory = 'C:\Users\kelleypa\Desktop\ONH\Candidate ML + Segmentation\testingimages';
    imageDirectory = 'C:\Users\kelleypa\Desktop\ONH\DRIVE';
    trainedDirectory = 'C:\Users\kelleypa\Desktop\ONH\Candidate ML + Segmentation\trainedClassifier2.mat';
end

% Database Used
imagefiledirectory = 'DRIVE';


imagefiledirectory = 'STARE';
imageDirectory = 'C:\Users\kelleypa\Desktop\ONH\STARE';
 
 
% 0 - Not Trained ; 1 - Trained
LIVE = 1;
% 0 - Use New Bag ; 1 - ReUse Bag
UseReUse = 0;
% 0 - 3 Categories/Classes (ONH,nonONH, or partialONH); 
% 1 - 2 Categories/Classes (ONH or nonONH)
% ONLY MATTERS WHEN LIVE = 1
TWOCLASS = 1;
% TRAINING SET DATABASE:
% imagefiledirectory = 'Messidor';

%% Extract Candidate Images with Position

% mainDirectory = 'C:\Users\kelleypa\Desktop\Messidor\';
% mainDirectory = 'testingimages';

i = 1;
subFolder = dir(fullfile(candidateDirectory,'*.jpg'));
fileNames = {subFolder.name};
numbcand = numel( subFolder );

%% IMPORT CANDIDATE IMAGE INFORMATION
    candinfo = [];
    ii = 1;

for j = 1:numbcand
    %candidate image 'db#img#c#Candrow#col#.jpg':
    name = fileNames{1,j};
    %find array of 0s for numbers and 1s for letters           
    index = isletter(name);
    %nameinfo = [db #, img #, c #, p #, m #, n #, row #, column #]
    jj = 1;
    i = 1;
    while i < length(index)-3
        
       if strcmp(name(i:i+1),'db')
           i = i+2;
           candinfo(ii,jj) = str2num(name(i));
           jj = jj+1;
           i = i+1;
       end
       if strcmp(name(i:i+2),'img')
           i = i+3;
           ij = [i];
           while index(i) == 0
               i = i+1;
               ij = [ij,i];
           end
           ij(end) = [];
           candinfo(ii,jj) = str2num(name(ij));
       end
       if strcmp(name(i),'c') && isletter(name(i+1)) == 0
           jj = jj + 1;
           candinfo(ii,jj) = str2num(name(i+1));
           jj = jj + 4;
           i = i+2;
       elseif strcmp(name(i),'p') && isletter(name(i+1)) == 0
           jj = jj + 2;
           candinfo(ii,jj) = str2num(name(i+1));
           jj = jj + 3;
           i = i+2;
       elseif strcmp(name(i),'m') && isletter(name(i+1)) == 0
           jj = jj + 3;
           candinfo(ii,jj) = str2num(name(i+1));
           jj = jj + 2;
           i = i+2;
       elseif strcmp(name(i),'n') && isletter(name(i+1)) == 0
           jj = jj + 4;
           candinfo(ii,jj) = str2num(name(i+1));
           jj = jj + 1;
           i = i+2;
       end 
       if strcmp(name(i:i+3),'Cand') &&  strcmp(name(i+4:i+6),'row')
           i = i+7;
           candinfo(ii,jj) = str2num(name(i));
           jj = jj + 1;
           i = i+1;
       end
       if strcmp(name(i:i+2), 'col')
           i = i+3;
           candinfo(ii,jj) = str2num(name(i));
       end
       i = i+1;
    end
    ii = ii+1;
end
%% CANDIDATE SELECTION OVER IMAGE 
% secondaryDirectory ='C:\Users\kelleypa\Desktop\ONH\Messidor';


numim = 5;
db = 2;



candinfodb = find(candinfo(:,2)==numim,6);

if candinfo(candinfodb(1,1),1) == 1 && db == 1
    immat = {};
    for i = 1:40
        if i<=20
            immat{1,i} =sprintf('%s_test',num2str(i,'%02i'));
        else
            immat{1,i} =sprintf('%s_training',num2str(i,'%02i'));
        end
    end
elseif candinfo(candinfodb(1,1),1) == 2 && db == 2
    imagesubFolder = dir(fullfile(imageDirectory,'*.jpg'));
    immat = {imagesubFolder.name};
    %remove .jpg from immat file name
    for i = 1:length(immat)
        immat{1,i} = strrep(immat{1,i}, '.jpg', '');
    end
elseif candinfo(candinfodb(1,1),1) == 3 && db == 3
    immat = {};
    for i = 1:600
        if i<=999
            immat{1,i} =sprintf('Mess%s',num2str(i,'%04i'));
        else
            immat{1,i} =sprintf('Mess%i',i);
        end
    end
end

% What image extension (.jpg or .tif)
if strcmp(imagefiledirectory,'STARE') == 1
    file = sprintf('%s\\%s.jpg',imageDirectory,immat{1,numim});
else
    file = sprintf('%s\\%s.tif',imageDirectory,immat{1,numim});
end

imm = imread(file);
            windowx=floor(size(imm,2)/4);
            windowy=floor(size(imm,1)/4);
            pixelxstep = floor(windowx/2);
            pixelystep = floor(windowy/2);
            step  = 6;

%             candsort = sortrows(candinfo,2);
            candinfopos = find(candinfo(:,2)==numim,6);
            
            %row and column of sliding windows
            sector = [candinfo(candinfopos,end-1), candinfo(candinfopos,end)];
            
            %% Correct for the factor of 1/2 for saved preprocessed image 
            windowx=floor(size(imm,2)/4);
            windowy=floor(size(imm,1)/4);
            pixelxstep = floor(windowx/2);
            pixelystep = floor(windowy/2);
            %% Vessel Reconstruction 6 Box Picks         
            figure
            ZWindowedMarked  = insertShape(imm, 'rectangle', [(sector(1,1)-1)*pixelxstep (sector(1,2)-1)*pixelystep windowx windowy],'linewidth',9);
            ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(sector(2,1)-1)*pixelxstep (sector(2,2)-1)*pixelystep windowx windowy],'linewidth',5);
            ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(sector(3,1)-1)*pixelxstep (sector(3,2)-1)*pixelystep windowx windowy],'linewidth',3);
            ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(sector(4,1)-1)*pixelxstep (sector(4,2)-1)*pixelystep windowx windowy],'linewidth',3);
            ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(sector(5,1)-1)*pixelxstep (sector(5,2)-1)*pixelystep windowx windowy],'linewidth',3);
            ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(sector(6,1)-1)*pixelxstep (sector(6,2)-1)*pixelystep windowx windowy],'linewidth',3);
%             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [immatONH(numim,1)-ONHbox immatONH(numim,2)-ONHbox ONHbox*2 ONHbox*2],'linewidth',5,'Color', {'blue'},'Opacity',0.7);
            hold on
            imshow(ZWindowedMarked)
            
            windowx=floor(size(imm,2)/4);
            windowy=floor(size(imm,1)/4);
            pixelxstep = floor(windowx/2);
            pixelystep = floor(windowy/2);
            
            boxco = {{((sector(1,2)-1)*pixelystep+1):((sector(1,2)-1)*pixelystep+windowy+1)},{((sector(1,1)-1)*pixelxstep+1):((sector(1,1)-1)*pixelxstep+windowx+1)};
            {((sector(2,2)-1)*pixelystep+1):((sector(2,2)-1)*pixelystep+windowy+1)},{((sector(2,1)-1)*pixelxstep+1):((sector(2,1)-1)*pixelxstep+windowx+1)};
            {((sector(3,2)-1)*pixelystep+1):((sector(3,2)-1)*pixelystep+windowy+1)},{((sector(3,1)-1)*pixelxstep+1):((sector(3,1)-1)*pixelxstep+windowx+1)};
            {((sector(4,2)-1)*pixelystep+1):((sector(4,2)-1)*pixelystep+windowy+1)},{((sector(4,1)-1)*pixelxstep+1):((sector(4,1)-1)*pixelxstep+windowx+1)};
            {((sector(5,2)-1)*pixelystep+1):((sector(5,2)-1)*pixelystep+windowy+1)},{((sector(5,1)-1)*pixelxstep+1):((sector(5,1)-1)*pixelxstep+windowx+1)};
            {((sector(6,2)-1)*pixelystep+1):((sector(6,2)-1)*pixelystep+windowy+1)},{((sector(6,1)-1)*pixelxstep+1):((sector(6,1)-1)*pixelxstep+windowx+1)}};
%         boxbox = [row1 col1;row2 col2; row3 col3; row4 col4; row5 col5; row6 col6];

%% Get all image candidate names in string to apply trained classification
%     candimagesDirectory = '';
%     for i = 1:length(candinfopos)
%         candimagesDirectory = strcat(candimagesDirectory,candidateDirectory);
%         candimagesDirectory = strcat(candimagesDirectory,subFolder(candinfopos(i)).name);
%         if i ~= length(candinfopos)
%             candimagesDirectory = strcat(candimagesDirectory,';');
%         end
%     end


%%
%% Load Trained Set
%%
%% candimagesDirectory
    images = imageDatastore(candidateDirectory,...
        'IncludeSubfolders',true,'LabelSource','foldernames');
    load(trainedDirectory)

    %% Visualize how the classifier works
    figure;
    canddetect = [];
    for i = 1:length(candinfopos);
    ii = candinfopos(i);
    img = images.readimage(ii);
    subplot(2,3,i);
    imshow(img)
    % Add code here to invoke the trained classifier
    imagefeatures = double(encode(bag, img));
    % Find two closest matches for each feature
    [bestGuess, score] = predict(trainedClassifier.ClassificationSVM,imagefeatures);
%     Display the string label for img
    % Remove the DB# before ONH, nonONH, partialONH
    bG = char(bestGuess);
    bG = bG(4:end);
    title(sprintf('Best Guess: %s',bG),'color','b')
    
    if strcmp(bG,'ONH')
        onh = 1;
    else
        onh = 0;
    end
    canddetect = [canddetect;candinfo(candinfopos(i),:),onh];
    end
    
    
    
%% Find all the Adjoint Candidates
sectorpos = [sector,candinfopos,canddetect(:,end)];
adjointcandrow = sortrows(sectorpos,1);
adjointcandcol = sortrows(sectorpos,2);

% combinedcand = [row1, row2, col1, col2, imgmatrixpos1, imgmatrixpos2];
% combinedcand = [];
% for i = 1:length(sector)-1
%     if (adjointcandrow(i,1) == adjointcandrow(i+1,1)+1) || (adjointcandrow(i,1) == adjointcandrow(i+1,1)) || ...
%             adjointcandrow(i,1) == adjointcandrow(i+1,1)-1
%         combinedcand = [combinedcand;adjointcandrow(i,1),adjointcandrow(i+1,1),adjointcandrow(i,2),adjointcandrow(i+1,2),...
%             adjointcandrow(i,3),adjointcandrow(i+1,3),adjointcandrow(i,4),adjointcandrow(i+1,4)];
%     end
%     if (adjointcandcol(i,1) == adjointcandcol(i+1,1)+1) || (adjointcandcol(i,1) == adjointcandcol(i+1,1)) || ...
%             adjointcandcol(i,1) == adjointcandcol(i+1,1)-1
%         combinedcand = [combinedcand;adjointcandcol(i,1),adjointcandcol(i+1,1),adjointcandcol(i,2),adjointcandcol(i+1,2),...
%             adjointcandcol(i,3),adjointcandcol(i+1,3),adjointcandcol(i,4),adjointcandcol(i+1,4)];
%     end
% end

%% Segmentation
%% SIX THRESHOLD INTENSITIES
% figure

onhcandidatepos = find(canddetect(:,end)==1,6);
onhcand = [];
for i = 1:length(onhcandidatepos)
    onhcand = [onhcand;canddetect(onhcandidatepos(i),:)];
end



centers = [];
radii = [];
for k = 1:size(onhcand,1)
    ii = candinfopos(onhcandidatepos(k));
    img = images.readimage(ii);
imgnum = k;
thr = 210;
BW = {};
islope = img(:,:,1);
% figure
for pp = 1:6
    islopeI = zeros(size(islope));
    for i = 1:size(islope,1)
        for j = 1:size(islope,2)
            if img(i,j,1) > thr
                islopeI(i,j) = img(i,j,1);
            end
        end
    end
%     tit = sprintf('Threshold %d', thr);
%     subplot(2,3,pp); imshow(uint8(islopeI));title(tit);
    
    BW1 = edge(logical(islopeI),'Canny');
    se1 = strel('disk',6);se2 = strel('disk',8);se3 = strel('disk',12);
    BW1 = imdilate(BW1,se1);BW1 = imerode(BW1,se2);BW1 = imdilate(BW1,se3);
    %put a big blob then remove to circle
%     se = strel('disk',20);BW1 = imdilate(BW1,se);ser = strel('disk',1);sed = strel('disk',4);
%     for i = 1:10
%        BW1 = imerode(BW1,sed);
%     end
%     for i = 1:20
%        BW1 = imerode(BW1,ser);
%     end
    
    
    BW{1,pp} = BW1;
    thr = thr - 15;
end



% Hough Circular Transform on Morphological ONH candidates
% figure
% for ii = 1:6
% % A = edge(img(:,:,1),'Canny');
% se = strel('disk',2);
% A = BW{ii};A = bwmorph(A,'remove'); subplot(2,3,ii);
% imshow(A); tit = sprintf('Hough Morpho %d',ii);
% title(tit);
% imshow(A)
% size(A);

% Rmin = 20;
% Rmax = floor(size(A,2)/2);
% [centersBright, radiiBright] = imfindcircles(A,[Rmin Rmax],'ObjectPolarity','bright');
% 
% [centersDark, radiiDark] = imfindcircles(A,[Rmin Rmax],'ObjectPolarity','dark');
% 
% centersStrong5 = centersBright(1:end,:);
% radiiStrong5 = radiiBright(1:end);
% viscircles(centersStrong5, radiiStrong5,'Color','b');
% end


% MORPHOLOGICAL BOUNDARY SEGMENTATION
% Dilate first and second candidate intensity morphologies and 
% use masking marker technique to remove gunk

% figure
A = ones(size(BW{1}));
for h = 1:length(BW)-1
    %first and second threshold morpho candidate image
A1 = BW{h}; se = strel('disk',20-(h-1)); A1 = imdilate(A1,se);
A2 = BW{h+1}; se = strel('disk',20-(h-1)); A2 = imdilate(A2,se);
AA = A1.*A2;
se = strel('disk',15-(h-1));
AA = imerode(AA,se);
% update morpho candidate image with previous and from above
se = strel('disk',20-(h-1)); AA = imdilate(AA,se);
se = strel('disk',20-(h-1)); A = imdilate(A,se);
A = A.*AA;
se = strel('disk',15);
A = imerode(A,se);

% subplot(2,3,h); imshow(A)
 
end
%Final comparison (mask/marker) b/w first and last morph candidate
A1 = BW{end}; se = strel('disk',10); A1 = imdilate(A1,se);
A = A.*A1;
%Final morpho operation to smooth it out
se = strel('disk',10); AA = imdilate(A,se);
se = strel('disk',10); A = imerode(AA,se);

% sm = 10;
% for i = 1:sm
%     se = strel('disk',3); AA = imdilate(A,se);
%     se = strel('disk',1); A = imerode(AA,se);
% end
%   imshow(logical(A))
Aoriginal{k} = A;

AW = bwmorph(A,'remove');
%make thicker segmetation line
% se = strel('disk',2);AW = imdilate(AW,se);

AQ = imcomplement(AW);

Amorph{k} = AQ;
% figure;imshow(Amorph{1});


%
%OVERLAP HOUGH TRANSFORM CIRCLES OVER CANDIDATE
% figure
% for ii = 1:6
% % A = edge(img(:,:,1),'Canny');
% A = BW{ii}; subplot(2,3,ii);
% imshow(img); tit = sprintf('Cand Seg %d',ii);
% title(tit);
% % imshow(A)
% % size(A);
% 
% Rmin = 25;
% Rmax = floor(size(A,2)/2);
% [centersBright, radiiBright] = imfindcircles(A,[Rmin Rmax],'ObjectPolarity','bright');
% 
% [centersDark, radiiDark] = imfindcircles(A,[Rmin Rmax],'ObjectPolarity','dark');
% 
% centersStrong5 = centersBright(1:end,:);
% radiiStrong5 = radiiBright(1:end);
% viscircles(centersStrong5, radiiStrong5,'Color','b');
% 
% if isempty(centersStrong5)
%     centersStrong5 = [0,0];
%     radiiStrong5 = [0];
% end
% centers = [centers;k,ii, centersStrong5];
% radii = [radii;k,ii, radiiStrong5];
% 
% end


end

   %% (CENTER OF MASS of MORPHO CANDIDATE IMAGE)
   figure;
   for i = 1:size(Aoriginal,2)
    bw = Aoriginal{i};
    labelarray = bwlabel(bw);
    measurements = regionprops(labelarray, 'Centroid');
    subplot(1,size(Aoriginal,2),i); imshow(bw,[]);
    hold on;
    centmeasure = [];
    for i=1:length(measurements)
        plot(measurements(i,1).Centroid(1,1),measurements(i,1).Centroid(1,2),'go','MarkerSize',12);
        centmeasure(i,1) = measurements(i,1).Centroid(1,1);
        centmeasure(i,2) = measurements(i,1).Centroid(1,2);
    end
    hold off;
   end


% %% Fit best fit circle
% figure;
% for q = 1:size(Amorph,2)
%     x = []; y =[];
%     for i = 1:size(Amorph{1,q},1)
%         for j = 1:size(Amorph{1,q},2)
%             if Amorph{1,q}(i,j) == 0
%                 x = [x,j];
%                 y = [y,i];
%             end
%         end
%     end
% 
% ii = candinfopos(onhcandidatepos(q));
%     img = images.readimage(ii);
%          th = linspace(0,2*pi,20)';      
%    % reconstruct circle from data
%    subplot(1,size(Amorph,2),q);imshow(img),hold on
%    [xc,yc,Re,a] = circfit(x,y);
%      xe = Re*cos(th)+xc; ye = Re*sin(th)+yc;
%     plot([xe;xe(1)],[ye;ye(1)],'b-.'),
% %      title(' measured fitted and true circles')
% % %       legend('measured','fitted','true')
% %      xlabel x, ylabel y 
%      axis equal
% end





%% FIND OVERLAPPING CANDIDATES
% binaryimg = zeros(size(imm,1),size(imm,2));
% 
% % yrange = boxco{onhcandidatepos(1),1}{1,1}(1,1):boxco{onhcandidatepos(1),1}{1,1}(1,end);
% % xrange = boxco{onhcandidatepos(1),2}{1,1}(1,1):boxco{onhcandidatepos(1),2}{1,1}(1,end);
% % imbox = imm(yrange,xrange,1:3);
% 
% 
% 
% if size(onhcandidatepos,1) > 1
% 
%     
%     
%     onhcandsectorpos = [transpose(1:size(onhcand,1)),onhcand(:,end-2:end-1)];
%     adjointcandrow = sortrows(onhcandsectorpos,3);
% %     adjointcandcol = sortrows(onhcandsectorpos,2);
%     
%     for i = 1:size(onhcandsectorpos,1)-1
%         whitecount = 0;
%         Acandnotblack = Aoriginal{adjointcandrow(i,1)};
%         for a = 1:size(Acandnotblack,1)
%             for b = 1:size(Acandnotblack,2)
%                 if Acandnotblack(a,b) == 1;
%                     whitecount = whitecount+1;
%                 end
%             end
%         end
%     
%     
%     if whitecount < 500
%         continue
%     elseif (adjointcandrow(i,1) == adjointcandrow(i+1,1)+1) || (adjointcandrow(i,1) == adjointcandrow(i+1,1)) || ...
%                 adjointcandrow(i,1) == adjointcandrow(i+1,1)-1 && (adjointcandrow(i,2) == adjointcandrow(i+1,2)+1) || (adjointcandrow(i,2) == adjointcandrow(i+1,2)) || ...
%                 adjointcandrow(i,2) == adjointcandrow(i+1,2)-1
%         
%         yrange = boxco{onhcandidatepos(i),1}{1,1}(1,1):boxco{onhcandidatepos(i),1}{1,1}(1,end);
%         xrange = boxco{onhcandidatepos(i),2}{1,1}(1,1):boxco{onhcandidatepos(i),2}{1,1}(1,end); 
%         yrange1 = boxco{onhcandidatepos(i+1),1}{1,1}(1,1):boxco{onhcandidatepos(i+1),1}{1,1}(1,end);
%         xrange1 = boxco{onhcandidatepos(i+1),2}{1,1}(1,1):boxco{onhcandidatepos(i+1),2}{1,1}(1,end);
%         
% %         xrange = union(xrange,xrange1);
% %         yrange = union(yrange,yrange1);
%         
%         ycombined = 1:length(yrange); xcombined = 1:length(xrange);
%         Acand1 = Aoriginal{adjointcandrow(i,1)};
%         Acand2 = Aoriginal{adjointcandrow(i+1,1)};
%         
%         Acandcomb1 = zeros(size(imm,1),size(imm,2));
%         for a = 1:length(yrange)
%             for b = 1:length(xrange)
%                 if Acand1(a,b) ~= 0
%                     Acandcomb1(((adjointcandrow(i,3)-1)*pixelystep+a),((adjointcandrow(i,2)-1)*pixelxstep+b)) = 1;
%                 end
%             end
%         end
% %         figure; imshow(Acandcomb1);
%         Acandcomb2 = zeros(size(imm,1),size(imm,2));
%         for a = 1:length(yrange1)
%             for b = 1:length(xrange1)
%                 if Acand2(a,b) ~= 0
%                     Acandcomb2(((adjointcandrow(i,3)-1)*pixelystep+a),((adjointcandrow(i,2)-1)*pixelxstep+b)) = 1;
%                 end
%             end
%         end
% %         figure; imshow(Acandcomb2);
%         prebinaryimg = Acandcomb1.*Acandcomb2;
% %         figure; imshow(prebinaryimg);
%         if i == 1
%             binaryimg = prebinaryimg;
%         else
% %             binaryimg = binaryimg.*prebinaryimg;
%             for a = 1:size(binaryimg,1)
%                 for b = 1:size(binaryimg,2)
%                     if prebinaryimg(a,b) ~= 0
%                         binaryimg(a,b) = 1;
%                     end
%                 end
%             end
%             
%             
%             
%         end
%        
%     end
%     end
% %         figure; imshow(prebinaryimg)
%     
%         segimg = mat2gray(imcomplement(binaryimg)).*mat2gray(imm(:,:,2));
% %         figure; imshow(segimg)
% 
% %         figure; imshow(imm(:,:,2))
% 
% else
%     onhcandsectorpos = [1,onhcand(:,end-2:end-1)];
%     adjointcandrow = sortrows(onhcandsectorpos,3);
%     Acand = Aoriginal{adjointcandrow(1,1)};
%     yrange = boxco{onhcandidatepos(1),1}{1,1}(1,1):boxco{onhcandidatepos(1),1}{1,1}(1,end);
%     xrange = boxco{onhcandidatepos(1),2}{1,1}(1,1):boxco{onhcandidatepos(1),2}{1,1}(1,end); 
%         Acandcomb = zeros(size(imm,1),size(imm,2));
%         for a = 1:length(yrange)
%             for b = 1:length(xrange)
%                 if Acand(a,b) ~= 0
%                     Acandcomb(((adjointcandrow(1,3)-1)*pixelystep+a),((adjointcandrow(i,2)-1)*pixelxstep+b)) = 1;
%                 end
%             end
%         end
%         prebinaryimg = Acandcomb;
%         segimg = mat2gray(imcomplement(prebinaryimg)).*mat2gray(imm(:,:,2));
%         figure; imshow(segimg)
% end


% for i = 1:size(imm,1)
%     for j = 1:size(imm,2)
%         binary 




 %% COUNT THE VEINS (CENTER OF MASS of IMAGE)
%     % % [x, y] = meshgrid(1:size(bw, 2), 1:size(bw, 1));
%     % % weightedx = x .* bw;
%     % % weightedy = y .* bw;
%     % % xcentre = sum(weightedx(:)) / sum(bw(:));
%     % % ycentre = sum(weightedy(:)) / sum(bw(:));
%     % % 
%     % % figure; imshow(bw,[]);
%     % % hold on;
%     % % plot(ycentre,xcentre,'go','MarkerSize',12);
%     % % hold off;
% %     figure; imshow(Aoriginal{1})
% %     bw = imcomplement(logical(A));
%     bw = A;
%     labelarray = bwlabel(bw);
%     measurements = regionprops(labelarray, 'Centroid');
%     figure; imshow(bw,[]);
%     hold on;
%     centmeasure = [];
%     for i=1:length(measurements)
%         plot(measurements(i,1).Centroid(1,1),measurements(i,1).Centroid(1,2),'go','MarkerSize',12);
%         centmeasure(i,1) = measurements(i,1).Centroid(1,1);
%         centmeasure(i,2) = measurements(i,1).Centroid(1,2);
%     end
%     
%     %AVERAGE CENTER OF MASSES
% %     sumx=0;
% %     sumy=0;
% %     centersum = 0;
% %     for i=1:length(measurements)
% %         sumx = measurements(i,1).Centroid(1,1)+sumx;
% %         sumy = measurements(i,1).Centroid(1,2)+sumy;
% %         centersum = centersum+1;
% %     end
% %     plot(sumx/centersum,sumy/centersum,'bo','MarkerSize',12);
%     hold off;
%     %%
% %     figure; imshow(imm,[]);hold on; plot(CC(:,1),CC(:,2),'kx','MarkerSize',15,'LineWidth',3);
% % %     plot(sumx/centersum,sumy/centersum,'bo','MarkerSize',15,'LineWidth',3);
% %     plot(centmeasure(:,1),centmeasure(:,2),'bo','MarkerSize',12);
% %     hold off;
%     %%
% %     centerpoint = [sumx/centersum,sumy/centersum];
% %     CCenter = CC; k = []; kk = [];
% %     for i = 1:3
% %         k(i) = dsearchn(CCenter,centerpoint);
% %         kk(i) = k(i);
% %         CClength = length(CCenter);
% %         CCenter(k(i),:) = [];
% %         if i>1 && k(i)<= kk(i-1) && k(i) ~= CClength
% %             k(i) = k(i)+(i-1);
% %         end
% %     end
% %     figure; imshow(im,[]);hold on; 
% %     for i=1:length(k)
% %         plot(CC(k(i),1),CC(k(i),2),'kx','MarkerSize',15,'LineWidth',3);
% %     end
% %     plot(sumx/centersum,sumy/centersum,'bo','MarkerSize',15,'LineWidth',3);hold off;


















%% Plot original image with biggest (radii) hough transform circle
    
    
    for q = 1:length(Amorph)
%         figure
        ii = candinfopos(onhcandidatepos(q));
            img = images.readimage(ii);
            img = mat2gray(img(:,:,1)).*mat2gray(Amorph{q});
%             imshow(img)
%             ZWindowedMarked  = insertShape(imm, 'rectangle', [(sector(1,1)-1)*pixelxstep (sector(1,2)-1)*pixelystep windowx windowy],'linewidth',9);
%             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(sector(2,1)-1)*pixelxstep (sector(2,2)-1)*pixelystep windowx windowy],'linewidth',5);
%             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(sector(3,1)-1)*pixelxstep (sector(3,2)-1)*pixelystep windowx windowy],'linewidth',3);
%             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(sector(4,1)-1)*pixelxstep (sector(4,2)-1)*pixelystep windowx windowy],'linewidth',3);
%             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(sector(5,1)-1)*pixelxstep (sector(5,2)-1)*pixelystep windowx windowy],'linewidth',3);
%             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(sector(6,1)-1)*pixelxstep (sector(6,2)-1)*pixelystep windowx windowy],'linewidth',3);
% %             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [immatONH(numim,1)-ONHbox immatONH(numim,2)-ONHbox ONHbox*2 ONHbox*2],'linewidth',5,'Color', {'blue'},'Opacity',0.7);
%             hold on
%             imshow(ZWindowedMarked)
    end
    
    
 %% LU'S SEGMENTATION
  addpath(genpath('../'));
 name = numim;
Hvalue = 40; structelement = 20;
 %read and input image if exists, else preprocess         
            if strcmp(imagefiledirectory,'STARE') == 1
                preprocessedfile = sprintf('..\preprocessedImages\\STARE%s_H%i_SE%i.jpg',name,Hvalue,structelement);
            elseif strcmp(imagefiledirectory,'DRIVE') == 1
                preprocessedfile = sprintf('..\\preprocessedImages\\DRIVE%i_H%i_SE%i.jpg',name,Hvalue,structelement);
            elseif strcmp(imagefiledirectory,'Messidor') == 1
                preprocessedfile = sprintf('..\preprocessedImages\\Messidor%s_H%i_SE%i.jpg',name,Hvalue,structelement);
            end
            
            
            if exist(preprocessedfile)==2
                ipsup = imread(preprocessedfile);
                imbw = logical(ipsup(:,:,1));
%                 figure; imshow(imbw) 
            else
                  disp('Nope, no preprocessed image...proceeding to Vessel Reconstruction')
                [LaBimg] = MainVesselRTAll(imm,imagefiledirectory,structelement,Hvalue);
                vesselfinished = sprintf('Finished reconstructing vessels, %.02f minutes',toc./60);
                disp(vesselfinished);

                ipsup = LaBimg;
                imbw = logical(ipsup);
                figure; imshow(imbw)
%                 
%                 % SAVE VESSEL SEGMENTATION IMAGE
%                 pict = sprintf('%s%s%s_H%i_SE%i.jpg','preprocessedImages\',imagefiledirectory,name,Hvalue,...
%                 structelement);
%                 AxesH = gca;   % Not the GCF
%                 F = getframe(AxesH);
%                 imwrite(F.cdata, pict);      
            end
 
 
 
 %%
 
 Hvalue = 5; structelement = 1;
        yrange = boxco{onhcandidatepos(q),1}{1,1}(1,1):boxco{onhcandidatepos(q),1}{1,1}(1,end);
        xrange = boxco{onhcandidatepos(q),2}{1,1}(1,1):boxco{onhcandidatepos(q),2}{1,1}(1,end);
        imbox = imm(yrange,xrange,1:3);
        
%     windowx=floor(size(imm,2)/4);
%     windowy=floor(size(imm,1)/4);
%     pixelxstep = floor(windowx/2);
%     pixelystep = floor(windowy/2);       
        
%         imbwbox = imbw(yrange,xrange);
 addpath(genpath('../'));
 
 onhposition = onhcenter(numim, imagefiledirectory);
 
% figure; imshow(imbwbox)
% figure; imshow(imbox)
% ipsup = MainVesselRT(imbox,structelement,Hvalue);
% imbw = logical(ipsup);
% % imbw = ipsup;
% figure; imshow(imbw)


%% lusegmentation2 - my version
figure
segmentedcandidates = {};
for q = 1:size(onhcandidatepos,1)
        yrange = boxco{onhcandidatepos(q),1}{1,1}(1,1):boxco{onhcandidatepos(q),1}{1,1}(1,end);
        xrange = boxco{onhcandidatepos(q),2}{1,1}(1,1):boxco{onhcandidatepos(q),2}{1,1}(1,end);
        imbox = imm(yrange,xrange,1:3); 
        imbwbox = imbw(yrange,xrange);
 addpath(genpath('../'));
% subplot(2,size(onhcandidatepos,1),q)
% imshow(imbox)
% figure; imshow(imbwbox)
% figure; imshow(imbox)

%% Fit best fit circle
    x = []; y =[];
    for i = 1:size(Amorph{1,q},1)
        for j = 1:size(Amorph{1,q},2)
            if Amorph{1,q}(i,j) == 0
                x = [x,j];
                y = [y,i];
            end
        end
    end

ii = candinfopos(onhcandidatepos(q));
    img = images.readimage(ii);
         th = linspace(0,2*pi,20)';      
   % reconstruct circle from data
   subplot(2,size(Amorph,2),q);imshow(img),hold on
   [xc,yc,Re,a] = circfit(x,y);
     xe = Re*cos(th)+xc; ye = Re*sin(th)+yc;
    plot([xe;xe(1)],[ye;ye(1)],'b-.'),
%      title(' measured fitted and true circles')
% %       legend('measured','fitted','true')
%      xlabel x, ylabel y 
     axis equal
     hold off;

[segmented] = lusegmentation2(name,imbox, imbwbox,xc,yc,Re,a);
segmentedcandidates{q} = {segmented};
% subplot(2,size(onhcandidatepos,1),q+size(onhcandidatepos,1))
% imshow(segmented)
th = linspace(0,2*pi,20)'; 
ReB = segmented(1,1); xcB = segmented(1,2); ycB = segmented(1,3);
subplot(2,size(Amorph,2),q+size(Amorph,2));imshow(imbox),hold on
    xeB = ReB*cos(th)+xcB; yeB = ReB*sin(th)+ycB;
    plot([xeB;xeB(1)],[yeB;yeB(1)],'b-.'); hold off;

end

%%
%Choose the best ONH candidate based on the amount of
%hightest intensity encircled by segmentation circle
maxbrIt = [];th = linspace(0,2*pi,20)'; 
for q = 1:size(onhcandidatepos,1)
    ii = candinfopos(onhcandidatepos(q));
    img = images.readimage(ii);
    img = mat2gray(img);
%     figure;imshow(img)
    seg = segmentedcandidates{1,q}{1};
    ReB = seg(1,1); xcB = seg(1,2); 
    ycB = seg(1,3);

    brIt = 0;
    for i = th(1):th(end)
    %         xe = Re*cos(i)+xc; ye = Re*sin(i)+yc;
    xx = 0;yy = 0;
        for r = 0:1:ReB
            xx = (r)*cos(i)+xcB; yy = (r)*sin(i)+ycB;
            if (round(xx)<=size(img,2) &&  round(xx)>=1) ...
                    && (round(yy)<=size(img,1) &&  round(yy)>=1)
                brIt = brIt+img(round(yy),round(xx));
            end
        end
    end
    maxbrIt = [maxbrIt;q,brIt];
end
%% Plot entire image with segmented ONH
[M,I] = max(maxbrIt(:,2),[],1);
q = I;
% for q = 1:size(onhcandidatepos,1)
    yrange = boxco{onhcandidatepos(q),1}{1,1}(1,1):boxco{onhcandidatepos(q),1}{1,1}(1,end);
    xrange = boxco{onhcandidatepos(q),2}{1,1}(1,1):boxco{onhcandidatepos(q),2}{1,1}(1,end);
    
    seg = segmentedcandidates{1,q}{1};
    ReB = seg(1,1); xcB = seg(1,2)+boxco{onhcandidatepos(q),2}{1,1}(1,1); 
    ycB = seg(1,3)+boxco{onhcandidatepos(q),1}{1,1}(1,1);
    
    figure;imshow(imm); hold on;
    th = linspace(0,2*pi,20)';
    xeB = ReB*cos(th)+xcB; yeB = ReB*sin(th)+ycB;
    plot([xeB;xeB(1)],[yeB;yeB(1)],'b-.','LineWidth', 5 ); 
    plot(onhposition(1,1),onhposition(1,2),'xw');plot(xcB,ycB,'xb');
    hold off;

    
    
%% VALIDATION

distance=sqrt((xcB-onhposition(1,1)).^2+(ycB-onhposition(1,2)).^2);
distcomment = sprintf('distance between gold standard onh and computer onh: %0.02f pixels',distance);
disp(distcomment)
