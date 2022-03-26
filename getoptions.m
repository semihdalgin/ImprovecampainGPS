function v = getoptions(options, name, v, mendatory)


if nargin<4
    mendatory = 0;
end

if isfield(options, name)
    v = eval(['seçenekler' name ';']);
elseif mendatory
    error(['Seçenekler saðlanmalý.' name '.']);
end 