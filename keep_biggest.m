function [y,t] = keep_biggest(x,n)


if iscell(x)

    xx = [];
    for i=1:length(x)
        xx = [xx;x{i}(:)];
    end
    [yy,t] = keep_biggest(xx,n);

    for i=1:length(x)
        y{i} = yy( 1:prod( size(x{i}) ) );
        y{i} = reshape(y{i}, size(x{i}));
        yy( 1:prod( size(x{i}) ) ) = [];
    end
    return;
end

n = round(n);
y = x;
[tmp,I] = sort(abs(y(:)));
t = tmp(I(end-n));
y( I(1:end-n) ) = 0;