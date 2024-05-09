function [mx LStrt LEnd LineAngle LineVld]=locradVes(f,BlkMsk)

TetaStp=2;                          %###########Teta Steps in Rad. Trans.
Level=0.85;                          %###########Line Width Control

[R C]=size(f);
g1=double(f);
g1=g1/255;
immean = mean2(g1);
g1=g1.*BlkMsk;

theta = 0:TetaStp:180;
[Rd,xp] = radon(g1,theta);

[mv mi]=max(Rd);
[mx mc]=max(mv);
mr=mi(mc);

LineAngle=mc*TetaStp;

if LineAngle > 90
	OrtAngle=fix((LineAngle-90)/TetaStp);
else
	OrtAngle=fix((LineAngle+90)/TetaStp);
end

maxcul=Rd(:,mc);
maxcul=maxcul-R*immean;		maxcul=maxcul.*((sign(maxcul)+1)/2);
%figure(10); plot(maxcul);
[mx LinePos]=max(maxcul);

if mx == 0
	LineVld=0;
	LStrt=0;
	LEnd=0;
else
	%LinePos=mr;
	LineVld=mx/R;
	[RR RC]=size(Rd);

	LStrt=LinePos;
	LEnd=LinePos;
	for i=LinePos:-1:1
	    LStrt=i;
	    if maxcul(i)<Level*mx
	        break
		end
	end
	for i=LinePos:1:RC
	    LEnd=i;
	    if maxcul(i)<Level*mx
	        break
		end
	end

	LStrt=LStrt-fix(RR/2)+fix(R/2);
	LEnd=LEnd-fix(RR/2)+fix(R/2);
	%[LStrt LEnd]
	if LStrt<1
	    LStrt=1;
	end
	if LEnd>R
	    LEnd=R;
	end
	%[LStrt LEnd]
end
