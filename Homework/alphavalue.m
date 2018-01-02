function [a] = alphavalue(p, q, e)
%Calculates the alpha term in the benefit function
%   Using point expansion
a = q / (p.^e);
end

