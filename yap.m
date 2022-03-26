close all
clear
clc
sec=xlsread('outistaRawz.xls');
t(:,1)=sec(:,1);
h(:,1)=sec(:,4);
clear sec
NNN = [ones(length(t),1),t];
coef = inv(NNN'*NNN)*NNN'*h;
N = length(h);
clear NNN
for i=1:N
h2(i,1)=h(i,1)-(coef(1,1)+(coef(2,1)*t(i,1)));
end
figure (1)
plot(t,h2,'or')
tut=1;
for f=1:N-1
        kas=t(f+1,1)-t(f,1);
        if kas<=0.00285
           continue
        elseif kas>0.00285
            basl=t(f,1)+0.0027;
            for j=basl:0.00275:t(f,1)+kas-0.0027
                t2(tut,1)=j;
                tut=tut+1;
            end
            
        else
                break
        end
end
    t1=t';
    t4=t2';
    h3=h2';