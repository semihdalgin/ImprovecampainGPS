format long g
close all
clear
clc
x_gr=xlsread('outistaRawz2');
t(:,1)=x_gr(:,1);
y(:,1)=x_gr(:,4);
stds(:,1)=x_gr(:,5);
N = length(y(:,1));
NNN = [ones(length(t(:,1)),1),t(:,1)];
coef = inv(NNN'*NNN)*NNN'*y(:,1);
clear NNN
for i=1:N
l(i,1)=y(i,1)-(coef(1,1)+(coef(2,1)*t(i,1)));
end

for i=1:N
    lin(i,1)=(coef(1,1)+(coef(2,1)*t(i,1)));
end

tt=2*pi;
yy=4*pi;
A=zeros(N,4);

for i=1:N
    sintb=sin(tt*t(i,1));
    costb=cos(tt*t(i,1));
    sinyb=sin(yy*t(i,1));
    cosyb=cos(yy*t(i,1));
    A(i,1)=costb;
    A(i,2)=sintb;
    A(i,3)=cosyb;
    A(i,4)=sinyb;
end

P=zeros(N,N);
for i=1:N
    P(i,i)=1/(stds(i,1)^2);
end

ATP=A';
Ni=ATP*P*A;
ni=ATP*P*l;
Nit=inv(Ni);
kats=Nit*ni;
clc
fprintf(' a= %d \n b=%d \n c=%d \n d=%d \n',kats(1,1),kats(2,1),kats(3,1),kats(4,1))

for i=1:N
Xs(i,1)=(coef(1,1)+(coef(2,1)*t(i,1)))+(kats(1,1)*cos(tt*t(i,1)))+(kats(2,1)*sin(tt*t(i,1)))+(kats(3,1)*cos(yy*t(i,1)))+(kats(4,1)*sin(yy*t(i,1)));
end

xlswrite('senelikkatistaz',kats);
xlswrite('Senelikistaz',Xs);

figure (1)
for i=1:N
    Yss(i,1)=(y(i,1));
    Yss2(i,1)=(lin(i,1));
    Yss3(i,1)=(Xs(i,1));
end
    
plot(t,Yss,'r.',t,Yss2,'-k',t,Yss3,'--b','Linewidth',2)
grid on
hold on
xlabel ('Yýl')
ylabel('')
legend('Ölçü','Lineer Hýz Bileþeni','Dönemsel Hýz Bileþeni')