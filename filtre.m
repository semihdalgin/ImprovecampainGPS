[b,a]=butter(7,.1,'low');

filt=filter(b,a,ic);
ic(:,1)=ic(:,1).*filt(:,1);

