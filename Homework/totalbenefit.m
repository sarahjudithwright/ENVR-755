function [tb] = totalbenefit(a, e, qchoke, q, pchoke)
%Calculates the total benefits
%   Integrates under benefit curve
tb = integral(@(qb) ((qb/a).^(1/e)), qchoke, q) + pchoke * qchoke; %finding area under benefit curve, taking the choke price into account
end

