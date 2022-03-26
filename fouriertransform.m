function [rc,ic,Ft] = fouriertransform(x,varargin)  

  
  
[dT,N,Method] = check_arguments(x,varargin,nargin);  
  

switch lower(Method)
 case 'fft'
  [rc,ic] = fouriertransform_fft(x,dT,N);
 case 'exp'
  [rc,ic] = fouriertransform_exponential(x,dT,N);
 case 'trig'
  [rc,ic] = fouriertransform_trigonometric(x,dT,N); 
 otherwise
  error('Yöntem bilinmiyor. Bu yöntemlerden biri olmalı ''fft'', ''exp'' or ''trig''.')
end
  

Ft = (0:1/N:1/2)/dT;     Ft = reshape(Ft,size(rc));  


if (ic(end)==0) && rem(N,2)  
 warning('Fourier:Nyquist', ...
  'Son veri sıfır.')  
else
 ic(end) = 0;
end  
  

function [rc,ic] = fouriertransform_fft(x,dT,N)  

Cx = fft(x)*dT;   Cx = Cx(1:floor(N/2)+1);   
rc = real(Cx);    ic = imag(Cx);              
  
function [rc,ic] = fouriertransform_exponential(xn,dT,N)  

n  = 0:N-1;       m  =  n(1:floor(N/2)+1);  
tn = n;         
fm = m/N;        
wm = 2*pi*fm;  
Cx = zeros(floor(size(xn)/2)+1);  
for m = 1:length(wm)  
 Cx(m) = sum( xn(:) .* exp(-i*wm(m)*tn(:)) ) * dT;  
end  
rc = real(Cx);    ic = imag(Cx);  
  
function [rc,ic] = fouriertransform_trigonometric(xn,dT,N)  
n  = 0:N-1;       m  =  n(1:floor(N/2)+1);  
tn = n;           
fm = m/N;       
wm = 2*pi*fm;   
am = zeros(floor(size(xn)/2)+1); bm = am;    
am(1) = mean(xn);  
bm(1) = 0;  
for m = 2:length(wm)  
 am(m) = 2 * mean( xn(:) .* cos(wm(m)*tn(:)) );  
 bm(m) = 2 * mean( xn(:) .* sin(wm(m)*tn(:)) );  
end  
if ~rem(N,2) 
 am(end) = am(end)/2;  
 bm(end) = 0;  
end  
Tt = N*dT;   
rc =  (am/2)*Tt;  
ic = -(bm/2)*Tt;  
rc(1) = rc(1)*2;  
if ic(end) == 0   
 rc(end) = rc(end)*2;     
end  
  
function [dT,N,Method] = check_arguments(x,Ventries,Nentries)   
N = length(x);  
if N~=numel(x)  
 error('Girdi vektör olmalı.')  
end  
 
dT = 1;     
Method = 'fft';  
if Nentries > 1
 if ~ischar(Ventries{1})
  dT = Ventries{1};
 else
  Method = Ventries{1};
 end
end
if Nentries > 2
 if ~ischar(Ventries{2})
  dT = Ventries{2};
 else
  Method = Ventries{2};
 end
end
