function	[A_nm,zmlist,cidx,V_nm]	= zernike(srcDir,output_xlsx_path,n,m)
if exist('srcDir', 'var')
    srcDir=uigetdir('选择文件夹');
end
cd(srcDir);
N = '文件名';
Z = 'zernike矩';
Y = {N,Z};
allnames=struct2cell(dir('*.bmp')); %只处理8位的bmp文件
[k,len]=size(allnames); %获得bmp文件的个数
image_name = cell(len,1);
for ii=1:len%逐次取出文件
img=allnames{1,ii};
image_name{ii,1} = img;

if nargin>0
if nargin==1
	n	= 0;
end
d		= size(img);			
img		= double(img);
xstep		= 2/(d(1)-1);
ystep		= 2/(d(2)-1);
[x,y]		= meshgrid(-1:xstep:1,-1:ystep:1);
circle1		= x.^2 + y.^2;
inside		= find(circle1<=1);
mask		= zeros(d);
mask(inside)	= ones(size(inside));
[cimg,cidx]	= clipimg(img,mask);
z		= clipimg(x+i*y,mask);
p		= 0.9*abs(z);   
theta		= angle(z);
c	= 1;
for order=1:length(n)
	n1	= n(order);
	if nargin<3
		m	= zpossible(n1);		
	end
	for r=1:length(m)
		V_nmt		= zpoly(n1,m(r),p,theta);
		zprod		= cimg.*conj(V_nmt);
		A_nm(c)		= (n1+1)*sum(sum(zprod))/pi;
        disp(image_name(ii));
        disp(A_nm(c));
		zmlist(c,1:2)	= [n1 m(r)];
		if nargout==4
			V_nm(:,c)	= V_nmt;
		end
		c = c+1;
        
        %将提取的特征写入Excel文件
        range=sprintf('B%d:B%d',ii+1,ii+1);
        xlswrite(output_xlsx_path,A_nm,range);
        xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
    end
end
else
end
xlswrite(output_xlsx_path,Y,'A1:B1');
end



function [cimg,cindex,dim]	= clipimg(img,mask)

dim	= size(img);
cindex	= find(mask~=0);
cimg	= img(cindex);
return;

function	[m]	= zpossible(n)
if iseven(n)
	m	= 0:2:n;
else
	m	= 1:2:n;
end
return;

function	[V_nm,mag,phase]	= zpoly(n,m,p,theta)
R_nm	= zeros(size(p));
a	= (n+abs(m))/2;
b	= (n-abs(m))/2;
total	= b;
for s=0:total
	num	= ((-1)^s)*fac(n-s)*(p.^(n-2*s));
	den	= fac(s)*fac(a-s)*fac(b-s);
	R_nm	= R_nm + num/den;
end
mag	= R_nm;
phase	= m*theta;
V_nm	= mag.*exp(i*phase);
return;

function [factorial]	= fac(n)
maxno		= max(max(n));
zerosi		= find(n<=0);
n(zerosi)	= ones(size(zerosi));
factorial	= n;
findex		= n;
for i=maxno:-1:2
	cand		= find(findex>2);
	candidates	= findex(cand);
	findex(cand)	= candidates-1;
	factorial(cand)	= factorial(cand).*findex(cand);
end
return;

function [verdict]	= iseven(candy)
verdict		= zeros(size(candy));
isint		= find(isint(candy)==1);
divided2	= candy(isint)/2;
evens		= (divided2==floor(divided2));
verdict(isint)	= evens;
return;

function [verdict]	= isint(candy)
verdict	= double(round(candy))==candy;
return;