clear
clc
tic
format long g
part=xlsread('istakoord');
part3=xlsread('lin');
N=length(part);
d=0;
x1t=0;
x2t=0;
x3t=0;
x4t=0;
x5t=0;
x6t=0;
while (d==0)
gelenver=menu('Hangi Koordinat Bile�eninde �al��mak �stiyorsunuz?','X','Y','Z');
if gelenver==1
    d=1;
    disp('X bile�eni ile �al���lacak')
elseif gelenver==2
    d=2;
    disp('Y bile�eni ile �al���lacak')
elseif gelenver==3
    d=3;
    disp('Z bile�eni ile �al���lacak')
else
    d=0;
    disp('Yanl�� Giri� Yapt�n�z X,Y ya da Z Koordinat bile�enlerinden birini deneyiniz')
end
end
zamanbas=input('Kampanya ba�lang�� epo�unu giriniz: \n');
zamanbit=input('Kampanta biti� epo�unu giriniz: \n');
koordx=input('Bile�en aranan noktan�n �l��len Ba�lang�� X koordinat�n� giriniz:  \n');
koordy=input('Bile�en aranan noktan�n �l��len Ba�lang�� Y koordinat�n� giriniz:  \n');
koordz=input('Bile�en aranan noktan�n �l��len Ba�lang�� Z koordinat�n� giriniz:  \n');
koordx2=input('Bile�en aranan noktan�n �l��len Biti� X koordinat�n� giriniz:  \n');
koordy2=input('Bile�en aranan noktan�n �l��len Biti� Y koordinat�n� giriniz:  \n');
koordz2=input('Bile�en aranan noktan�n �l��len Biti� Z koordinat�n� giriniz:  \n');
while (d==1)
s=0;
a=0;
aa=0;
b=0;
bb=0;
c=0;
sum=0;
art=0;
for i=1:N
    for j=1:N
        a=part(i,1)-part(j,1);
        aa=a^2;
        b=part(i,2)-part(j,2);
        bb=b^2;
        kk=part(i,3)-part(j,3);
        kkk=kk^2;
        c=aa+bb+kkk;
        s=sqrt(c+0.000000001);
        A(i,j)=s;
        s=0;
        a=0;
        aa=0;
        b=0;
        bb=0;
        c=0;
    end
end
ZOS=A;
says=1;
% baslang�c ve bitis s�resine g�re etkiler hesaplanacak
load bor1netx.mat
load brusnetx.mat
load gopenetx.mat
load graznetx.mat
load jozenetx.mat
load kit3netx.mat
load kosgnetx.mat
load matenetx.mat
load onsanetx.mat
load pencnetx.mat
load pol2netx.mat
load potsnetx.mat
load tro1netx.mat
load villnetx.mat
load wtzrnetx.mat
load zimmnetx.mat

ZH=zeros(16,1);
ZH(1,1)=sim(bor1netx,zamanbas);
ZH(2,1)=sim(brusnetx,zamanbas);
ZH(3,1)=sim(gopenetx,zamanbas);
ZH(4,1)=sim(graznetx,zamanbas);
ZH(5,1)=sim(jozenetx,zamanbas);
ZH(6,1)=sim(kit3netx,zamanbas);
ZH(7,1)=sim(kosgnetx,zamanbas);
ZH(8,1)=sim(matenetx,zamanbas);
ZH(9,1)=sim(onsanetx,zamanbas);
ZH(10,1)=sim(pencnetx,zamanbas);
ZH(11,1)=sim(pol2netx,zamanbas);
ZH(12,1)=sim(potsnetx,zamanbas);
ZH(13,1)=sim(tro1netx,zamanbas);
ZH(14,1)=sim(villnetx,zamanbas);
ZH(15,1)=sim(wtzrnetx,zamanbas);
ZH(16,1)=sim(zimmnetx,zamanbas);

Zys=zeros(16,1);
Zys(1,1)=sim(bor1netx,zamanbit);
Zys(2,1)=sim(brusnetx,zamanbit);
Zys(3,1)=sim(gopenetx,zamanbit);
Zys(4,1)=sim(graznetx,zamanbit);
Zys(5,1)=sim(jozenetx,zamanbit);
Zys(6,1)=sim(kit3netx,zamanbit);
Zys(7,1)=sim(kosgnetx,zamanbit);
Zys(8,1)=sim(matenetx,zamanbit);
Zys(9,1)=sim(onsanetx,zamanbit);
Zys(10,1)=sim(pencnetx,zamanbit);
Zys(11,1)=sim(pol2netx,zamanbit);
Zys(12,1)=sim(potsnetx,zamanbit);
Zys(13,1)=sim(tro1netx,zamanbit);
Zys(14,1)=sim(villnetx,zamanbit);
Zys(15,1)=sim(wtzrnetx,zamanbit);
Zys(16,1)=sim(zimmnetx,zamanbit);

Zlin(:,1)=part3(:,1);
[m,n]=size(A);
LL=eye(m);
IF=eye(m);
k=1;
while k<n,
   if A(k,k)==0,	
      disp('****')
      k=n;				
   else
      for i=k+1:m
         LL(i,k)=A(i,k)/A(k,k);			
         A(i,:)=A(i,:)-LL(i,k)*A(k,:);
         IF(i,:)=IF(i,:)-LL(i,k)*IF(k,:);
      end
      k=k+1;
   end
end
UU=A(:,1:n);				
ZS=eye(m);
k=1;
while k<n,
   if UU(k,k)==0,			
      disp('***')
      k=n;				
   else
      for i=k+1:m
         ZS(k,i)=UU(k,i)/UU(i,i);		
         UU(k,:)=UU(k,:)-ZS(k,i)*UU(i,:);	
         IF(k,:)=IF(k,:)-ZS(k,i)*IF(i,:);
      end
      k=k+1;
   end
end
dk=(diag(UU))';
for j=1:n
   if dk(j)==1;
      j=j+1;
   else
      IF(j,:)=IF(j,:)/dk(j);
      j=j+1;
   end
end
BEH=ZOS*IF;
clear BEH
clear A
clear LL
clear UU
clear ZOS
p=IF*ZH;
q=IF*Zys;
tt=IF*Zlin;
for i=1:N
        a=koordx-part(i,1);
        aa=a^2;
        b=koordy-part(i,2);
        bb=b^2;
        kk=koordz-part(i,3);
        kkk=kk^2;
        c=aa+bb+kkk;
        s=sqrt(c);
        D1(i,1)=s;
        s=0;
        a=0;
        aa=0;
        b=0;
        bb=0;
        c=0;
end
for i=1:N
        a=koordx2-part(i,1);
        aa=a^2;
        b=koordy2-part(i,2);
        bb=b^2;
        kk=koordz2-part(i,3);
        kkk=kk^2;
        c=aa+bb+kkk;
        s=sqrt(c);
        D2(i,1)=s;
        s=0;
        a=0;
        aa=0;
        b=0;
        bb=0;
        c=0;
end
for j=1:N
        x1=D1(j,1)*p(j,1);
        x1t=x1t+x1;
        x2=D1(j,1)*q(j,1);
        x2t=x2t+x2;
        x5=D1(j,1)*tt(j,1);
        x5t=x5t+x5;
        x6=D2(j,1)*tt(j,1);
        x6t=x6t+x6;
        
end
        sss=x1t;
        sss2=x2t;
        farkzaman=zamanbit-zamanbas;
        koordfark=koordx2-koordx;
        kamphiz=(koordfark/farkzaman);
        koordfark2=(koordx2-sss2)-(koordx-sss);
        yenkam=(koordfark2/farkzaman);
        set(1,1)=kamphiz;
        set(1,2)=yenkam;
        set(1,3)=x5t;
        xlswrite('sonhiz',set)
disp('********************** Hesaplama Sonu **************************')
        fprintf(1,'**Kampanya �l�melerinden Elde Edilen Do�rusal H�z:%d  m/y�l \n',kamphiz*1000)
        fprintf(1,'**Senelik ve 6 Ayl�k Etkilerin Kullan�lmas� �le Elde Edilen Do�rusal H�z:%d  m/y�l \n',yenkam*1000)
        fprintf(1,'**Enterpolasyon ile Elde Edilen Do�rusal H�z:%d  m/y�l \n',x5t*1000)
        toc
break
end
