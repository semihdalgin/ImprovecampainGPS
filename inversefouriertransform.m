function [x,t] = inversefouriertransform(Cx,varargin)  

[Cx,dF,N,N2,Method] = check_arguments(Cx,varargin,nargin);  
  
switch lower(Method)
 case 'fft'
  x = inversefouriertransform_fft(Cx,dF,N,N2);
 case 'exp'
  x = inversefouriertransform_exponential(Cx,dF,N,N2);
 case 'trig'
  x = inversefouriertransform_trigonometric(Cx,dF,N,N2); 
 otherwise
  error('Yöntem Bilinmiyor. Bunlardan biri olmalý ''fft'', ''exp'' or ''trig''.')
end
   
t = (0:N-1)/(N*dF);     t = reshape(t,size(x));  


