xx=xlsread('outistaRawy');

 t=xx(:,1);
 y1=xx(:,4);
 
 nscales=150;


y1(isnan(y1))=0;
m1=mean(y1(:)); y1=y1-m1; 
nscales=round(abs(nscales));
c1=cwt(y1,1:nscales,'cmor1-1'); 


% Display results

figure(1); clf;
currfig=get(0,'CurrentFigure'); set(currfig,'numbertitle','off');
set(currfig,'name','Dalgacýk Analizi'); 
y1=y1+m1; y2=y2+m2;
subplot(2,1,1); plot(y1,'ob'); axis tight; title('ISTA Y'); 
grid on
subplot(2,1,2); imagesc(real(c1)); axis xy; axis tight; ylabel('Dalgacýk');







