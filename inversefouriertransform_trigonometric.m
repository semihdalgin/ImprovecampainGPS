
function x = inversefouriertransform_trigonometric(Cx,dF,N,N2)  
n  = 0:N-1;       m  =  0:N2-1;  
tn = n;            
fm = m/N;         
wm = 2*pi*fm;    
am =  2*real(Cx)*dF;
bm = -2*imag(Cx)*dF;
am(1) = am(1)/2;
if ~rem(N,2)
 am(end) = am(end)/2;
end
x = zeros(1,N);
for n = 1:length(tn)
 x(n) = sum( am(:).*cos(wm(:)*tn(n)) + bm(:).*sin(wm(:)*tn(n)) );
end
[mc,nc] = size(Cx); x = shiftdim(x,mc>nc);