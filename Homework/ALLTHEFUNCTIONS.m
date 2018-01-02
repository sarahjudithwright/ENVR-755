%% ALL THE FUNCTIONS

%title: alphavalue
%this function point expands around a given point (equilibrium point) to find the alpha value
%to plug in later
function [a] = alphavalue(p, q, e)
%Calculates the alpha term in the benefit function
%   Using point expansion
a = q / (p.^e);
end

%title: totalbenefit
%this function calculates the total benefit of each sector by integrating
%under the demand curve
function [tb] = totalbenefit(a, e, qchoke, q, pchoke)
%Calculates the total benefits
%   Integrates under benefit curve
tb = integral(@(qb) ((qb/a).^(1/e)), qchoke, q) + pchoke * qchoke; %finding area under benefit curve, taking the choke price into account
end

%title: totalcost
%this function find the total cost by finding the area under the horizontal
%supply curve
function [ tc ] = totalcost(p, q)
%Calculates the total cost 
%   Finds the area under the cost function, in this case a constant
tc = p * q;
end

%title: netbenefit
%this function utilizes the wondeerful and mysterious powers of subtraction
function [nb] = netbenefit(tc, tb)
%Calculates net benefit
%   Subtract total cost from total benefits
nb = tb - tc;
end

%title: lsqant
%this function solves a system of equations, allowing us to find quantities
%at a certain marginal net benefit level over multiple years
function [ y ] = lsquant( q,e,a,p,r )
y(1)= ((q(1)/a(1))^(1/e(1))-p(1)) - ((q(2)/a(2))^(1/e(2))-p(2));
y(2)= ((q(2)/a(2))^(1/e(2))-p(2)) - ((q(3)/a(3))^(1/e(3))-p(3));
y(3)= ((q(3)/a(3))^(1/e(3))-p(3)) - ((q(4)/a(4))^(1/e(4))-p(4));
y(4)= q(1)+q(2)+q(3)+q(4) - r(1);
end

%title: netben
%this function calculates net benefit for the four sectors over the five
%years
function [ nb ] = netben(e, a, p, Qless, Qmore)
    nb(1) = integral(@(qvalue) (qvalue/a(1)).^(1/e(1)) - p(1), Qless(1), Qmore(1));
    nb(2) = integral(@(qvalue) (qvalue/a(2)).^(1/e(2)) - p(2), Qless(2), Qmore(2));
    nb(3) = integral(@(qvalue) (qvalue/a(3)).^(1/e(3)) - p(3), Qless(3), Qmore(3));
    nb(4) = integral(@(qvalue) (qvalue/a(4)).^(1/e(4)) - p(4), Qless(4), Qmore(4));
end
