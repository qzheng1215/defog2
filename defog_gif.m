
clc
clear all
close all
%Im=imread('C:\Users\18759\Desktop\Fog_remove\qaufog.png');
%QQͼƬ20211110113524.jpg
%�ڴ���¥ QQͼƬ20211111111726.png
%��������1.jpg ����2.jpg
%ͼ��� ����¥��QQͼƬ20211111111718.png
%ʵ��������֦��QQͼƬ20211111111731.png QQͼƬ20211109194447.png
%4b799f28c72edf5c039c6b515efedcd.png  untitled.jpg
Im=imread('G:\desktop\Fog_remove\QQͼƬ20211111111718.png');

I=double(Im)/255; 
%[m,n]=size(I,1,2);
sz=size(I);%seΪ��ͨ��ͼƬ

n=sz(2);%ȡͼƬ�ĵڶ���ά�ȣ�Ҳ���ǿ��

m=sz(1);%ȡͼƬ�ĵ�һ��ά�ȣ�Ҳ���ǳ���
%subplot(1,2,1);
figure,imshow(I,[]);title('ԭʼͼ��')
w0=0.65;
kenlRatio = .01;
krnlsz = floor(max([3, n*kenlRatio, m*kenlRatio]))%����Ӧ����˴�С��
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
figure,imshow(uint8(dark_channel*255)), title('��ͨ��');
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

figure,imshow(uint8(t1*255)), title('����͸����');
%subplot(1,2,2);
figure,imshow(I_out,[]);title('��ͨ��ȥ��')


r = krnlsz*4;
r = 6
eps = 10^-6;
%eps =0.1^2;
t_d = t1;
 filtered = guidedfilter_color(I, t_d, r, eps);%�Բ�ɫͼ��Ϊ����ͼ
%filtered = guidedfilter(double(rgb2gray(img))/255, t_d, r, eps);%һ�Ҷ�ͼ��Ϊ����ͼ

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

figure,imshow(uint8(t_1*255)), title('����ͼ����͸����');
figure,imshow(I_GIF_out,[]);title('����ͼȥ��')
