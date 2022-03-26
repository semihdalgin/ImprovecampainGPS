clear
clc
x=xlsread('outistaRawx.xls');
fis=readfis('istabula6');
t(:,1)=x(:,1);
t(:,2)=x(:,4);
N = length(t(:,2));
NNN = [ones(length(t(:,1)),1),t(:,1)];
coef = inv(NNN'*NNN)*NNN'*t(:,2);
clear NNN
for i=1:N
h2(i,1)=t(i,2)-(coef(1,1)+(coef(2,1)*t(i,1)));
end
tut=1;
for f=1:N-1
        kas=t(f+1,1)-t(f,1);
        if kas<=0.00285
            t2(tut,1)=t(f,1);
            tut=tut+1;
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
st=t2(:,1);
output2=evalfis(st,fis);
sayi=length(st);
for i=1:sayi
    output2(i,1)=output2(i,1)+(coef(1,1)+(coef(2,1)*st(i,1)));
end
xlswrite('bulaista16',output2);