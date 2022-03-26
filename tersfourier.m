[xi,ti] = inversefouriertransform(rc,ic,1/(N*dT),'exp');
figure('numbertitle','off','name','Ters Fourier Transformasyonu ile Yeni Deðerlerin Tespit Edilmesi');
subplot(211), plot(t,x,'.',t,xi,'o'),
xlim([1999.5,2009.5])
xlabel('time, sec'), ylabel('ISTA X, m')  
legend('Gerçek Ölçü','Tahmini Ölçü')
grid on
title('Ters Fourier Transformasyonu')
subplot(212), plot(Ff,rc,'ob',Ff,ic,'ro')  
xlabel('Frekans'), ylabel('Genlik')  
legend('Gerçek','Tahmini',4)
grid on
xlswrite('alçakfiltre',xi)

