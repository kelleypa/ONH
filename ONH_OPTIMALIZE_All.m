warning off;
clc
clear all
close all

%% NOTE:
%%FORMAT of image data, how x and y components are saved in columns and rows:
% immatONH = [x,y]
    %immatONH = [x1,y1; x2,y2; ...];
% imm = [y,x]
    %imm = [y1,x1; y2,x2; ...];
% boxco = [y,x]
    %boxco = [y1,x1; y2,x2; ...];

%% MESSIDOR IMAGES BASE 11 + 12

%Create cell with all image names from folder using 'Mess' + '00#'
immat = {};
for i = 1:200
    if i<=999
        immat{1,i} =sprintf('Mess%s',num2str(i,'%04i'));
    else
        immat{1,i} =sprintf('Mess%i',i);
    end
end

immatONH = [1700,700; 1510,790; 760,700; 1460, 710; 800,735;...
    1630,830; 760,700; 1520, 750; 760,770; 1500,775;...
    770,750; 810,710; 1440, 700; 1500,720; 660,600;...
    1525,725; 780,720; 740,810; 1475,725; 780,740;...
    ...
    1525,725; 770,690; 1450,745; 800,730; 1510,800;...
    750,720; 775,700; 1500,775;  620,790; 850,720;...
    1560,725; 1300,710; 1500,730; 790,690; 1500,700;...
    775,760; 1550,760; 760,820; 1520,785; 750,720;...
    ...
    1675,710; 640,680; 1540,710; 760,730; 1490,715;...
    1530,760; 770,680; 780,690; 1475,760; 875,740;...
    1500,735; 770,770; 1500,730; 800,700; 1500,700;...
    760,710; 1700,730; 550,720; 620,660; 1525,760;...
    ...
    820,700; 1460,760; 820,750; 1500,690; 770,700;...
    1450,780; 650,800; 1500,720; 770,700; 1460,730;...
    840,785; 1520,730; 780,730; 1620,660; 810,700;...
    1400,790; 850,730; 1470,680; 800,720; 1475,790;...
    ...
    820,700; 1490,840; 810,685; 1525,710; 575,725;...
    1650,710; 750,770; 1470,760; 790,700; 1630,810;...
    800,735; 1470,700; 850,670; 1675,700; 800,740;...
    1510,740; 810,690; 1500,740; 800,760; 1510,790;...
    ...
    800,675; 1450,750; 860,735; 1470,680; 830,700;...
    1480,750; 820,720; 1635,700; 600,740; 1480,740;...
    790,640; 1525,725; 765,700; 1460,720; 835,720;...
    1640,755; 755,740; 1535,760; 745,650; 1550,730;...
    ...
    760,720; 1530,740; 1510,700; 770,700; 1470,710;...
    830,775; 1500,650; 800,680; 1485,780; 800,710;...
    1460,750; 820,700; 1520,680; 760,780; 1600,710;...
    810,770; 1480,740; 820,690; 1500,750; 820,720;...
    ...
    1500,740; 780,740; 1520,720; 795,710; 1545,710;...
    760,680; 1430,750; 870,700; 1520,725; 830,670;...
    1480,680; 800,710; 1475,720; 780,815; 1540,705;...
    750,750; 780,700; 1510,790; 810,720; 1530,725;...
    ];
imleng = size(immat,2);
imagefiledirectory = 'Messidor';
ONHbox = 150;
%% Change Messidor image names to 'Mess' + '00#'
%%SOURCE: https://www.mathworks.com/matlabcentral/answers/123462-how-to-rename-images-from-a-series-of-folder
% mainDirectory = 'C:\Users\kelleypa\Desktop\ImgNameChange';
% 
% i = 1;
% subFolder = dir(fullfile(mainDirectory,'*.tif'));
% fileNames = {subFolder.name};
% for iFile = 1 : numel( subFolder )
%     if i<=999
%          newName = fullfile(mainDirectory, sprintf('Mess%s.tif',num2str(i,'%04i')));
%          movefile( fullfile(mainDirectory, fileNames{ iFile }), newName );
%          i = i+1;
%     else
%         newName = fullfile(mainDirectory, sprintf('Mess%i.tif',i));
%         movefile( fullfile(mainDirectory, fileNames{ iFile }), newName );
%         i=i+1;
%     end
% end 
%%



%% DRIVE IMAGES
%Create cell with all image names from folder using '00#' + 'test' or
%'training'

% immat = {};
% for i = 1:40
%     if i<=20
%         immat{1,i} =sprintf('%s_test',num2str(i,'%02i'));
%     else
%         immat{1,i} =sprintf('%s_training',num2str(i,'%02i'));
%     end
% end
% immatONH = [85, 260; 460, 275; 100, 280; 360, 275; 80,260;...
%     460,270; 490,285; 485,280; 95,270; 470,280;...
%     75,275; 80,260; 490,270; 480,275; 195, 280;...
%     480,260; 465,265; 470,260; 485,275; 480,280;...
%     75,255; 470,275; 430,225; 477,287; 465,273;...
%     80, 250; 485,283; 490,265; 495,275; 493,290;...
%     390,250; 490,285; 470,305; 385,225; 85,280;...
%     475,280; 490,290; 490,270; 95, 260; 492,280;];
% ONHbox = 50;
% imleng = size(immat,2);
% imagefiledirectory = 'DRIVE';
%%


%% STARE IMAGES

% % For continuous case: im0001,im0002,...,im0077
% % immat = {};
% % for i = 1:77
% %     immat{1,i} =sprintf('im%s',num2str(i,'%04i'));
% % end
% 
% % BUT because the naming of the images in STARE are not continuous (im0047,
% % im0049 (no im0048), this approach allows for these jumps!
% 
% mainDirectory = 'C:\Users\kelleypa\Desktop\ONH\STARE';
% %Flash drive directory:
% % mainDirectory = 'F:\ONH\STARE';
% subFolder = dir(fullfile(mainDirectory,'*.jpg'));
% immat = {subFolder.name};
% %remove .jpg from immat file name
% for i = 1:length(immat)
%     immat{1,i} = strrep(immat{1,i}, '.jpg', '');
% end
% 
% immatONH = [57, 270; 95, 275; 57, 260; 600,225; 460,310;...
%     625,215; 53, 275; 105, 280; 135, 223; 505,260;...
%     175,270; 120, 290; 640,290; 240,220; 575,240;...
%     590,350; 645,360; 540,285; 170,280; 630,290;...
%     ...
%     300,270; 490,265; 330,250; 370,305; 365,290;...
%     250,270; 50,310; 300,290; 325,280; 330,310;...
%     515,310; 105,240; 575,290; 600,250; 580,300;...
%     540,415; 585,343; 445,255; 585,350; 350,290;...
%     ...
%     50,200; 490,95; 470,275; 570,170; 520,320;...
%     110,240; 330,290; 565,250; 650,280; 605,305;...
%     60,260; 340,285; 60,220; 650,280; 630,260;...
%     160,285; 330,320; 380,245; 590,305; 650,190;...
%     ...
%     245,325; 400,280; 625,350; 340,275; 140,265;...
%     110,211; 545,360; 450,275; 60,305; 610,345;...
%     460,265; 375,280; 500,305; 540,298; 320,320;...
%     533,288; 360,360;];
% ONHbox = 50;
% imleng = size(immat,2);
% imagefiledirectory = 'STARE';
%%

% ONHbox = 100;



%% FIND ONH for each PIC

% close all
% 
% pic = 1;
% % STARE ONHs
% file = sprintf('STARE\\%s.jpg',immat{1,pic})
% ONHbox = 50;
% immatONH = [57, 270; 95, 275; 57, 260; 600,225; 460,310;...
%     625,215; 53, 275; 105, 280; 135, 223; 505,260;...
%     175,270; 120, 290; 640,290; 240,220; 575,240;...
%     590,350; 645,360; 540,285; 170,280; 630,290;...
%     ...
%     300,270; 490,265; 330,250; 370,305; 365,290;...
%     250,270; 50,310; 300,290; 325,280; 330,310;...
%     515,310; 105,240; 575,290; 600,250; 580,300;...
%     540,415; 585,343; 445,255; 585,350; 350,290;...
%     ...
%     50,200; 490,95; 470,275; 570,170; 520,320;...
%     110,240; 330,290; 565,250; 650,280; 605,305;...
%     60,260; 340,285; 60,220; 650,280; 630,260;...
%     160,285; 330,320; 380,245; 590,305; 650,190;...
%     ...
%     245,325; 400,280; 625,350; 340,275; 140,265;...
%     110,211; 545,360; 450,275; 60,305; 610,345;...
%     460,265; 375,280; 500,305; 540,298; 320,320;...
%     533,288; 360,360;];

% % DRIVE ONHs
% ONHbox = 50;
% file = sprintf('DRIVE\\%s.tif',immat{1,pic})
% immatONH = [85, 260; 460, 275; 100, 280; 360, 275; 80,260;...
%     460,270; 490,285; 485,280; 95,270; 470,280;...
%     75,275; 80,260; 490,270; 480,275; 195, 280;...
%     480,260; 465,265; 470,260; 485,275; 480,280;...
%     75,255; 470,275; 430,225; 477,287; 465,273;...
%     80, 250; 485,283; 490,265; 495,275; 493,290;...
%     390,250; 490,285; 470,305; 385,225; 85,280;...
%     475,280; 490,290; 490,270; 95, 260; 492,280;];


close all
warning('off','all')
beep off
% warning

%Messidor ONHs
% ONHbox = 150;
% pic = 160;
% file = sprintf('Messidor\\%s.tif',immat{1,pic});
% immatONH = [1700,700; 1510,790; 760,700; 1460, 710; 800,735;...
%     1630,830; 760,700; 1520, 750; 760,770; 1500,775;...
%     770,750; 810,710; 1440, 700; 1500,720; 660,600;...
%     1525,725; 780,720; 740,810; 1475,725; 780,740;...
%     ...
%     1525,725; 770,690; 1450,745; 800,730; 1510,800;...
%     750,720; 775,700; 1500,775;  620,790; 850,720;...
%     1560,725; 1300,710; 1500,730; 790,690; 1500,700;...
%     775,760; 1550,760; 760,820; 1520,785; 750,720;...
%     ...
%     1675,710; 640,680; 1540,710; 760,730; 1490,715;...
%     1530,760; 770,680; 780,690; 1475,760; 875,740;...
%     1500,735; 770,770; 1500,730; 800,700; 1500,700;...
%     760,710; 1700,730; 550,720; 620,660; 1525,760;...
%     ...
%     820,700; 1460,760; 820,750; 1500,690; 770,700;...
%     1450,780; 650,800; 1500,720; 770,700; 1460,730;...
%     840,785; 1520,730; 780,730; 1620,660; 810,700;...
%     1400,790; 850,730; 1470,680; 800,720; 1475,790;...
%     ...
%     820,700; 1490,840; 810,685; 1525,710; 575,725;...
%     1650,710; 750,770; 1470,760; 790,700; 1630,810;...
%     800,735; 1470,700; 850,670; 1675,700; 800,740;...
%     1510,740; 810,690; 1500,740; 800,760; 1510,790;...
%     ...
%     800,675; 1450,750; 860,735; 1470,680; 830,700;...
%     1480,750; 820,720; 1635,700; 600,740; 1480,740;...
%     790,640; 1525,725; 765,700; 1460,720; 835,720;...
%     1640,755; 755,740; 1535,760; 745,650; 1550,730;...
%     ...
%     760,720; 1530,740; 1510,700; 770,700; 1470,710;...
%     830,775; 1500,650; 800,680; 1485,780; 800,710;...
%     1460,750; 820,700; 1520,680; 760,780; 1600,710;...
%     810,770; 1480,740; 820,690; 1500,750; 820,720;...
%     ...
%     1500,740; 780,740; 1520,720; 795,710; 1545,710;...
%     760,680; 1430,750; 870,700; 1520,725; 830,670;...
%     1480,680; 800,710; 1475,720; 780,815; 1540,705;...
%     750,750; 780,700; 1510,790; 810,720; 1530,725;...
%     ];
% 
% % pic = 50;
% % file = sprintf('STARE\\%s.jpg',immat{1,pic})
% 
% 
% % 
% imm=imread(file);
% imleng = size(imm);
% figure
%  ZWindowedMarked  = insertShape(imm, 'rectangle', [immatONH(pic,1)-ONHbox immatONH(pic,2)-ONHbox 2*ONHbox 2*ONHbox],'linewidth',5);
% imshow(ZWindowedMarked,[]); hold on
% plot(immatONH(pic,1),immatONH(pic,2),'xw')
% tit = sprintf('%s : Position %i', immat{1,pic},pic);
% title(tit)

%% INITIALIZATION
close all;
Accuracy = [];
ONHAccuracy = [];
maxONHAccuracy = [];
tottime = 0;

% Automatically select the database number
% db1 = DRIVE, db2 = STARE, db3 = Messidor
if strcmp(imagefiledirectory,'DRIVE') == 1
    db = 1;
    extracand = 25;
elseif strcmp(imagefiledirectory,'STARE') == 1
    db = 2;
    extracand = 10;
elseif strcmp(imagefiledirectory,'Messidor') == 1
    db = 3;
    extracand = 50;
end


%RANGE OF Hvalue and SE and number of images (numimim)
% Hvalrange = 5:5:100;
% structelementrange = 1:2:40;
% numimim = 1:length(immat);

Hvalrange = 40:40;
structelementrange = 20:20;
numimim = 26:200;
% numimim = 1:length(immat);

% % % Hvalrange = [20,25,40,50,75,100];
% % % structelementrange = [10,15,20,25,30];
% % % numimim = [1:5,29:43];



% numimim2 = [4,18,29,31,32,41,42,58,64,74,79,86,103,109,132];
% numimim = setdiff(1:80,numimim2);
imleng = length(numimim);
%% MAIN PROGRAM!!!

%%SKIP CODE
% skip =1;
% matHse = [10, 4; 10, 8; 10, 10; 15, 4; 15, 8; 15, 10; 20, 2; 25, 2];

for Hvalue = Hvalrange
    for structelement = structelementrange
%         close all
        %% SKIP CODE - IF NOT THESE H or SE then continue
%         if Hvalue == matHse(skip,1) && structelement == matHse(skip,2)
%             skip = skip+1;
%         else
%             continue
%         end

%%
        filename = sprintf('%sdb%i_nohits_%iimages_H_%i_SE_%i.txt','parameterspace\',db,imleng,Hvalue,structelement);
        
        %nohitvalcount starts at one because it'll be a placeholder for a cell
        nohitvalcount = 1;
        nohitimages = {};
        nohitimagenumbs = [];
        %incase file exists already, continue to next parameters
%         if exist(filename, 'file')==2
%             continue
%         else
            
        for numim=numimim
            
            close all
            tic 
            tottime = tottime+tic;
            
            %read and input image         
            if strcmp(imagefiledirectory,'STARE') == 1
                file = sprintf('%s\\%s.jpg',imagefiledirectory,immat{1,numim});
            else
                file = sprintf('%s\\%s.tif',imagefiledirectory,immat{1,numim});
            end
            
            %% remove everything but the number of the image:
            name = immat{1,numim};
            %Remove underscores _ 
            name = strrep(name,'_','');
            %Remove numbers at beginning of file and put numbers at end of file           
            index = isletter(name);
            ii = 0;
            for i = 1:length(index)
                if ii == length(index)
                    break
                elseif index(i) == 1
                    name(abs(i-ii)) = '';
                    ii = ii + 1;
                end
            end
            imagenumber = name;            
            %%
%% SKIP CODE - IF Below 96% skip rest (90% for STARE)

        if (size(numimim,2)-size(nohitimages,1))/size(numimim,2) < 0.90
            ONHcandimage = str2num(name);
            Accuracy = [Accuracy; Hvalue, structelement, 666, 666];
            ONHAccuracy = [ONHAccuracy; ONHcandimage, Hvalue,structelement,666,666,666];
            maxONHAccuracy = [maxONHAccuracy; ONHcandimage, Hvalue,structelement,...
                    666,666,666];
            break
        end
%%
            rundisp = sprintf('\n%s, Hvalue = %i,SE = %i',file,Hvalue,structelement);
            disp(rundisp)
            imm = imread(file);          
            %% MASKING + FITTED MASKING CIRCLE!
            
            %%mask creation
            mask = im2bw(im2double(imm(:,:,1)));
%             imshow(mask,[])
            mask = imopen(mask,ones(51));
            mask = uint8(imerode(mask,ones(21)));
%             figure;            imshow(mask,[])
%             mmask = mask;
%             for i = size(mmask,1)
%                 for j = size(mmask,2)
%                     if mmask(i,j) == 255
%                         mmask(i,j) = 1;
%                     end
%                 end
%             end
%             for a=1:3
%                 mask(:,:,a) = mmask;
%             end

            % figure;	imshow(mask);
            % im=(imread('retinal images\im0008(stare).jpg'));
            %FALSE POSITIVE
            % im=(imread('retinal images\im0036(stare).jpg'));
%             imm=imm(:,:,2);
        %     im=double(rgb2gray(imm));
        %     figure,imshow(im,[])

            %% BETTER VESSEL RECONSTRUCTION THAN LAPLACE PYRAMID
        %     [LaBimg] = MainCodeProject2Canny(im);
%             Apply masking before imputting it into MainVesselRT

%             mask = cat(3,mask,mask,mask);
%             immm = imm.*mask;

%             immm = imm.*mask;
%             figure; imshow(immm,[]);
%             figure; imshow(imm,[]);
            [LaBimg] = MainVesselRT(imm,structelement,Hvalue);
            vesselfinished = sprintf('Finished reconstructing vessels, %.02f minutes',toc./60);
            disp(vesselfinished);
            % [LaBimg] = MainCodeProject2Match(im);
            % MainCodeProject2Log
            % MainCodeProject2Match
            ipsup = LaBimg;
%             ipsup = im2uint8(LaBimg).*mask;
            %% Apply mask to ipsup 

            % STARE & DRIVE have inverted vessel reconstruction      
%             if strcmp(imagefiledirectory,'Messidor') == 1
%                 ny=fix(size(ipsup,1)/2)+1;
%                 nx=fix(size(ipsup,2)/2)+1;
%                 rad2=(ny-fix(.04*size(ipsup,1)))^2;
%                 imbw = logical(ipsup);
%                 for r=1:size(imbw,1);
%                     for c=1:size(imbw,2);
%                         if (r-ny)^2+(c-nx)^2>rad2;
%                             imbw(r,c)=1;
%                         end
%                     end
%                 end
%                 
%                 
%                 figure
%                 title('Logicalimg')
%                 imshow(imbw)
%                 
%                 
%                 
%             else
%                 ny=fix(size(ipsup,1)/2)+1;
%                 nx=fix(size(ipsup,2)/2)+1;
%                 rad2=(ny-fix(.04*size(ipsup,1)))^2;
%                 imbw = logical(ipsup);
%                 for r=1:size(imbw,1);
%                     for c=1:size(imbw,2);
%                         if (r-ny)^2+(c-nx)^2>rad2;
%                             imbw(r,c)=0;
%                         end
%                     end
%                 end
%                 figure
%                 title('Logicalimg')
%                 fig = imshow(imbw);
%             end            
imbw = logical(ipsup);  
figure; imshow(imbw)
%% SAVE VESSEL SEGMENTATION IMAGE
pict = sprintf('%s%s%s_H%i_SE%i.jpg','preprocessedImages\',imagefiledirectory,name,Hvalue,...
    structelement);
    AxesH = gca;   % Not the GCF
    F = getframe(AxesH);
    imwrite(F.cdata, pict);
%     saveas(gca,pict)

% pict = sprintf('%s%s%s_H%i_SE%i.jpg','preprocessedImages\',imagefiledirectory,name,Hvalue,...
%     structelement);
% saveas(gcf,pict)         
close all
%%  SLIDING WINDOWS

            windowx=floor(size(ipsup,2)/4);
            windowy=floor(size(ipsup,1)/4);
            pixelxstep = floor(windowx/2);
            pixelystep = floor(windowy/2);
            step  = 6;

            %quartile windows
            countf = zeros(step+1,step+1);
            for boxi = 0:step
                for boxj = 0:step
                    k = 0;
                    for i=1:windowx-1
                        for j=1:windowy-1
                            k = imbw(boxj*pixelystep+j,boxi*pixelxstep+i) + k;
                        end
                    end
                    countf(boxi+1,boxj+1)=k;
                end
            end

            % STARE & DRIVE have inverted vessel reconstruction      
            if strcmp(imagefiledirectory,'Messidor') == 1
                [maxA] = max(countf);
            else
                [maxA] = max(countf);
            end
            
%             [maxA] = min(countf);

            maxA = sort(maxA);
            % [m,n] = ind2sub(size(countf),ind)
            [row1,col1] = find(countf==maxA(end),1);
            [row2,col2] = find(countf==maxA(end-1),1);
            [row3,col3] = find(countf==maxA(end-2),1);
            [row4,col4] = find(countf==maxA(end-3),1);
            [row5,col5] = find(countf==maxA(end-4),1);
            [row6,col6] = find(countf==maxA(end-5),1);
            
            %since some of the finds may have doubles:
            row = [row1,row2,row3,row4,row5,row6];
            col = [col1,col2,col3,col4,col5,col6];
            for b=1:length(row)
                for bb=1:length(row)
                    if bb<=b
                        continue
                    else
                        if row(b)==row(bb) && col(b)==col(bb)
                            [rowf,colf] = find(countf==maxA(end-b),2);
                            row(b) = rowf(1);
                            col(b) = colf(1);
                            row(bb) = rowf(2);
                            col(bb) = colf(2);
                        end
                    end
                end
            end
            
            %row and column of sliding windows
            row1 = row(1); row2 = row(2); row3 = row(3);
            row4 = row(4); row5 = row(5); row6 = row(6);
            col1 = col(1); col2 = col(2); col3 = col(3);
            col4 = col(4); col5 = col(5); col6 = col(6);
            
            %Sector row/column candidate box
            sector = [row1, col1; row2, col2; row3, col3; row4, col4; ...
                row5, col5; row6, col6];
            %% Vessel Reconstruction 6 Box Picks
% 
%             figure
%             ZWindowedMarked  = insertShape(imm, 'rectangle', [(row1-1)*pixelxstep (col1-1)*pixelystep windowx windowy],'linewidth',9);
%             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(row2-1)*pixelxstep (col2-1)*pixelystep windowx windowy],'linewidth',5);
%             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(row3-1)*pixelxstep (col3-1)*pixelystep windowx windowy],'linewidth',3);
%             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(row4-1)*pixelxstep (col4-1)*pixelystep windowx windowy],'linewidth',3);
%             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(row5-1)*pixelxstep (col5-1)*pixelystep windowx windowy],'linewidth',3);
%             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(row6-1)*pixelxstep (col6-1)*pixelystep windowx windowy],'linewidth',3);
%             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [immatONH(numim,1)-ONHbox immatONH(numim,2)-ONHbox ONHbox*2 ONHbox*2],'linewidth',5,'Color', {'blue'},'Opacity',0.7);
%             hold on
%             imshow(ZWindowedMarked)
%             
% %        %PAUSE        
%         disp('Press a key !')  % Press a key here.You can see the message 'Paused: Press any key' in        % the lower left corner of MATLAB window.
%         pause;  
%%
%             % gridlines ---------------------------
%             hold on
% 
%             g_y=[0:windowy:size(imm,1)]; % user defined grid Y [start:spaces:end]
%             g_x=[0:windowx:size(imm,2)]; % user defined grid X [start:spaces:end]
%             for i=1:length(g_x)
%                plot([g_x(i) g_x(i)],[g_y(1) g_y(end)],'r:','linewidth',5) %y grid lines
%                hold on    
%             end
%             for i=1:length(g_y)
%                plot([g_x(1) g_x(end)],[g_y(i) g_y(i)],'r:','linewidth',5) %x grid lines
%                hold on    
%             end
%             title(immat{numim});
%             hold off

        %% Accuracy

        boxco = {{((col1-1)*pixelystep):((col1-1)*pixelystep+windowy)},{((row1-1)*pixelxstep):((row1-1)*pixelxstep+windowx)};
            {((col2-1)*pixelystep):((col2-1)*pixelystep+windowy)},{((row2-1)*pixelxstep):((row2-1)*pixelxstep+windowx)};
            {((col3-1)*pixelystep):((col3-1)*pixelystep+windowy)},{((row3-1)*pixelxstep):((row3-1)*pixelxstep+windowx)};
            {((col4-1)*pixelystep):((col4-1)*pixelystep+windowy)},{((row4-1)*pixelxstep):((row4-1)*pixelxstep+windowx)};
            {((col5-1)*pixelystep):((col5-1)*pixelystep+windowy)},{((row5-1)*pixelxstep):((row5-1)*pixelxstep+windowx)};
            {((col6-1)*pixelystep):((col6-1)*pixelystep+windowy)},{((row6-1)*pixelxstep):((row6-1)*pixelxstep+windowx)}};
        boxbox = [row1 col1;row2 col2; row3 col3; row4 col4; row5 col5; row6 col6];
        boxhit = [];
        boxmiss = [];

        xONHbox = [immatONH(numim,1)-ONHbox:1:immatONH(numim,1)+ONHbox];
        yONHbox = [immatONH(numim,2)-ONHbox:1:immatONH(numim,2)+ONHbox];
        %SHOW ONH
%         close all
%         figure
%         imshow(imm(yONHbox,xONHbox,1:3))
%         pause(0.2)
%% MANUALLY TRY TO FIND IF ONH IS IN CANDIDATES (TAKES FOREVER!!!)
%             for i = 1:size(boxco,1)
%             hittrue = 0;
%             
% %           %See how it is looking through each candidate
% %             close all
% %             figure
% %             ZWindowedMarked  = insertShape(imm, 'rectangle', [(boxbox(i,1)-1)*pixelxstep (boxbox(i,2)-1)*pixelystep windowx windowy],'linewidth',9);
% %             ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [immatONH(numim,1)-ONHbox immatONH(numim,2)-ONHbox ONHbox*2 ONHbox*2],'linewidth',5,'Color', {'blue'},'Opacity',0.7);
% %             hold on
% %             imshow(ZWindowedMarked)
% %             pause(0.5)
% %             figure
% %             imshow(imm(boxco{i,1}{1,1}(1,:),boxco{i,2}{1,1}(1,:)))
% %             pause(0.5)
%             
%             for ii=boxco{i,2}{1,1}(1,:)
%                 if hittrue == 1
%                     break
%                 end
%                 for jj=boxco{i,1}{1,1}(1,:)
%                     if hittrue == 1
%                         break
%                     end
%                         for b = 1:size(xONHbox,2)
%                             if hittrue == 1
%                                     break
%                             end
%                             for bb = 1:size(yONHbox,2)
%                                 if hittrue == 1
%                                     break
%                                 elseif yONHbox(b) == ii && xONHbox(bb) == jj
%                                     boxhit = [boxhit; i];
%                                     hittrue = 1;
%                                 end
%                             end
%                         end
%                 end 
%             end
%             if hittrue == 0
%                  boxmiss = [boxmiss; i];
%             end
%             boxtoc = rectoc - (toc)./60;
%             boxcountfinish = sprintf('Finished checking if candidate %i is a valid ONH, %.02f minutes',i, boxtoc);
%             disp(boxcountfinish);
%             end
%% MATLAB "intersect" COMMAND TO FIND IF ONH IS IN CANDIDATES   
            boxhit = [];
            boxmiss = [];
            Y = yONHbox;
            X = xONHbox;
            CandAcc = [];
%             ONHAccuracy = [];
            
            for i = 1:size(boxco,1)
  
                BoxY = boxco{i,1}{1,1}(1,:);
                BoxX = boxco{i,2}{1,1}(1,:);
                
                hittrue = 0;
                % index vectors ia and ib, such that C = A(ia,:) and C = B(ib,:).
                [XC] = intersect(X,BoxX,'sorted');
                [YC] = intersect(Y,BoxY,'sorted'); 
                
%                 [ONHcandidate] = intersect(XC,YC);
                if isempty(XC) == 0 && isempty(YC) == 0 
                    boxhit = [boxhit; i];
                    %calculate accuracy of how much candidate is inside ONH    
                    ONHxacc = ((max(XC)-min(XC)))./((max(X)-min(X)));
                    ONHyacc = (max(YC)-min(YC))./((max(Y)-min(Y)));
                    ONHacc = ONHxacc.*ONHyacc;
                    ONHcandimage = str2num(name);
%                     ONHAccuracy = [ONHAccuracy; ONHcandimage, Hvalue,structelement,row(i), col(i),ONHxacc,ONHyacc,ONHacc];
                    CandAcc = [CandAcc; sector(i,1), sector(i,2), ONHacc];
                    ONHAccuracy = [ONHAccuracy; ONHcandimage, Hvalue,structelement, sector(i), sector(i), ONHacc];
                    
                else
                    boxmiss = [boxmiss; i];                                           
                end
            end
            
            %if CandAcc is not empty, save max values.
            %also if CandAcc has only one row, don't sort (Matlab will sort
            %column elements which we don't want)
            if ~isempty(CandAcc)
                if size(CandAcc,1) ~= 1
                    maxAcc = sort(CandAcc);
                    maxRow = find(CandAcc(:,3)==maxAcc(end,3),1);
                    %find maximum accuracy (best candidate accuracy)

                    maxONHAccuracy = [maxONHAccuracy; ONHcandimage, Hvalue,structelement,...
                        CandAcc(maxRow,1),CandAcc(maxRow,2),CandAcc(maxRow,3)];
                else
                    maxRow = 1;
                    maxONHAccuracy = [maxONHAccuracy; ONHcandimage, Hvalue,structelement,...
                        CandAcc(maxRow,1),CandAcc(maxRow,2),CandAcc(maxRow,3)];
                end
            else
                ONHcandimage = str2num(name);
                maxONHAccuracy = [maxONHAccuracy; ONHcandimage, Hvalue,structelement,...
                    0,0,0];
            end
%%          


%%
%         %PAUSE        
%         disp('Press a key !')  % Press a key here.You can see the message 'Paused: Press any key' in        % the lower left corner of MATLAB window.
%         pause;    
%%
        [uhit] = unique(boxhit);        
        if size(boxhit,1) == 0
           display('No Hits')

           %% REMEMBER WHICH IMAGES HAD NO HITS (as you run through each image)
            nohitimages{nohitvalcount,1} = file;
            nohitimagenumbs(nohitvalcount,1) = numim;
%         nohitimages{nohitvalcount,2} = {Hvalue, structelement, nohitcount-1, abs((length(numimim)-(nohitcount-1)))/length(numimim)};
            nohitvalcount = nohitvalcount+1;
%         else
%            ZWindowedMarked  = insertShape(imm, 'rectangle', [(boxbox(uhit(1),1)-1)*pixelxstep (boxbox(uhit(1),2)-1)*pixelystep windowx windowy],'linewidth',9);
%            ZWindowedMarked  = insertShape(ZWindowedMarked, 'rectangle', [(boxbox(uhit(2),1)-1)*pixelxstep (boxbox(uhit(2),2)-1)*pixelystep windowx windowy],'linewidth',9);
%            ZWindowedMarked  = insertShape(ZWindowedMarked, 'circle', [immatONH(numim,1) immatONH(numim,2) 10],'linewidth',9);
%            figure
%                 imshow(ZWindowedMarked)
        end
        
%% SAVE CANDIDATES
% % format: db3img35c4
% %where db1 = DRIVE, db2 = STARE, db3 = Messidor; image = img#; c =
% %candidate, nc = not candidate

% if strcmp(imagefiledirectory,'DRIVE') == 1
%     db = 1;
%     extracand = 25;
% elseif strcmp(imagefiledirectory,'STARE') == 1
%     db = 2;
%     extracand = 25;
% elseif strcmp(imagefiledirectory,'Messidor') == 1
%     db = 3;
%     extracand = 100;
% end
% 
% % for valid ONH candidates
% for j = 1:size(boxhit,1)
%     i = boxhit(j);
%     close all
%     %Make sure the extra range is within image
%     yrange = boxco{i,1}{1,1}(1,1)-extracand:boxco{i,1}{1,1}(1,end)+extracand;
%     xrange = boxco{i,2}{1,1}(1,1)-extracand:boxco{i,2}{1,1}(1,end)+extracand;
%     if xrange(1) < 1
%         xrange = 1:xrange(end)+(1-xrange(1));
%     elseif xrange(end) > size(imm,2)
%         xrange = (xrange(1)-(xrange(end)-size(imm,2))):size(imm,2);
%     end
%     if yrange(1) < 1
%         yrange = 1:yrange(end)+(1-yrange(1));
%     elseif yrange(end) > size(imm,1)
%         yrange = (yrange(1)-(yrange(end)-size(imm,1))):size(imm,1);
%     end
%     close all    
%     imshow(imm(yrange,xrange,1:3))
% 
%     filedest = sprintf('%s\\ONHpatches',imagefiledirectory);
%     pict = sprintf('%s\\db%iimg%ic%i.jpg',filedest,db,numim,j);
% %     pict = sprintf('%s\\db%iimg%sc%i.jpg',filedest,db,imagenumber,j);
% %     saveas(gcf,pict)
%     AxesH = gca;   % Not the GCF
%     F = getframe(AxesH);
%     imwrite(F.cdata, pict);
% end
% 
% % for INvalid ONH candidates
% for j = 1:size(boxmiss,1)
%     i = boxmiss(j);
%     close all
%     
%     yrange = boxco{i,1}{1,1}(1,1)-extracand:boxco{i,1}{1,1}(1,end)+extracand;
%     xrange = boxco{i,2}{1,1}(1,1)-extracand:boxco{i,2}{1,1}(1,end)+extracand;
%     %Make sure the extra range is within image
%     if xrange(1) < 1
%         xrange = 1:xrange(end)+(1-xrange(1));
%     elseif xrange(end) > size(imm,2)
%         xrange = (xrange(1)-(xrange(end)-size(imm,2))):size(imm,2);
%     end
%     if yrange(1) < 1
%         yrange = 1:yrange(end)+(1-yrange(1));
%     elseif yrange(end) > size(imm,1)
%         yrange = (yrange(1)-(yrange(end)-size(imm,1))):size(imm,1);
%     end
%     imshow(imm(yrange,xrange,1:3))
%     filedest = sprintf('%s\\nonONHpatches',imagefiledirectory);
%     pict = sprintf('%s\\db%iimg%inc%i.jpg',filedest,db,numim,j);
% %     pict = sprintf('%s\\db%iimg%snc%i.jpg',filedest,db,imagenumber,j);
%     AxesH = gca;   % Not the GCF
%     F = getframe(AxesH);
%     imwrite(F.cdata, pict);
% %     saveas(gca,pict)
% end
% 
% % for complete MISSES - save pure ONH 
% if size(boxhit,1) == 0
%     close all
%     
% %     numim = 58;
% %     file = sprintf('%s\\%s.tif',imagefiledirectory,immat{1,numim});
% %     imm = imread(file);   
%     
%     %Make ONH the same size as the candidates:
%     ycand = boxco{i,1}{1,1}(1,1):boxco{i,1}{1,1}(1,end);
%     xcand = boxco{i,2}{1,1}(1,1):boxco{i,2}{1,1}(1,end);
%     ONHxcandbox = (round(size(xcand,2)/2));
%     ONHycandbox = (round(size(ycand,2)/2));
%     
%     % add one to the xrange(1) & yrange(1) b/c the value starts at 0
%     xrange = (immatONH(numim,1)-ONHxcandbox)-extracand+1:(immatONH(numim,1)+ONHxcandbox)+extracand;
%     yrange = (immatONH(numim,2)-ONHycandbox)-extracand+1:(immatONH(numim,2)+ONHycandbox)+extracand;
%     
%     %Make sure the extra range is within image
%     if xrange(1) < 1
%         xrange = 1:xrange(end)+(1-xrange(1));
%     elseif xrange(end) > size(imm,2)
%         xrange = (xrange(1)-(xrange(end)-size(imm,2))):size(imm,2);
%     end
%     if yrange(1) < 1
%         yrange = 1:yrange(end)+(1-yrange(1));
%     elseif yrange(end) > size(imm,1)
%         yrange = (yrange(1)-(yrange(end)-size(imm,1))):size(imm,1);
%     end
%     imshow(imm(yrange,xrange,1:3))
%     filedest = sprintf('%s\\ONHofNoHits',imagefiledirectory);
%     pict = sprintf('%s\\db%iimg%iONH.jpg',filedest,db,numim);
% %     pict = sprintf('%s\\db%iimg%sONH%i.jpg',filedest,db,imagenumber,j);
%     AxesH = gca;   % Not the GCF
%     F = getframe(AxesH);
%     imwrite(F.cdata, pict);
% %     saveas(gca,pict)
% end


%% SAVE CANDIDATES INTO ONH, partialONH, nonONH
% ONH = complete(c); partialONH = partial(p); nonONH = non-partial(n) or
% miss(m)
if strcmp(imagefiledirectory,'DRIVE') == 1
    db = 1;
    extracand = 25;
elseif strcmp(imagefiledirectory,'STARE') == 1
    db = 2;
    extracand = 25;
elseif strcmp(imagefiledirectory,'Messidor') == 1
    db = 3;
    extracand = 100;
end


% for valid (75%<) ONH candidates and partial ONH candidates
for j = 1:size(boxhit,1)
    i = boxhit(j);
    if CandAcc(j,3) > .69
        
        close all
        %Make sure the extra range is within image
        yrange = boxco{i,1}{1,1}(1,1):boxco{i,1}{1,1}(1,end);
        xrange = boxco{i,2}{1,1}(1,1):boxco{i,2}{1,1}(1,end);
        if xrange(1) < 1
            xrange = 1:xrange(end)+(1-xrange(1));
        elseif xrange(end) > size(imm,2)
            xrange = (xrange(1)-(xrange(end)-size(imm,2))):size(imm,2);
        end
        if yrange(1) < 1
            yrange = 1:yrange(end)+(1-yrange(1));
        elseif yrange(end) > size(imm,1)
            yrange = (yrange(1)-(yrange(end)-size(imm,1))):size(imm,1);
        end
        close all    
        imshow(imm(yrange,xrange,1:3))

        filedest = sprintf('%s\\DB%iONH',imagefiledirectory,db);
        pict = sprintf('%s\\db%iimg%ic%i.jpg',filedest,db,numim,j);
    %     pict = sprintf('%s\\db%iimg%sc%i.jpg',filedest,db,imagenumber,j);
    %     saveas(gcf,pict)
        AxesH = gca;   % Not the GCF
        F = getframe(AxesH);
        imwrite(F.cdata, pict);
    elseif CandAcc(j,3) > .19 && CandAcc(j,3) < 0.7

        close all
        %Make sure the extra range is within image
        yrange = boxco{i,1}{1,1}(1,1):boxco{i,1}{1,1}(1,end);
        xrange = boxco{i,2}{1,1}(1,1):boxco{i,2}{1,1}(1,end);
        if xrange(1) < 1
            xrange = 1:xrange(end)+(1-xrange(1));
        elseif xrange(end) > size(imm,2)
            xrange = (xrange(1)-(xrange(end)-size(imm,2))):size(imm,2);
        end
        if yrange(1) < 1
            yrange = 1:yrange(end)+(1-yrange(1));
        elseif yrange(end) > size(imm,1)
            yrange = (yrange(1)-(yrange(end)-size(imm,1))):size(imm,1);
        end
        close all    
        imshow(imm(yrange,xrange,1:3))

        filedest = sprintf('%s\\DB%ipartialONH',imagefiledirectory,db);
        pict = sprintf('%s\\db%iimg%ip%i.jpg',filedest,db,numim,j);
    %     pict = sprintf('%s\\db%iimg%sc%i.jpg',filedest,db,imagenumber,j);
    %     saveas(gcf,pict)
        AxesH = gca;   % Not the GCF
        F = getframe(AxesH);
        imwrite(F.cdata, pict);
    elseif CandAcc(j,3) < .2
        close all
        %Make sure the extra range is within image
        yrange = boxco{i,1}{1,1}(1,1):boxco{i,1}{1,1}(1,end);
        xrange = boxco{i,2}{1,1}(1,1):boxco{i,2}{1,1}(1,end);
        if xrange(1) < 1
            xrange = 1:xrange(end)+(1-xrange(1));
        elseif xrange(end) > size(imm,2)
            xrange = (xrange(1)-(xrange(end)-size(imm,2))):size(imm,2);
        end
        if yrange(1) < 1
            yrange = 1:yrange(end)+(1-yrange(1));
        elseif yrange(end) > size(imm,1)
            yrange = (yrange(1)-(yrange(end)-size(imm,1))):size(imm,1);
        end
        close all    
        imshow(imm(yrange,xrange,1:3))

        filedest = sprintf('%s\\DB%inonONH',imagefiledirectory,db);
        pict = sprintf('%s\\db%iimg%in%i.jpg',filedest,db,numim,j);
    %     pict = sprintf('%s\\db%iimg%sc%i.jpg',filedest,db,imagenumber,j);
    %     saveas(gcf,pict)
        AxesH = gca;   % Not the GCF
        F = getframe(AxesH);
        imwrite(F.cdata, pict);
    end
end

% for non ONH candidates
for j = 1:size(boxmiss,1)
    i = boxmiss(j);
    close all
    
    yrange = boxco{i,1}{1,1}(1,1):boxco{i,1}{1,1}(1,end);
    xrange = boxco{i,2}{1,1}(1,1):boxco{i,2}{1,1}(1,end);
    %Make sure the extra range is within image
    if xrange(1) < 1
        xrange = 1:xrange(end)+(1-xrange(1));
    elseif xrange(end) > size(imm,2)
        xrange = (xrange(1)-(xrange(end)-size(imm,2))):size(imm,2);
    end
    if yrange(1) < 1
        yrange = 1:yrange(end)+(1-yrange(1));
    elseif yrange(end) > size(imm,1)
        yrange = (yrange(1)-(yrange(end)-size(imm,1))):size(imm,1);
    end
    imshow(imm(yrange,xrange,1:3))
    filedest = sprintf('%s\\DB%inonONH',imagefiledirectory,db);
    pict = sprintf('%s\\db%iimg%im%i.jpg',filedest,db,numim,j);
%     pict = sprintf('%s\\db%iimg%snc%i.jpg',filedest,db,imagenumber,j);
    AxesH = gca;   % Not the GCF
    F = getframe(AxesH);
    imwrite(F.cdata, pict);
%     saveas(gca,pict)
end

%% DISPLAY TIME IT TOOK FOR IMAGE PROCESSING
        
        finished = sprintf('Total elapsed time is %.02f minutes.',toc./60);
        disp(finished);
%         %PAUSE        
%         disp('Press a key !')  % Press a key here.You can see the message 'Paused: Press any key' in        % the lower left corner of MATLAB window.
%         pause;          



        end
        
        
%% NO IMAGE HITS FILE
%Saves which image did not have any candidate that overlaps with the ONH

%         fileID = fopen(filename,'w');
%         formatSpec = '%s\n';
%         if size(nohitimages,1) ~= 0
%             for row = 1:size(nohitimages,1)
% %                 fprintf(fileID,formatSpec,nohitimages{row,1}{1,1});
%                 fprintf(fileID,formatSpec,nohitimages{row,1});
%             end
%         end
%         fclose(fileID);
%         fclose('all');
%         
        %save new nohits file with corresponding image number of runs to actual image
        %number/name
        filenameimgnum = sprintf('%sdb%i_imgnum+nohitsimg_%iimages_H_%i_SE_%i.txt','parameterspace\',db,imleng,Hvalue,structelement);
        fileID = fopen(filenameimgnum,'w');
        formatSpec = '%s\t\t\t%s\n';
        if size(nohitimages,1) ~= 0
            for row = 1:size(nohitimages,1)
%                 fprintf(fileID,formatSpec,nohitimages{row,1}{1,1});
                nohitnum = sprintf('img%i',nohitimagenumbs(row,1));
                fprintf(fileID,formatSpec,nohitnum,nohitimages{row,1});
            end
        end
        fclose(fileID);
        fclose('all');

        
%% TOTAL ACCURACY
%%    
        Accuracy = [Accuracy; Hvalue, structelement, nohitvalcount-1, abs((length(numimim)-(nohitvalcount-1)))/length(numimim)];
               
%         end %ends if statement in case file already exists
        
%         nohitmat = [];
%         for i=1:size(nohitimages{nohitvalcount-1,1})
%             nohitmat = [nohitmat; nohitimages{nohitvalcount-1,1}{i,1}];
%         end
%         dlmwrite(filename, nohitmat);
    end
end


%% SAVE ACCURACY and ONHACCURACY:
close all
filename =  sprintf('%s_db%i_%iimages_H_%i-%i_SE_%i-%i.txt','parameterspace\ACCURACY',db,imleng,Hvalrange(1),Hvalrange(end),...
    structelementrange(1),structelementrange(end));
% Write matrix to a file, delimited by the tab character 
% and using a precision of 3 significant digits.
dlmwrite(filename,Accuracy,'delimiter','\t','precision',3)

filename =  sprintf('%s_db%i_%iimages_H_%i-%i_SE_%i-%i.txt','parameterspace\ONHACCURACY',db,imleng,Hvalrange(1),Hvalrange(end),...
    structelementrange(1),structelementrange(end));
% Write matrix to a file, delimited by the tab character 
% and using a precision of 3 significant digits.
dlmwrite(filename,ONHAccuracy,'delimiter','\t','precision',3)


maxONHAcc = sortrows(maxONHAccuracy);

filename =  sprintf('%s_db%i_%iimages_H_%i-%i_SE_%i-%i.txt','parameterspace\maxONHACCURACY',db,imleng,Hvalrange(1),Hvalrange(end),...
    structelementrange(1),structelementrange(end));
% Write matrix to a file, delimited by the tab character 
% and using a precision of 3 significant digits.
dlmwrite(filename,maxONHAcc,'delimiter','\t','precision',3)

finished = sprintf('\n\n Total Time to Completion is %.02f minutes.',toc./60);
        disp(finished);
% 
% 
% %% PLOT ACCURACY OF PARAMETERS
% clc
% % Hvalrange = 50:50;
% % structelementrange = 5:5;
% 
% imleng = length(numimim);
% accmat = [];
% Hvalr = [];
% structelementr = [];
% numnullhits = zeros(1,imleng+2);
% %Adding this so to count the number of hits with addition of Hval and SE
% %values (hence the imleng+2)
% numhitsHvalSEmat = zeros(length(Hvalrange)*length(structelementrange),imleng+2);
% HvalSEmatcount = 1;
% for Hvalue = Hvalrange
%     for structelement = structelementrange
%         numnullhits = zeros(1,imleng+2);
%         filename = sprintf('%sdb%i_numim_%i_H_%i_SE_%i.txt','parameterspace\',db,imleng,Hvalue,structelement);
%         if exist(filename, 'file')==2
%             Hvalr = [Hvalr, Hvalue];
%             structelementr = [structelementr, structelement];
%             fileID = fopen(filename,'r');
%             nullhits = dataread('file', filename, '%s', 'delimiter', '\n');
%             nullleng = length(nullhits);
%             accuracy = abs(nullleng - imleng)/imleng;
%             accmat = [accmat; Hvalue structelement nullleng imleng accuracy];
% 
%             for i=1:imleng
%                 for j = 1:length(nullhits)
%                     if isequal(immat{1,i},nullhits{j,1})
%                         numnullhits(i+2) = numnullhits(i+2)+1;
%                     end
%                 end
%             end
%             numnullhits(1) = Hvalue;
%             numnullhits(2) = structelement;
%             numhitsHvalSEmat(HvalSEmatcount,:) = [numnullhits];
%             fclose(fileID);
%         else 
%             continue
%         end
%         HvalSEmatcount = HvalSEmatcount+1;
%     end
% end
% 
% % %create a cell from the matrix
% % for j=1:imleng
% %     for i=1:size(numnullhits,1)
% %         matcell{i,j} = numnullhits(i,j);
% %     end
% % end
% 
% %Remove .jpg .tif and .png from table variable name
% for i = 1:imleng
%     k = findstr(immat{1,i}, '.jpg');
%     varimmat{1,i} = strrep(immat{1,i}, '.jpg', '');
%     if isempty(k)
%         k = findstr(immat{1,i}, '.tif');
%         varimmat{1,i} = strrep(immat{1,i}, '.tif', '');
%         if isempty(k)
%             varimmat{1,i} = strrep(immat{1,i}, '.png', ''); 
%         end
%     end
% end
% %Remove spaces with underscores _
% for i = 1:imleng
%     varimmat{1,i} = strrep(varimmat{1,i},' ','_');
% end
% 
% %Remove numbers at beginning of file and put numbers at end of file
% for i = 1:imleng
%     name = varimmat{1,i};
%     index = find(isletter(name),1);
%     if index ~= 1
%         name = sprintf('%s_%s',name(index:end),name(1:index-2));
%         varimmat{1,i} = name;
%     end
%     varimmat{1,i} = name;
% end
% 
% 
% % %Create table & save for the number of images that had null ONH detection
% % T = cell2table(matcell,'VariableNames',varimmat);
% % numfilename = sprintf('%s_%i_H_%i-%i_SE_%i-%i.txt','parameter32im\numnull_',imleng,Hvalr(1),Hvalr(end),...
% %     structelementr(1),structelementr(end));
% % writetable(T,numfilename);
% % 
% % %Open and read file
% % fileID = fopen(filename,'r');
% % numnullhitstable = readtable(numfilename);
% % fclose(fileID);
% 
% 
% 
% %% Added the Hval and SE value to each row for the number of image hits!!!
% % %create a cell from the matrix
% for j=1:imleng+2
%     for i=1:size(numhitsHvalSEmat,1)
%         matcell{i,j} = numhitsHvalSEmat(i,j);
%     end
% end
% %Add in for the first two columns, the Hvalue and the SE Title
% varimmatHvSE = {'Hvalue', 'SE'};
% varimmat = [varimmatHvSE, varimmat];
% %Create table & save for the number of images that had null ONH detection
% T = cell2table(matcell,'VariableNames',varimmat);
% numfilename = sprintf('%sdb%i_numnull_%i_H_%i-%i_SE_%i-%i.txt','parameterspace\',db,imleng,Hvalr(1),Hvalr(end),...
%     structelementr(1),structelementr(end));
% writetable(T,numfilename);
% 
% %Open and read file
% fileID = fopen(filename,'r');
% numnullhitstable = readtable(numfilename);
% fclose(fileID);
% 
% 
% %%
% toc
% close all
% 
% %% FIND OVERALL ACCURACY OF EACH PARAMETER
% Tsum = [];
% for i=1:height(T)
%     Tsum = [Tsum;T{i,1},T{i,2},sum(T{i,3:end})/length(T{i,3:end})];
% end
% 
% %% plot overall accuracy of each parameter
% close all
% clc
% scatter3(Tsum(:,1),Tsum(:,2),Tsum(:,3));
% xlabel('Hvalue');ylabel('Structure Element');zlabel('Accuracy');
% title('Parameters vs Accuracy')
% [maxAcc] = max(accmat(:,5));
% [accrow1,acccol1] = find(accmat(:,5)==maxAcc(end),1);
% optvalue = sprintf('Optimal Hvalue = %i, Optimal se = %i, Accuracy = %0.01f%%',accmat(accrow1,1),accmat(accrow1,2),100*accmat(accrow1,5));
% disp(optvalue)
% pict = sprintf('%sdb%i_numnull_%i_H_%i-%i_SE_%i-%i.jpg','parameterspace\',db,imleng,Hvalr(1),Hvalr(end),...
%     structelementr(1),structelementr(end));
% saveas(gcf,pict)
