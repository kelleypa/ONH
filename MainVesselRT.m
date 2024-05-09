function [LaBimg] = MainVesselRT(im);

%% image reading
f=double(im);
% figure(1),imshow(uint8(f));
% ch2=f(:,:);
[R,C] = size(f(:,:));
% [R,C] = size(f);

f=250-f(:,:);

%% mask creation
mask = im2bw(im2double(f), 0.9);
mask = imopen(mask,ones(21));
mask = uint8(imerode(mask,ones(21)));

%% preprocessing
% se = strel('disk',5);
% ch2 = double (imtophat(f, se) );
% 
% %figure(imindex);	imshow(ch2);	imindex = imindex+1;
% ch2 = uint8 (ch2 .* 255 ./ max(max(max(ch2)) ));
% 
% H = fspecial('average', 50);
% ch2 = double(abs(ch2 - imfilter(ch2, H)));
% ch2 = uint8 (ch2 .* 255 ./ max(max(max(ch2))));
%% --------------- preprocessing ---------------------
ref = imread('retinal images\3.jpg');
ghist = imhist(ref(:,:,2));


%f=imread('D:\Sim\MA\Media\image20.bmp');
% f=imread('D:\Sim\MA\Media\fundus images\image032.png');
f=im;
ch2 = histeq(f(:,:,2), ghist);	
f(:,:,2)=ch2;

[R,C,D]=size(f);

fg = f(:,:,2);
n=20;	imindex = 1;
fg = adapthisteq(fg, 'NumTiles', [floor(R/n/2)+2 floor(C/n/2)+2]);
fg = 255-fg;
% figure(imindex);	imshow(fg);	imindex = imindex+1;
% title('imindex')

%%

se = strel('disk',2);
ch2 = double (imtophat(fg, se) );
% figure(imindex);	imshow(ch2);	imindex = imindex+1;
H = fspecial('average', 40);
ch2 = double(abs(ch2 - imfilter(ch2, H)));
ch2 = uint8 (ch2 .* 255 ./ max(max(max(ch2))));
% figure(imindex);	imshow(ch2);	imindex = imindex+1;
%%
n=12;								%######### Subimage Size
stp=5;								%######### Overlap Control
% LinVldThr = 0.5;  					%######### Line Validation
LinVldThr = .5;

BlkMsk=ones(n,n);
nh=fix(n/2)+1;
rad2=nh^2;
for r=1:n;
	for c=1:n;
		if (r-nh)^2+(c-nh)^2>rad2;
			BlkMsk(r,c)=0;
		end
	end
end

msk=zeros(R, C, 'uint8');
for r=1:fix(n/stp):R-n+1
	for c=1:fix(n/stp):C-n+1
		fl=ch2(r:r+n-1,c:c+n-1);
		[mx LineStrt LineEnd LineAngle LineVld]=LocRadVes(fl,BlkMsk);
		if LineVld>(LinVldThr/n)
			ml=zeros(n,n);			mz=zeros(n,n);
			ml(:,LineStrt:LineEnd)=1;
			ml=[mz ml mz; mz ml mz; mz ml mz];
			ml=imrotate(ml,LineAngle,'crop');
			mskl=uint8(ml(n+1:2*n,n+1:2*n));
			f2=fl(:,:,1);	f2=f2.*mskl;		t1=mean(f2(f2~=0));
			f2=fl(:,:,1);	f2=f2.*(1-mskl);	t2=mean(f2(f2~=0));
			f2=fl(:,:,1);	f2=uint8(im2bw(im2double(255-f2), 1-(t1+t2)/2/255));
%			f2=fl;  f2=uint8(im2bw(im2double(255-f2), 0.9));
			mskl=mskl.*(1-f2(:,:,1));
			msk(r:r+n-1,c:c+n-1) = msk(r:r+n-1,c:c+n-1)|mskl;
		end
	end
end


%% MA detection
mskopen = uint8 (bwareaopen(msk,40) );

mskdil = imdilate(mskopen, ones(8,'uint8'));
LaBimg=mskdil;

% ch2 = ch2 .* (1 - mskdil);




end
