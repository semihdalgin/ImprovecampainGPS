clear
clc
clf
close all
zz=xlsread('outistaRawx.xls');
x(:,1)=zz(:,1);
y(:,1)=zz(:,4);
plot(x,y,'o')

M = [ones(length(x),1),x];

coef = inv(M'*M)*M'*y;
zzz=coef(2,1);

fprintf(1,'Hýz = %d \n',zzz)

yhat = M*coef;




M = [ones(length(x),1),x];
coef0 = M\y;



for i=1:3
  res = M*coef0 - y;
  weights = exp(-3*abs(res)/max(abs(res)))';
  coef1 = lscov(M,y,weights);
  coef0=coef1;
end
dig=M*coef1;
plot(x,y,'o',x,yhat,'-r','LineWidth',2)
hold on
grid on
title 'Lineer regresyon modeli'
xlabel('Zaman')
plot(x,dig,'--k','LineWidth',2)
legend('Ölçü','Lineer Regresyon','Robust Tahmin Yöntemi')
zts=coef1(2,1);
fprintf(1,'Hýz2 = %d \n',zts)
zot(:,1)=coef;
zot(:,2)=coef1;
xlswrite('istalineerhizx',zot)