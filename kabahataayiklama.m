clear
close all
clf
clc
format long g
Z=xlsread('istaRawx');
X(:,1)=Z(:,4);
alpha=0.05;
mX = mean(X); 
[n,p] = size(X);
difT = [];

for j = 1:p;
   eval(['difT=[difT,(X(:,j)-mean(X(:,j)))];']);
end

S = cov(X);
D2T = difT*inv(S)*difT'; 
[D2,cc] = sort(diag(D2T));  

D2C = ACR(p,n,alpha);

idx = find(D2 >= D2C);
o = cc(idx);
io = D2(idx);

if isempty(o);
    disp(' ')
    fprintf('Verilen Güven Derecesi: %.2f\n', alpha);
    disp('Kaba Hatalý Ölçüye Rastlanmadý .');
else
    disp(' ')
    disp('Kaba Hatalý Ölçü ve ya Ölçüler Tablosu.')
    fprintf('----------------------------------------------\n');  
    disp('                            D2');
    disp('Nokta Numarasý              Uzaklýk');
    fprintf('----------------------------------------------\n');  
    fprintf(' %6.0f               %10.4f\n',[o,io].');
    fprintf('----------------------------------------------\n');  
    fprintf('Verilen Güven Derecesi: %.2f\n', alpha);
    fprintf('Uzaklýk Limiti: %.4f\n', D2C);
    disp('D2 = Mahalanobis Uzaklýðýnýn Karesi.');
end
ces=size(X);
for i=1:ces
    X(i,2)=i;
end
X(:,3)=Z(:,1);
X(:,4)=Z(:,2);
X(:,5)=Z(:,3);
X(:,6)=Z(:,5);
tas=size(o);
zot=1;
for i=1:ces
    gec=X(i,2);
    kont=1;
    for j=1:tas
    if gec==o(j,1)
        kont=0;
       break
    else
       continue
    end
    end
    if kont==1
    Y(zot,1)=X(i,3);
    Y(zot,2)=X(i,4);
    Y(zot,3)=X(i,5);
    Y(zot,4)=X(i,1);
    Y(zot,5)=X(i,6);
    zot=zot+1;
    else
        continue
    end
end
plot(X(:,1),'r')
hold on
grid on
plot(Y(:,4),'b')
xlswrite('outistaRawx2',Y)
return,
function x = ACR(p,n,alpha);

if nargin < 3,
   alpha = 0.05;
end; 

if (alpha <= 0 | alpha >= 1)
   fprintf('Uyarý: Güven derecesi 0 ile 1 arasýnda olmalýdýr. \n');
   return;
end;

if nargin < 2, 
   error('En az iki girdi verisi gerekli');
   return;
end;

a = alpha;
Fc = finv(1-a/n,p,n-p-1); 
ACR = (p*(n-1)^2*Fc)/(n*(n-p-1)+(n*p*Fc)); % = ((-1*((1/(1+(Fc*p/(n-p-1))))-1))*((n-1)^2))/n;
x = ACR;

return,