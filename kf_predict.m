function [x,P] = kf_predict(x,P,A,Q,B,u)

   if nargin < 3
    A = [];
  end
  if nargin < 4
    Q = [];
  end
  if nargin < 5
    B = [];
  end
  if nargin < 6
    u = [];
  end
  
  if isempty(A)
    A = eye(size(x,1));
  end
  if isempty(Q)
    Q = zeros(size(x,1));
  end
  if isempty(B) & ~isempty(u)
    B = eye(size(x,1),size(u,1));
  end

  if isempty(u)
    x = A * x;
    P = A * P * A' + Q;
  else
    x = A * x + B * u;
    P = A * P * A' + Q;
  end
