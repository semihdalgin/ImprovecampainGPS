clear
clc
x=xlsread('dalgacikhaar.xls');
t(:,1)=x(:,1);
t(:,2)=x(:,2);

fark(:,1)=t(:,2)-t(:,1);
stat(1,1)=std(fark)
stat(1,2)=mean(fark)
stat(1,3)=min(fark)
stat(1,4)=max(fark)
xlswrite('stdhaar',stat);