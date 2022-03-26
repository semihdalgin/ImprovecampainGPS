clear
clc
close all
xxx= xlsread('outistaRawx');
t(:,1)=xxx(:,1);
x(:,1)=xxx(:,4);
N = length(x(:,1));
NNN = [ones(length(t(:,1)),1),t(:,1)];
coef = inv(NNN'*NNN)*NNN'*x(:,1);
clear NNN
for i=1:N
x(i,1)=x(i,1)-(coef(1,1)+(coef(2,1)*t(i,1)));
end
dT=max(t)-min(t);
[rc,ic,Ff] = fouriertransform(x,dT);
figure('numbertitle','off','name','Fourier Transformasyonu ile frekanslarýn elde edilmesi');
subplot(211), plot(t,x,'bo'), xlabel('Yýl'), ylabel('ISTA X, m')
xlim([1999.5,2009.5])
title('Fourier Transformasyonu')
grid on
subplot(212), plot(Ff,rc,'ob',Ff,ic,'ro')  
xlabel('Frekans'), ylabel('Genlik')  
legend('Gerçek','Tahmini',4)
grid on