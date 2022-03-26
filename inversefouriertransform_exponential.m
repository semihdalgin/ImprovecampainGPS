function x = inversefouriertransform_exponential(Cm,dF,N,N2)    
n  = 0:N-1;       m  =  n;  
tn = n;           
fm = m/N;        
wm = 2*pi*fm;   
Cm(N2+1:N) = conj(Cm(N-N2+1:-1:2)); 
x = zeros(1,N);
for n = 1:length(tn)  
 x(n) = sum( Cm(:) .* exp(i*wm(:)*tn(n)) ) * dF ;  
end
x = real(x); [mc,nc] = size(Cm); x = shiftdim(x,mc>nc);
