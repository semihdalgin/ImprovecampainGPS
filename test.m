filename = 'dene.dat3'; 

fid1= fopen([filename],'r+');       % Zaman serisi mb dosyasi datas� 


sil = fgetl(fid1);  % headerlar�n yok edilmesi
sil = fgetl(fid1);  % headerlar�n yok edilmesi
sil = fgetl(fid1);  % headerlar�n yok edilmesi


[D,count]=fscanf(fid1,'%f %f %f',[3,Inf]);  % datan�n okunmas�
D=D';
[n,m]=size(D);

D(:,2)=D(:,2)*1000; % metre olarak gelen koordinat bile�enleri milimetreye �evriliyor 
D(:,2)=D(:,2)-mean(D(:,2));  %% Bile�enlerden ortalama de�er ��kar�l�yor
D(:,3)=D(:,3)*1000; % metre olarak gelen koordinat bile�enlerinin hatalar� milimetreye �evriliyor 

t = D(:,1); % Decimal yr
L = D(:,2); 
L_sig = D(:,3);



polynomed=polyfit(t,L,1);
L_detrended=L - (polynomed(1,1)*t + polynomed(1,2));

%%%%%% SPEKTRAL ANAL�Z k�sm�   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% LOMB-SCARGLE Metodu     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    [freqs,sigfreqs,sigpowers,Amps,SigAmps]=lombscargle2([t L_detrended],0,1,1);
    
    fprintf(1,'***************************************************** \n');
    for i=1:length(SigAmps)
        fprintf(1,'Sig.Per=%7.4f yil (%6.1f gun)    Sig.Ampl=%7.4f \n',1/sigfreqs(1,i),1/sigfreqs(1,i)*365.25,SigAmps(1,i));
    end
    fprintf(1,'***************************************************** \n');

    figure;
    plot(1./freqs(:,1),Amps,'b-','LineWidth',2), grid on
    xlabel('Periyot (Yil)','FontSize',12,'FontWeight','bold');ylabel('Genlik (mm)','FontSize',12,'FontWeight','bold')    
    hold off;
    
    cd OUT;    
    spec=fopen(['spectrum_',filename],'wa+');
    power_spec=fopen(['power_spectrum_',filename],'wa+');
    sig =fopen(['sigfreqs_',filename],'wa+');
    for i=1:length(freqs)
        fprintf(spec,'  %17.6f    %10.6f \n',freqs(i,1),freqs(i,2));
        fprintf(power_spec,'  %17.6f    %10.6f \n',freqs(i,1),Amps(i)^2);
    end
    for i=1:length(sigfreqs)
        fprintf(sig,'Sig.Per=%7.4f yr (%6.1f gun)    Sig.Pow=%7.4f \n',1/sigfreqs(1,i),1/sigfreqs(1,i)*365.25,sigpowers(1,i));
    end
    fclose('all');
    cd ..;
    


%%%%%% SPEKTRAL ANAL�Z k�sm� Sonu  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



