%% Assignment 4

%% Code from assignment two

% all of this section is code pulled from assignment 2. Here specifically
% is the process for calculating alpha values for year zero, which are used
% throughout this assignment
mnb = 0; 

p = 978; %price at equilibrium point (dollars)
q = 190056; %quantity at equilibrium point (acre-feet)
e = -0.3; %elasticity
a = alphavalue(p,q,e); %output is alpha term, a
ai = a; %saving this value as alphaindoor for future reference
qi = (mnb + p)^e * (a);

p = 978; %price at equilibrium point (dollars)
q = 94886; %quantity at equilibrium point (acre-feet)
e = -0.75; %elasticity
a = alphavalue(p,q,e); %output is alpha term, a
ao = a;
qo = (mnb + p)^e * (ao);

p = 30; %price at equilibrium point (dollars)
q = 100000; %quantity at equilibrium point (acre-feet)
e = -0.5; %elasticity
a = alphavalue(p,q,e); %output is alpha term, a
av = a;
qv = (mnb + p)^e * (av);

%call alpha function
p = 30; %price at equilibrium point (dollars)
q = 147000; %quantity at equilibrium point (acre-feet)
e = -1.5; %elasticity
a = alphavalue(p,q,e); %output is alpha term, a
af = a;
qf = (mnb + p)^e * (af);

atotal = qi + qo + qv + qf;

%% Net Benefits over 5 years

%this is part f from assignment two, calculating net benefits of the region
%over four years with a growing population

y0=[1000 1000 1000 1000];
q0= [532000/4, 532000/4, 532000/4, 532000/4];
r=[532000 400000];
growth= .01; 
discount= .08; 
initialpop = 1817000; 
wpc = 140/325851; %water per capita
ei = -0.3;
eo = -0.75;
ev = -0.5;
ef = -1.5;
q = [qi qo qv qf];
e = [ei eo ev ef];
a = [ai ao av af];
p= [978, 978, 30, 30];

for year = 1:5
    Qmore(year,1:4) = lsqnonlin(@(Q) lsquant(Q,e,a,p,532000,year,0.01), p, [0 0 0 0], [Inf Inf Inf Inf]);
    Qless(year,1:4) = lsqnonlin(@(Q) lsquant(Q,e,a,p,400000,year,0.01), p, [0 0 0 0], [Inf Inf Inf Inf]);
end
%in these blocks of code, we show the financial losses associated with
%protecting the endangered species
for t = 1:5
	tnb= netben(e, a, p, Qless, Qmore, t, growth); 
    tpvnb = tnb/(1+discount)^t;
end
totalpvnetben = sum(tpvnb); %3.2932e6 - this is present value net benefits for four sectors for five years

%% Net Benefits with Restrictions over 5 years

%this section is parts h and i from assignment 2
%similar to the previous section, but now there are constraints on the amount
%of water we must allocate towards the agriculture sectors

for year = 1:5
    Qmore(year,1:4) = lsqnonlin(@(Q) lsquant(Q,e,a,p,400000,year,0.01), p, [0 0 0 0], [Inf Inf Inf Inf]);
    Qless(year,1:4) = lsqnonlin(@(Q) lsquant(Q,e,a,p,400000,year,0.01), p, [0 0 37594 55263], [Inf Inf Inf Inf]);
end
%this is like last time, finding the difference between two scenarios.
%Here, we are looking at the financial consequences of prioritizing/protecting the ag
%sectors 
for t = 1:5
    htnb = netben(e, a, p, Qless, Qmore, t, growth); 
    htpvnb = htnb/(1+discount)^year;
end
    htotalpvnetben = sum(htpvnb); %1.975e13 %this is where things start to go very wrong. It shouldn't be larger than 10^4 or 5 at most

    
%% A - build in year 0? (This is the beginning of assignment four)
%Given variables
damcapital = 150000000; %dollars in year built
firmyield = 300000; %a-f/year
damops = 0.01 * damcapital; %dollars per year
recben = 1200000; %$12 per visitor day times 100000 annual visior days

hydrocapital = 5000000; %dollars in year built
hydroops = 0.05 * hydrocapital; %dollars per year
waterheight = 75; %feet
hydrowater = 0.9 * firmyield; %acre-feet per year
hydroefficiency = 0.7; 
energyprice = 0.05; %dollars/kWh

discount = 0.08; 

r=[400000 700000]; %allocations - without and with the new resevoir added to the Edwards capacity

y0=[1000 1000 1000 1000]; %guesses
q0= [532000/4, 532000/4, 532000/4, 532000/4]; %guesses
q = [qi qo qf qv]; %setting up vectors for functions
e = [ei eo ef ev];
a = [ai ao af av];
p= [978, 978, 30, 30];

%here, we find the quantities for each sector each year with and without
%the added capacity from the Edwards
for year = 1:99
    Qmore(year,1:4) = lsqnonlin(@(Q) lsquant(Q,e,a,p,700000,year,0.01), p, [0 0 37594 55263], [Inf Inf Inf Inf]);
    Qless(year,1:4) = lsqnonlin(@(Q) lsquant(Q,e,a,p,400000,year,0.01), p, [0 0 37594 55263], [Inf Inf Inf Inf]);
end

%The quantities (Qmore and Qless) assume we want to use every drop of the
%possible water. This is not necessarily true - we want to meet demand and
%use no more becasue further use would result in lost benefits (want to use
%where MB = MC or MNB = 0). What we need to do is find the year in which
%demand surpasses 700000 and replace the Q values for the four sectors with
%the demanded quantities for all years prior

%this loop find the total demand for each year
for year = 1:99 %making this huge to give me options later
    Qind(year) = 978^ei * ai * 1.01^(year-1);
    Qout(year) = 978^eo * ao * 1.01^(year-1);
    Qveg(year) = 30^ev * av;
    Qfield(year) = 30^ef * af;
    Qall(year) = Qfield(year) + Qveg(year) + Qout(year) + Qind(year);
end

%this loop figures out which year the demand level surpasses 700000 a-f
year = 1;
Qannual = Qall(1);
while Qannual < 700000
    year = year + 1;
    Qannual = Qall(year);
end %tells us that demand goes over 700000 for the first time at year 48

%overrides sectors being forced to use all 700000 acre feet when demand is lower
Qmore(1:47,1) = Qind(1:47);
Qmore(1:47,2) = Qout(1:47);
Qmore(1:47,3) = Qveg(1:47);
Qmore(1:47,4) = Qfield(1:47);
%now, the Qmore matrix uses the quantites we need it to in the netben function    

%here we go... the final step! 
%in the loop below, we find the total net benefit for each year, accound
%for loss of recreation and operating costs, and present value all of it
for t = 1:98
    atnb(t+1,1:5) = netben(e, a, p, Qless(t+1,1:4), Qmore(t+1,1:4), t, growth);
    atnb(1,1:5) = 0;
    atpvnb(t+1) = (atnb(t+1,5) - recben - damops)/((1+discount)^t);
end
%here, I replace the first line (which was zeros because no benefits) with
%the capital costs to easily include them in the sum
atpvnb(1) = -150000000;
%and sum it all up for 50 years to find out whether we make or lose money!
atotalpvnetben = sum(atpvnb(1:50)); %4.6243e12 

%The number here is incredibly wrong. I don't know if I have ever produced
%anything so wrong in my entire life. Here's what should have happened.
%All the rows of atpvnb except the first should add to a number somewhere
%in the 10^7 to 10^9 rannge. Then, with the first row (-150000000, the
%capital cost of the dam) included, the atotalpvnetben variable,
%representing the present value total net benefits for the life of the dam
%built in year zero, should be no larger in magnitude than 10^3 or so. If
%this number is positive, the dam does make financial sense to be built in
%year zero. If this number is negative (which it probably should be as part
%b exists), we know that we are still in the red, leading to the conclusion
%that construction must be pushed off until demand increases to the level
%that we will acrue enough benefits over fifty years to cover the initia capital
%costs.
%% B - when build the dam?

%Because all the numbers are wrong, I'm going to write lots of code that
%should work and then explain what numbers should look like.

%The goal here is to find the first year that the total present value net
%benefits over 50 years exceeds the capital costs of building the dam

for i = 1:15 %Greg said if we get past year 15, we've gone too far; know not building dam in 0
    if sum(atpvnb(i:i+49)) >= 0;
        i %prints years that it is financially sound to build the dam, buid in the first one
    else
        ; %do nothign
    end  
end

%the first year we have a positive value, we will build the dam

%% C - changing the discount rate

%this process uses the exact same code as before, just changing the
%discount once to 0.06 and then again to 0.04 and repeating the same
%analysis

%this code is the same as above - comments with denote any changes
damcapital = 150000000; 
firmyield = 300000; 
damops = 0.01 * damcapital; 
recben = 1200000; 

hydrocapital = 5000000; 
hydroops = 0.05 * hydrocapital; 
waterheight = 75; 
hydrowater = 0.9 * firmyield; 
hydroefficiency = 0.7; 
energyprice = 0.05; 

discount = 0.06; %we change this

r=[400000 700000]; 

y0=[1000 1000 1000 1000];
q0= [532000/4, 532000/4, 532000/4, 532000/4]; 
q = [qi qo qf qv]; 
e = [ei eo ef ev];
a = [ai ao af av];
p= [978, 978, 30, 30];

for year = 1:99
    Qmore(year,1:4) = lsqnonlin(@(Q) lsquant(Q,e,a,p,700000,year,0.01), p, [0 0 37594 55263], [Inf Inf Inf Inf]);
    Qless(year,1:4) = lsqnonlin(@(Q) lsquant(Q,e,a,p,400000,year,0.01), p, [0 0 37594 55263], [Inf Inf Inf Inf]);
end

%all of the quantities would stay the same - discount rate does not affect
%the needs of the population

for year = 1:99 
    Qind(year) = 978^ei * ai * 1.01^(year-1);
    Qout(year) = 978^eo * ao * 1.01^(year-1);
    Qveg(year) = 30^ev * av;
    Qfield(year) = 30^ef * af;
    Qall(year) = Qfield(year) + Qveg(year) + Qout(year) + Qind(year);
end

year = 1;
Qannual = Qall(1);
while Qannual < 700000
    year = year + 1;
    Qannual = Qall(year);
end %this year would still be the same

Qmore(1:47,1) = Qind(1:47);
Qmore(1:47,2) = Qout(1:47);
Qmore(1:47,3) = Qveg(1:47);
Qmore(1:47,4) = Qfield(1:47);

for t = 1:98
    atnb(t+1,1:5) = netben(e, a, p, Qless(t+1,1:4), Qmore(t+1,1:4), t, growth);
    atnb(1,1:5) = 0;
    %this is where things change - when we present value benefits and costs
    %in the future
    atpvnb(t+1) = (atnb(t+1,5) - recben - damops)/((1+discount)^t);
end
atpvnb(1) = -150000000;
atotalpvnetben = sum(atpvnb(1:50)); 
%for 0.06: 2.3369e13
%for 0.04: 2.8079e13

%expected results: again, I know my numbers are wrong. They do, though,
%follow the expected pattern. With a lower discount rate, the pvnbenefits value would
%be larger (and overcome the capital costs sooner) because we would assume
%money in the future decreases less in relation to current value. In terms
%of building year, a lower discount rate would make the dam look like a
%sound investment sooner than with a higer discount rate.

%Like before, we would run this code:

for i = 1:15 %Greg said if we get past year 15, we've gone too far; know not building dam in 0
    if sum(atpvnb(i:i+49)) >= 0;
        i %prints years that it is financially sound to build the dam, buid in the first one
    else
         %do nothing
    end  
end

%to figure out which year to build. Same as before, we build in the first
%year this loop spits out. If 1 is a result (a positive value), we assume
%the dam was already built.

%% D - add hydro?
        
%in this problem, we need to see if hyro benefits will ever equal or
%surpass hydro costs

hydrocapital = 5000000; %dollars in year built
hydroops = 0.05 * hydrocapital; %dollars per year
waterheight = 75; %feet
hydrowater = 0.9 * firmyield; %acre-feet per year
hydroefficiency = 0.7; 
energyprice = 0.05; %dollars/kWh

%as the hydro demand never changes, don't need to factor in what year
%building it - just trying to see if it pays for itself over any 50 years

%costs
hydroopscosts = zeros([1 50]);
for i = 1:50
    %present value the annual operations costs
    hydroopscosts(i) = hydroops/(1+discount)^i;
end
%add sum of pv ops cost to capital 
hydrototalcosts = sum(hydroopscosts) + hydrocapital; %$8.9405e6

%benefits - woo physics 
%see photo of calculations submitted for how I got this number
hydroannualbenefits = 16590000 * energyprice; %kWh * $/kWh = $$$, this is not PV

hydrobenefits = zeros([1 50]);
for i = 1:50
    hydrobenefits(i) = hydroannualbenefits/(1+discount)^i;
end %pv the benefits

hydrototalbenefits = sum(hydrobenefits);

%do we build it? 
if hydrototalbenefits > hydrototalcosts
    'add hydro'
else
    'dont add hydro' 
end %got 'add hydro'
    
%% E - hydro affect year?

%in theory, the hydro addition would change the year. With greater capital
%costs, one might need to wait longer to build so the debt can be covered
%by a larger population's water demand

%similar code to part a and b, comments will show changes
for year = 1:99
    Qmore(year,1:4) = lsqnonlin(@(Q) lsquant(Q,e,a,p,700000,year,0.01), p, [0 0 37594 55263], [Inf Inf Inf Inf]);
    Qless(year,1:4) = lsqnonlin(@(Q) lsquant(Q,e,a,p,400000,year,0.01), p, [0 0 37594 55263], [Inf Inf Inf Inf]);
end

%the quantities will not change with the addition of hydro

for year = 1:99 
    Qind(year) = 978^ei * ai * 1.01^(year-1);
    Qout(year) = 978^eo * ao * 1.01^(year-1);
    Qveg(year) = 30^ev * av;
    Qfield(year) = 30^ef * af;
    Qall(year) = Qfield(year) + Qveg(year) + Qout(year) + Qind(year);
end

year = 1;
Qannual = Qall(1);
while Qannual < 700000
    year = year + 1;
    Qannual = Qall(year);
end 

Qmore(1:47,1) = Qind(1:47);
Qmore(1:47,2) = Qout(1:47);
Qmore(1:47,3) = Qveg(1:47);
Qmore(1:47,4) = Qfield(1:47);

%account for the additional costs and benefits of adding hydro
for t = 1:98
    hydrotnb(t+1,1:5) = netben(e, a, p, Qless(t+1,1:4), Qmore(t+1,1:4), t, growth);
    hydrotnb(1,1:5) = 0;
    hydrotpvnb(t+1) = (hydrotnb(t+1,5) + hydroannualbenefits - recben - damops - hydroops)/((1+discount)^t); %add hydro ops costs
end
hydrotpvnb(1) = -155000000; %extra $5mil capital for hydro 

for i = 1:20 %added a few years here because we don't know how much things will change
    if sum(hydrotpvnb(i:i+49)) >= 0;
        i    
    end  
end

%Same deal as before. If the present value net benefits (hydrotpvnb) are larger than the
%capital costs (hydrotpvnb(1)), it makes sense to build the dam in that
%year. The last loop will spit out feasible years, and it should be built
%in the first one.

%% F 
%see notebook paper photo emailed in

%% G - what if peaking price is double but some water unused

% No. I prefer the guaruntee of constant revenue. The whole point of this
% analysis is knowing what we're getting into when we build a dam, so why
% take any kind of risk?

%% H - what if no rec?

%same code as part a
%quantities are the same so I won't waste space
%only difference is in final loop

for t = 1:98
    rectnb(t+1,1:5) = netben(e, a, p, Qless(t+1,1:4), Qmore(t+1,1:4), t, growth);
    rectnb(1,1:5) = 0;
    rectpvnb(t+1) = (rectnb(t+1,5) + hydroannualbenefits - damops - hydroops)/((1+discount)^t); %deleted lost rec benefits
end
rectpvnb(1) = -155000000;  

for i = 1:15 
    if sum(rectpvnb(i:i+49)) >= 0;
        i 
    end  
end

%would build dam sooner without lost rec benefits - more benefits accrued
%each year to cover capital costs

%% I - capacity increase to 400k?

%assume keep hydro gains/losses and recreation losses?

for year = 1:99
    Qmore(year,1:4) = lsqnonlin(@(Q) lsquant(Q,e,a,p,800000,year,0.01), p, [0 0 37594 55263], [Inf Inf Inf Inf]);
    Qless(year,1:4) = lsqnonlin(@(Q) lsquant(Q,e,a,p,400000,year,0.01), p, [0 0 37594 55263], [Inf Inf Inf Inf]);
end

%the quantities will change with the added capacity - Qmore is up to 800000

for year = 1:99 
    Qind(year) = 978^ei * ai * 1.01^(year-1);
    Qout(year) = 978^eo * ao * 1.01^(year-1);
    Qveg(year) = 30^ev * av;
    Qfield(year) = 30^ef * af;
    Qall(year) = Qfield(year) + Qveg(year) + Qout(year) + Qind(year);
end

year = 1;
Qannual = Qall(1);
while Qannual < 800000 %change 700000 to 800000
    year = year + 1;
    Qannual = Qall(year);
end 

Qmore(1:47,1) = Qind(1:47);
Qmore(1:47,2) = Qout(1:47);
Qmore(1:47,3) = Qveg(1:47);
Qmore(1:47,4) = Qfield(1:47);

for t = 1:98
    fourtnb(t+1,1:5) = netben(e, a, p, Qless(t+1,1:4), Qmore(t+1,1:4), t, growth);
    fourtnb(1,1:5) = 0;
    fourtpvnb(t+1) = (fourtnb(t+1,5) + hydroannualbenefits - recben - damops - hydroops)/((1+discount)^t); %add hydro ops costs
end
fourtpvnb(1) = -205000000; % $200mil instead of $150mil dam capital, still have hydro capital

for i = 1:30 %added a few years here because we don't know how much things will change
    if sum(fourtpvnb(i:i+49)) >= 0;
        i    
    end  
end

%best guess: year will be farther in the future with higher capacity
%becasue the capital costs in year zero are much larger. It will take
%longer for there to be enough demand to make up the defecit with time
%value of money taken into account