
options.wavelet_type = 'Daubechies'; 
options.wavelet_vm = 4; 
Jmin = 4;

x=xlsread('outistaRawx.xls');
t(:,1)=x(:,1);
t(:,2)=x(:,4);
N = length(t(:,2));
NNN = [ones(length(t(:,1)),1),t(:,1)];
coef = inv(NNN'*NNN)*NNN'*t(:,2);
clear NNN
for i=1:N
f(i,1)=t(i,2)-(coef(1,1)+(coef(2,1)*t(i,1)));
end
n = 2048;


fw = perform_wavelet_transform(f,Jmin,+1,options);

fw1 = keep_biggest(fw,round(n/30));

f1 = perform_wavelet_transform(fw1,Jmin,-1,options);

subplot(2,1,1);
plot(f,'or'); axis tight; title('ISTA X Ölçü Deðerleri');
grid on

subplot(2,1,2);
plot(f1,'ob'); axis tight; title('ISTA X Dalgacýk (Daubechies) Yöntemi Kullanýlarak Elde Edilen');
grid on

fss(:,1)=f(:,1);
fss(:,2)=f1(:,1);

xlswrite('dalgacikdau2.xls',fss)

x=xlsread('dalgacikdau2.xls');
t(:,1)=x(:,1);
t(:,2)=x(:,2);

fark(:,1)=t(:,2)-t(:,1);
stat(1,1)=std(fark)
stat(1,2)=mean(fark)
stat(1,3)=min(fark)
stat(1,4)=max(fark)
xlswrite('stddau2',stat);


