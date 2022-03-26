clear
clc
tic
format long g
part=xlsread('istakoord');
part3=xlsread('lin');
part2=xlsread('ketkibil');
N=length(part);
NN=length(part2);
d=0;
x1t=0;
x2t=0;
x3t=0;
x4t=0;
x5t=0;
x6t=0;
while (d==0)
gelenver=menu('Hangi Koordinat Bileþeninde Çalýþmak Ýstiyorsunuz?','X','Y','Z');
if gelenver==1
    d=1;
    disp('X bileþeni ile çalýþýlacak')
elseif gelenver==2
    d=2;
    disp('Y bileþeni ile çalýþýlacak')
elseif gelenver==3
    d=3;
    disp('Z bileþeni ile çalýþýlacak')
else
    d=0;
    disp('Yanlýþ Giriþ Yaptýnýz X,Y ya da Z Koordinat bileþenlerinden birini deneyiniz')
end
end
zamanbas=input('Kampanya baþlangýç epoðunu giriniz: \n');
zamanbit=input('Kampanta bitiþ epoðunu giriniz: \n');
koordx=input('Bileþen aranan noktanýn Ölçülen Baþlangýç X koordinatýný giriniz:  \n');
koordy=input('Bileþen aranan noktanýn Ölçülen Baþlangýç Y koordinatýný giriniz:  \n');
koordz=input('Bileþen aranan noktanýn Ölçülen Baþlangýç Z koordinatýný giriniz:  \n');
koordx2=input('Bileþen aranan noktanýn Ölçülen Bitiþ X koordinatýný giriniz:  \n');
koordy2=input('Bileþen aranan noktanýn Ölçülen Bitiþ Y koordinatýný giriniz:  \n');
koordz2=input('Bileþen aranan noktanýn Ölçülen Bitiþ Z koordinatýný giriniz:  \n');
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
for i=1:2:N*2
    [uf,puf]=size(part2(i,:));
    for j=1:puf
    if zamanbas==part2(i,j)
        ZH(says,1)=part2(i+1,j);
        disp(says)
        disp('Zaman Baslangýcý Tamam')
        says=says+1;
        break
    else
    if zamanbas>part2(i,j) && zamanbas<part2(i,j+1)
          flag=zamanbas-part2(i,j);
          ZH(says,1)=part2(i+1,j)+(((part2(i+1,j+1)-part2(i+1,j))/(part2(i,j+1)-part2(i,j)))*flag);
          disp(says)
          disp('Zaman Baslangýcý Tamam')
          says=says+1;
        break
    else
        continue
    end
    end
    end
end
says=1;
for i=1:2:N*2
    [uf,puf]=size(part2(i,:));
    for j=1:puf
    if zamanbit==part2(i,j)
        Zys(says,1)=part2(i+1,j);
        disp(says)
        disp('Zaman Bitimi Tamam')
        says=says+1;
        break
    else
    if zamanbit>part2(i,j) && zamanbit<part2(i,j+1)
          flag=zamanbit-part2(i,j);
          Zys(says,1)=part2(i+1,j)+(((part2(i+1,j+1)-part2(i+1,j))/(part2(i,j+1)-part2(i,j)))*flag);
          disp(says)
          disp('Zaman Bitimi Tamam')
          says=says+1;
        break
    else
        continue
         end
    end
    end
end
Zlin(:,1)=part3(:,1);
[m,n]=size(A);
LL=eye(m);
IF=eye(m);
k=1;
while k<n,
   if A(k,k)==0,		
      disp('***')
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
        yenkam=(koordfark2/farkzaman)*(1);
        set(1,1)=kamphiz;
        set(1,2)=yenkam;
        set(1,3)=x5t;
        xlswrite('sonhiz',set)
disp('********************** Hesaplama Sonu **************************')
        fprintf(1,'**Kampanya Ölçmelerinden Elde Edilen Doðrusal Hýz:%d  m/yýl \n',kamphiz*1000)
        fprintf(1,'**Senelik ve 6 Aylýk Etkilerin Kullanýlmasý Ýle Elde Edilen Doðrusal Hýz:%d  m/yýl \n',yenkam*1000)
        fprintf(1,'**Enterpolasyon ile Elde Edilen Doðrusal Hýz:%d  m/yýl \n',x5t*1000)
        toc
break
end
while (d==2)
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
for i=2:3:NN
    art=art+1;
    bile(art,:)=part2(i,:);
end
sinbilbs=sin(2*pi*zamanbas);
cosbilbs=cos(2*pi*zamanbas);
sinbils=sin(2*pi*zamanbit);
cosbils=cos(2*pi*zamanbit);
sinbil6bs=sin(4*pi*zamanbas);
cosbil6bs=cos(4*pi*zamanbas);
sinbil6s=sin(4*pi*zamanbit);
cosbil6s=cos(4*pi*zamanbit);
for k=1:length(bile)
    ZH(k,1)=((bile(k,1)*sinbilbs)+(bile(k,2)*cosbilbs));
    ZH1(k,1)=((bile(k,1)*sinbils)+(bile(k,2)*cosbils));
    Zys(k,1)=((bile(k,3)*sinbil6bs)+(bile(k,4)*cosbil6bs));
    Zys2(k,1)=((bile(k,3)*sinbil6s)+(bile(k,4)*cosbil6s));
end
Zlin(:,2)=part3(:,1);
[m,n]=size(A);
LL=eye(m);
IF=eye(m);
k=1;
while k<n,
   if A(k,k)==0,			% Pivot
      disp('Ecuations swapping needed')
      k=n;					% To exit
   else
      for i=k+1:m
         LL(i,k)=A(i,k)/A(k,k);			% Multiplier
         A(i,:)=A(i,:)-LL(i,k)*A(k,:);	% Erase
         IF(i,:)=IF(i,:)-LL(i,k)*IF(k,:);
      end
      k=k+1;
   end
end
UU=A(:,1:n);					% Upper triangular matrix

ZS=eye(m);
k=1;
while k<n,
   if UU(k,k)==0,			% Pivot
      disp('Ecuations swapping needed')
      k=n;					% To exit
   else
      for i=k+1:m
         ZS(k,i)=UU(k,i)/UU(i,i);			% Multiplier
         UU(k,:)=UU(k,:)-ZS(k,i)*UU(i,:);	% Erase
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
p1=IF*ZH1;
q1=IF*Zys2;
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
        x3=D2(j,1)*p1(j,1);
        x3t=x3t+x3;
        x4=D2(j,1)*q1(j,1);
        x4t=x4t+x4;
        x6=D2(j,1)*tt(j,1);
        x6t=x6t+x6;
        
end
  sss=x1t+x2t;
        sss2=x3t+x4t;
        farkzaman=zamanbit-zamanbas;
        koordfark=koordx2-koordx;
        kamphiz=(koordfark/farkzaman);
        koordfark2=(koordx2-sss2)-(koordx-sss);
        yenkam=(koordfark2/farkzaman);
        sons=(x5t+x1t+x2t)*1000;
        sonss=(x6t+x3t+x4t)*1000;
        format short g
disp('********************** Hesaplama Sonu **************************')
        fprintf(1,'**Baþlangýç Epoðu için Senelik Etki:%d  \n',x1t)
        fprintf(1,'**Baþlangýç Epoðu için 6 Aylýk Etki:%d  \n',x2t)
        fprintf(1,'**Bitiþ Epoðu için Senelik Etki:%d  \n',x3t)
        fprintf(1,'**Baþlangýç Epoðu için 6 Aylýk Etki:%d  \n',x4t)
        fprintf(1,'**Kampanya Ölçmelerinden Elde Edilen Doðrusal Hýz:%d  m/yýl \n',kamphiz)
        fprintf(1,'**Senelik ve 6 Aylýk Etkilerin Kullanýlmasý Ýle Elde Edilen Doðrusal Hýz:%d  m/yýl \n',yenkam)
        fprintf(1,'**Enterpolasyon ile Elde Edilen Doðrusal Hýz:%d  m/yýl \n',x5t)
      
break
end
while (d==3)
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
for i=3:3:NN
    art=art+1;
    bile(art,:)=part2(i,:);
end
sinbilbs=sin(2*pi*zamanbas);
cosbilbs=cos(2*pi*zamanbas);
sinbils=sin(2*pi*zamanbit);
cosbils=cos(2*pi*zamanbit);
sinbil6bs=sin(4*pi*zamanbas);
cosbil6bs=cos(4*pi*zamanbas);
sinbil6s=sin(4*pi*zamanbit);
cosbil6s=cos(4*pi*zamanbit);
for k=1:length(bile)
    ZH(k,1)=((bile(k,1)*sinbilbs)+(bile(k,2)*cosbilbs));
    ZH1(k,1)=((bile(k,1)*sinbils)+(bile(k,2)*cosbils));
    Zys(k,1)=((bile(k,3)*sinbil6bs)+(bile(k,4)*cosbil6bs));
    Zys2(k,1)=((bile(k,3)*sinbil6s)+(bile(k,4)*cosbil6s));
end
Zlin(:,3)=part3(:,1);
[m,n]=size(A);
LL=eye(m);
IF=eye(m);
k=1;
while k<n,
   if A(k,k)==0,			% Pivot
      disp('Ecuations swapping needed')
      k=n;					% To exit
   else
      for i=k+1:m
         LL(i,k)=A(i,k)/A(k,k);			% Multiplier
         A(i,:)=A(i,:)-LL(i,k)*A(k,:);	% Erase
         IF(i,:)=IF(i,:)-LL(i,k)*IF(k,:);
      end
      k=k+1;
   end
end
UU=A(:,1:n);					% Upper triangular matrix

ZS=eye(m);
k=1;
while k<n,
   if UU(k,k)==0,			% Pivot
      disp('Ecuations swapping needed')
      k=n;					% To exit
   else
      for i=k+1:m
         ZS(k,i)=UU(k,i)/UU(i,i);			% Multiplier
         UU(k,:)=UU(k,:)-ZS(k,i)*UU(i,:);	% Erase
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
p1=IF*ZH1;
q1=IF*Zys2;
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
        x3=D2(j,1)*p1(j,1);
        x3t=x3t+x3;
        x4=D2(j,1)*q1(j,1);
        x4t=x4t+x4;
        x6=D2(j,1)*tt(j,1);
        x6t=x6t+x6;
        
end
  sss=x1t+x2t;
        sss2=x3t+x4t;
        farkzaman=zamanbit-zamanbas;
        koordfark=koordx2-koordx;
        kamphiz=(koordfark/farkzaman);
        koordfark2=(koordx2-sss2)-(koordx-sss);
        yenkam=(koordfark2/farkzaman);
        sons=(x5t+x1t+x2t)*1000;
        sonss=(x6t+x3t+x4t)*1000;
        format short g
disp('********************** Hesaplama Sonu **************************')
        fprintf(1,'**Baþlangýç Epoðu için Senelik Etki:%d  \n',x1t)
        fprintf(1,'**Baþlangýç Epoðu için 6 Aylýk Etki:%d  \n',x2t)
        fprintf(1,'**Bitiþ Epoðu için Senelik Etki:%d  \n',x3t)
        fprintf(1,'**Baþlangýç Epoðu için 6 Aylýk Etki:%d  \n',x4t)
        fprintf(1,'**Kampanya Ölçmelerinden Elde Edilen Doðrusal Hýz:%d  m/yýl \n',kamphiz)
        fprintf(1,'**Senelik ve 6 Aylýk Etkilerin Kullanýlmasý Ýle Elde Edilen Doðrusal Hýz:%d  m/yýl \n',yenkam)
        fprintf(1,'**Enterpolasyon ile Elde Edilen Doðrusal Hýz:%d  m/yýl \n',x5t)
      
break
end
