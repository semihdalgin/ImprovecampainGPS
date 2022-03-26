function x = inversefouriertransform_fft(Cx,dF,N,N2)    
Cx(N2+1:N) = conj(Cx(N-N2+1:-1:2)); 
x = ifft(Cx)*N*dF;  x = real(x);    