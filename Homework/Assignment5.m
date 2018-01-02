CapitalCost = 1200000;
OpCosts = 50000;
AnnualRevenue = 218933.3333;
discount = 0.05;


money = zeros(1,20);
for i = 1:20
    money(i) = (AnnualRevenue - OpCosts)/((1 + discount)^i);
end

total = sum(money) - CapitalCost; % $9.0528e5 - positive, so profitable!