% Previously in class we worked with a static scenario for efficient allocation, only one timestep.  In
% reality, you may want to calculate total present value net benefits for
% each timestep of a dynamic process, where variables like demand and costs
% are changing with time.

% Imagine we have a city, where MBs are 
% modeled using Cobb-Douglas (Q = aP^e). The city is expecting to grow at
% a certain rate, so the C-D equation will change each year.  Determine the
% MNBs and PVMNBs for the city in each year over a period of 5 years.

% To do this for each year, you will need to:
%   1. find a quantity demanded and associated cost (price) for delivery
%       (this will change based on population)
%   2. use point expansion to determine the coefficient a of MBs
%   3. subtract MCs in each year from MBs
%   4. find each year's present value based on the discount rate

% Use the following information to determine the Cobb-Douglas Eqn for each
% year:
%   Per capita municipal water demand is a constant 0.005 acre-ft/year 
%       per person 
%   City population is growing at a rate of 1% per year, and population in
%       year 1 is 1,000,000.
water = 0.005;
people = 1000000;
year = [1,2,3,4,5];
money = 0.10;
elasticity = -0.3;
discount = 0.03;
q = zeros(5,1); %for point expansion
p = zeros(5,1); %for point expansion
a = zeros(5,1); %from point expansion
Q = 600; %q allocated by city
MB = zeros(5,1);
MC = 100000;
MNB = zeros(5,1);
PVMNB = zeros(5,1);

for year = 1:5
    people = people*(1+0.01*(year-1));
        q(year) = water*people;
        p(year) = money*q(year);
        a(year) = (q(year))/(p(year)^elasticity);
        MB(year) = (Q/a(year))^(1/elasticity);
        MNB(year) = MB(year) - MC;
        PVMNB(year) = MNB(year)/(1+discount)^(year-1);
end
 


%   The price to provide water is $0.10/acft per yr
%   Assume price elasticity of demand is -0.3 and discount rate is 3%

% Also, assume the MC to the city to treat and provide water is $100,000 per year and the city has 
% rights to 600 acreft per year (my number's aren't realistic, but the
% methodology is the important thing here). 
