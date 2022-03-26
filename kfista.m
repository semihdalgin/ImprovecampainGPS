close all
clear
clc
   xxxx=xlsread('outvillRawz2');
   T(:,1)=xxxx(:,1);
   ff(:,1)=xxxx(:,4);
   N = length(ff(:,1));
   NNN = [ones(length(T(:,1)),1),T(:,1)];
   coef = inv(NNN'*NNN)*NNN'*ff(:,1);
   clear NNN
   for i=1:N
   ff(i,1)=ff(i,1)-(coef(1,1)+(coef(2,1)*T(i,1)));
   end
  

  sd = 0.1;
  dt = 0.001;
  w = 1;


  M = [0;coef(2,1)];
  P = diag([0.1 2]);
  R = sd^2;
  H = [1 0];
  q = 0.1;
  F = [0 1;
       0 0];
  [A,Q] = lti_disc(F,[],diag([0 q]),dt);

  MM = zeros(size(M,1),size(ff));
  PP = zeros(size(M,1),size(M,1),size(ff));
  clf;
  clc;
  for k=1:size(ff)
    [M,P] = kf_predict(M,P,A,Q);
    [M,P] = kf_update(M,P,ff(k),H,R);

    MM(:,k) = M;
    PP(:,:,k) = P;

    if rem(k,10)==1
           plot(T,ff,'ro',...
           T(k),M(1),'k*',...
           T(1:k),MM(1,1:k),'k--','LineWidth',2);
      legend('Ölçü','Tahmin','Filtrelenmiþ Tahmin')
      title('VILL Noktasýnýn Kalman Filtresi ile Analizi');
      drawnow;
      
    end
  end
  clc
  
  pause;  
  %
  % Kalman Yumuþatma
  %
  SM = rts_smooth(MM,PP,A,Q);
  figure('numbertitle','off','name','Kalman Filtrelemesi ile Gerçek Ölçülerin Karþýlaþtýrýlmasý');
  plot(T,ff,'b*',...
       T,MM(1,:),'ko',...
       T,SM(1,:),'ro');
   grid on
  legend('Ölçü','Filtrelenmiþ Tahmin','Yumuþatýlmýþ Tahmin') 
  title('Filtrelenmiþ ve Yumuþatýlmýþ Sonuçlarýn Karþýlaþtýrýlmasý');
  
  clc;
  disp('RMS Hatasý:');
  %
  % Hatalar
  %
  aa=zeros(1,4);
  aa(1,1)=std(MM(1,:));
  aa(1,2)=mean(MM(1,:));
  aa(1,3)=min(MM(1,:));
  aa(1,4)=max(MM(1,:));
  xlswrite('kalmanz',aa)
  fprintf('KF = %.3f\nRTS = %.3f\n',...
          sqrt(mean((MM(1,:)-ff(1,:)).^2)),...
          sqrt(mean((SM(1,:)-ff(1,:)).^2)));
