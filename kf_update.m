

function [X,P,K,IM,IS,LH] = kf_update(X,P,y,H,R)


  if nargin < 5
    error('Çok az veri');
  end
  
  IM = H*X;
  IS = (R + H*P*H');
  K = P*H'/IS;
  X = X + K * (y-IM);
  P = P - K*IS*K';
  if nargout > 5
    LH = gauss_pdf(y,IM,IS);
  end

