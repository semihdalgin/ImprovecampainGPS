function v = getoptions(options, name, v, mendatory)


if nargin<4
    mendatory = 0;
end

if isfield(options, name)
    v = eval(['se�enekler' name ';']);
elseif mendatory
    error(['Se�enekler sa�lanmal�.' name '.']);
end 