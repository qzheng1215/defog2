
clc
clear all
close all
%Im=imread('C:\Users\18759\Desktop\Fog_remove\qaufog.png');
%QQ图片20211110113524.jpg
%黑大主楼 QQ图片20211111111726.png
%松鼠：松鼠1.jpg 松鼠2.jpg
%图书馆 汇文楼：QQ图片20211111111718.png
%实验室外树枝：QQ图片20211111111731.png QQ图片20211109194447.png
%4b799f28c72edf5c039c6b515efedcd.png  untitled.jpg
Im=imread('G:\desktop\Fog_remove\QQ图片20211111111718.png');

I=double(Im)/255; 
%[m,n]=size(I,1,2);
sz=size(I);%se为三通道图片

n=sz(2);%取图片的第二个维度，也就是宽度

m=sz(1);%取图片的第一个维度，也就是长度
%subplot(1,2,1);
figure,imshow(I,[]);title('原始图像')
w0=0.65;
kenlRatio = .01;
krnlsz = floor(max([3, n*kenlRatio, m*kenlRatio]))%自适应卷积核大小？
%wh=krnlsz;
wh=15
%% dark_channel
I1=zeros(m,n);
for i=1:m
    for j=1:n
        
        I1(i,j)=min(I(i,j,:));
        
    end
end

Id = ordfilt2(I1,1,ones(wh,wh),'symmetric');

%%  A
dark_channel = Id;
figure,imshow(uint8(dark_channel*255)), title('暗通道');
A_temp = max(max(dark_channel))*0.999;
A=A_temp;
tr= 1 - w0 * Id/ A;
%% out 
t0=0.1;
t1 = max(t0,tr);
I_out=zeros(m,n,3);
for k=1:3
    for i=1:m
        for j=1:n
            I_out(i,j,k)=(I(i,j,k)-A)/t1(i,j)+A;
   
        end
    end
end

figure,imshow(uint8(t1*255)), title('大气透射率');
%subplot(1,2,2);
figure,imshow(I_out,[]);title('暗通道去雾')


r = krnlsz*4;
r = 6
eps = 10^-6;
%eps =0.1^2;
t_d = t1;
 filtered = guidedfilter_color(I, t_d, r, eps);%以彩色图作为引导图
%filtered = guidedfilter(double(rgb2gray(img))/255, t_d, r, eps);%一灰度图作为引导图

t_d = filtered;

t_1 = max(t0,t_d);
I_GIF_out=zeros(m,n,3);
for k=1:3
    for i=1:m
        for j=1:n
            I_GIF_out(i,j,k)=(I(i,j,k)-A)/t_1(i,j)+A;
   
        end
    end
end

figure,imshow(uint8(t_1*255)), title('引导图大气透射率');
figure,imshow(I_GIF_out,[]);title('引导图去雾')
