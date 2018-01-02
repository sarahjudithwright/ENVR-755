%ENVR 755 Homework 2
%% A - Finding quantities

%this section uses the alpha funciton to point expand about the eq point,
%giving us alpha values we can then plug in to the cobb-douglas equation
%then set up a guess and check solver where I adjusted a guess mnb
%value and messed with it until the atotal value was as close to 532000 as
%possible
%here, there is enough water to go around, so the mnb is 0

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

%% A - Indoor Municipal

%this is the first of the four sectors, finding total cost, total benefit,
%and net benefit using functions

q = qi; %qi value from previous section
a = ai; %ai value from previous section
ei = -0.3; %elasticity
e = ei;
p = (q/a)^(1/e); %cobb douglas

tc = totalcost(p,q);
tci = tc; %1.8587e8


pchoke = 10000; %choke price (dollars/acre-foot)
pchokei = pchoke;
qchoke = a * pchoke.^e; %quantity at choke price (acre-feet)
qchokei = qchoke;
tb = totalbenefit(a, e, qchoke, q, pchoke);
tbi = tb; %1.2721e9

nb = netbenefit(tc, tb);
nbi = nb; %1.0862e9
%% A - Outdoor Municipal

q = qo; %outdoor quantity found in previous section (qo)
a = ao; %alpha output from the last section (ao)
eo = -0.75; %elasticity
e = eo;
p = (q/a)^(1/e); 

tc = totalcost(p,q);
tco = tc; %9.2799e7

%call totalbenefit function
pchoke = 10000; %choke price (dollars/acre-foot)
pchokeo = pchoke;
qchoke = a * pchoke.^e; %quantity at choke price (acre-feet)
qchokeo = qchoke;
tb = totalbenefit(a, e, qchoke, q, pchoke);
tbo = tb; %3.8537e8

nb = netbenefit(tc, tb);
nbo = nb; %2.9257e8

%% A - Vegetables

q = qv; %vegetable quantity found in first section (qv)
a = av; %alpha output from the first section (av)
ev = -0.5; %elasticity
e = ev;
p = (q/a)^(1/e); 

tc = totalcost(p,q);
tcv = tc; %3e6

%call totalbenefit function
pchoke = 150; %choke price (dollars/acre-foot)
pchokev = pchoke;
qchoke = a * pchoke.^e; %quantity at choke price (acre-feet)
qchokev = qchoke;
tb = totalbenefit(a, e, qchoke, q, pchoke);
tbv = tb; %1.0416e7

nb = netbenefit(tc, tb);
nbv = nb; %7.4164e6

%% A - Field Crops

q = qf; %field crop quantity found in first section (qf)
a = af; %alpha output from the first section (af)
ef = -1.5; %elasticity
e = ef;
p = (q/a)^(1/e); 

tc = totalcost(p,q);
tcf = tc; %4.4100e6

%call totalbenefit function
pchoke = 105; %choke price (dollars/acre-foot)
pchokef = pchoke;
qchoke = a * pchoke.^e; %quantity at choke price (acre-feet)
qchokef = qchoke;
tb = totalbenefit(a, e, qchoke, q, pchoke);
tbf = tb; %8.5155e6

nb = netbenefit(tc, tb);
nbf = nb; %4.1055e6

%% A - Regional totals

%here I actually answer the question! yay!
rtc = tci + tco + tcv + tcf; %regional total cost is the sum of the total cost for each sector
rtb = tbi + tbo + tbv + tbf; %regional total benefit is the sum of the total cost for each sector
rnb = nbi + nbo + nbv + nbf; %regional total cost is the sum of the total cost for each sector
rnbcheck = rtb - rtc;

%rtc = 2.8608e8
%rtb = 1.6764e9
%rnb = 1.3903e9

%% B - Finding the quantites for each section with restrictions

%repeat guess and check procedure from a with new total goal: 400000

mnb = 31.95; 

p = 978; %price at equilibrium point (dollars)
q = 190056; %quantity at equilibrium point (acre-feet)
e = -0.3; %elasticity
a = alphavalue(p,q,e); %output is alpha term, a
ai = a; %saving this value as alphaindoor for future reference
bqi = (mnb + p)^e * (a);

p = 978; %price at equilibrium point (dollars)
q = 94886; %quantity at equilibrium point (acre-feet)
e = -0.75; %elasticity
a = alphavalue(p,q,e); %output is alpha term, a
ao = a;
bqo = (mnb + p)^e * (ao);

p = 30; %price at equilibrium point (dollars)
q = 100000; %quantity at equilibrium point (acre-feet)
e = -0.5; %elasticity
a = alphavalue(p,q,e); %output is alpha term, a
av = a;
bqv = (mnb + p)^e * (av);

%call alpha function
p = 30; %price at equilibrium point (dollars)
q = 147000; %quantity at equilibrium point (acre-feet)
e = -1.5; %elasticity
a = alphavalue(p,q,e); %output is alpha term, a
af = a;
bqf = (mnb + p)^e * (af);

btotal = bqi + bqo + bqv + bqf;
%4e5 = 1.8823e5 + 9.2626e4 + 6.9589e4 + 4.9538e4

%% C - Marginal Net Benefits 

marginalnetbenefit = 31.95; %taken from last section - where value of last unit is same across all sectors
%the value of a water right is the infinite sum of a/(1+d)^t 
% this equates to a/d (ask me for proof if you must)
waterright = 31.95/0.08; %400 dollars

%% D - Indoor Municipal

q = bqi; %pi value from previous section
a = ai; %ai value from previous section
ei = -0.3; %elasticity
e = ei;
p = (q/a)^(1/e); 

tc = totalcost(p,q);
dtci = tc; 

pchoke = 10000; %choke price (dollars/acre-foot)
pchokei = pchoke;
qchoke = a * pchoke.^e; %quantity at choke price (acre-feet)
qchokei = qchoke;
tb = totalbenefit(a, e, qchoke, q, pchoke);
dtbi = tb;

nb = netbenefit(tc, tb);
dnbi = nb;

%% D - Outdoor Municipal

q = bqo; %outdoor quantity found in previous section (qo)
a = ao; %alpha output from the last section (ao)
eo = -0.75; %elasticity
e = eo;
p = (q/a)^(1/e); 

tc = totalcost(p,q);
dtco = tc;

%call totalbenefit function
pchoke = 10000; %choke price (dollars/acre-foot)
pchokeo = pchoke;
qchoke = a * pchoke.^e; %quantity at choke price (acre-feet)
qchokeo = qchoke;
tb = totalbenefit(a, e, qchoke, q, pchoke);
dtbo = tb;

nb = netbenefit(tc, tb);
dnbo = nb;

%% D - Vegetables

q = bqv; %vegetable quantity found in first section (qv)
a = av; %alpha output from the first section (av)
ev = -0.5; %elasticity
e = ev;
p = (q/a)^(1/e); 

tc = totalcost(p,q);
dtcv = tc;

%call totalbenefit function
pchoke = 150; %choke price (dollars/acre-foot)
pchokev = pchoke;
qchoke = a * pchoke.^e; %quantity at choke price (acre-feet)
qchokev = qchoke;
tb = totalbenefit(a, e, qchoke, q, pchoke);
dtbv = tb;

nb = netbenefit(tc, tb);
dnbv = nb;

%% D - Field Crops

q = bqf; %field crop quantity found in first section (qf)
a = af; %alpha output from the first section (af)
ef = -1.5; %elasticity
e = ef;
p = (q/a)^(1/e); 

tc = totalcost(p,q);
dtcf = tc;

%call totalbenefit function
pchoke = 105; %choke price (dollars/acre-foot)
pchokef = pchoke;
qchoke = a * pchoke.^e; %quantity at choke price (acre-feet)
qchokef = qchoke;
tb = totalbenefit(a, e, qchoke, q, pchoke);
dtbf = tb;

nb = netbenefit(tc, tb);
dnbf = nb;

%% D - Regional totals

%last four sections and this esentially the same as part a
%with a new total amount 

drtc = dtci + dtco + dtcv + dtcf; %regional total cost is the sum of the total cost for each sector
drtb = dtbi + dtbo + dtbv + dtbf; %regional total benefit is the sum of the total cost for each sector
drnb = dnbi + dnbo + dnbv + dnbf; %regional total cost is the sum of the total cost for each sector
drnbcheck = drtb - drtc;

%% D - ChChChChChanges 

changenbi = nbi - dnbi; %6.0429e6 = 1.0862e9 - 1.0801e9
changenbo = nbo - dnbo; %2.9952e6 = 2.9257e8 - 2.8958e8
changenbv = nbv - dnbv; %2.6221e6 = 7.4164e6 - 4.7943e6
changenbf = nbf - dnbf; %2.6823e6 = 4.1055e6 - 1.4233e6
changernb = rnb - drnb; %1.4342e7 = 1.3903e9 - 1.3759e9

%% E(B) - Finding quantities

%repeat guess and check procedure from a with new total goal: 400000

mnb = 13.61; 

p = 978; %price at equilibrium point (dollars)
q = 190056; %quantity at equilibrium point (acre-feet)
e = -0.3; %elasticity
a = alphavalue(p,q,e); %output is alpha term, a
ai = a; %saving this value as alphaindoor for future reference
eqi = (mnb + p)^e * (a);


p = 978; %price at equilibrium point (dollars)
q = 94886; %quantity at equilibrium point (acre-feet)
e = -0.75; %elasticity
a = alphavalue(p,q,e); %output is alpha term, a
ao = a;
eqo = (mnb + p)^e * (ao);

p = 30; %price at equilibrium point (dollars)
q = 100000; %quantity at equilibrium point (acre-feet)
e = -0.5; %elasticity
a = alphavalue(p,q,e); %output is alpha term, a
av = a;
eqv = (mnb + p)^e * (av);

%call alpha function
p = 30; %price at equilibrium point (dollars)
q = 147000; %quantity at equilibrium point (acre-feet)
e = -1.5; %elasticity
a = alphavalue(p,q,e); %output is alpha term, a
af = a;
eqf = (mnb + p)^e * (af);

etotal = eqi + eqo + eqv + eqf;
%4.4999e5 = 1.8927e5 + 9.3908e4 + 8.2941e4 + 8.3873e4

%% E(C) - Marginal Net Benefits 

marginalnetbenefit = 13.61; %taken from last section - where value of last unit is same across all sectors
%the value of a water right is the infinite sum of a/(1-d)^t 
% this equates to a/d
ewaterright = 13.61/0.08; %170 dollars

%% E(D) - Indoor Municipal

q = eqi; %pi value from previous section
a = ai; %ai value from previous section
ei = -0.3; %elasticity
e = ei;
p = (q/a)^(1/e); 

tc = totalcost(p,q);
etci = tc;

pchoke = 10000; %choke price (dollars/acre-foot)
pchokei = pchoke;
qchoke = a * pchoke.^e; %quantity at choke price (acre-feet)
qchokei = qchoke;
tb = totalbenefit(a, e, qchoke, q, pchoke);
etbi = tb;

nb = netbenefit(tc, tb);
enbi = nb;

%% E(D) - Outdoor Municipal

q = eqo; %outdoor quantity found in previous section (qo)
a = ao; %alpha output from the last section (ao)
eo = -0.75; %elasticity
e = eo;
p = (q/a)^(1/e); 

tc = totalcost(p,q);
etco = tc;

%call totalbenefit function
pchoke = 10000; %choke price (dollars/acre-foot)
pchokeo = pchoke;
qchoke = a * pchoke.^e; %quantity at choke price (acre-feet)
qchokeo = qchoke;
tb = totalbenefit(a, e, qchoke, q, pchoke);
etbo = tb;

nb = netbenefit(tc, tb);
enbo = nb;

%% E(D) - Vegetables

q = eqv; %vegetable quantity found in first section (qv)
a = av; %alpha output from the first section (av)
ev = -0.5; %elasticity
e = ev;
p = (q/a)^(1/e); 

tc = totalcost(p,q);
etcv = tc;

%call totalbenefit function
pchoke = 150; %choke price (dollars/acre-foot)
pchokev = pchoke;
qchoke = a * pchoke.^e; %quantity at choke price (acre-feet)
qchokev = qchoke;
tb = totalbenefit(a, e, qchoke, q, pchoke);
etbv = tb;

nb = netbenefit(tc, tb);
enbv = nb;

%% E(D) - Field Crops

q = eqf; %field crop quantity found in first section (qf)
a = af; %alpha output from the first section (af)
ef = -1.5; %elasticity
e = ef;
p = (q/a)^(1/e); 

tc = totalcost(p,q);
etcf = tc;

%call totalbenefit function
pchoke = 105; %choke price (dollars/acre-foot)
pchokef = pchoke;
qchoke = a * pchoke.^e; %quantity at choke price (acre-feet)
qchokef = qchoke;
tb = totalbenefit(a, e, qchoke, q, pchoke);
etbf = tb;

nb = netbenefit(tc, tb);
enbf = nb;

%% E(D) - Regional totals

ertc = etci + etco + etcv + etcf; %regional total cost is the sum of the total cost for each sector
ertb = etbi + etbo + etbv + etbf; %regional total benefit is the sum of the total cost for each sector
ernb = enbi + enbo + enbv + enbf; %regional total cost is the sum of the total cost for each sector
ernbcheck = ertb - ertc;

%% E(D) - ChChChChChanges 

echangenbi = enbi - dnbi; %3.4617e6 = 1.0836e9 - 1.0801e9
echangenbo = enbo - dnbo; %1.7104e6 = 2.9129e8 - 2.8958e8
echangenbv = enbv - dnbv; %1.3880e6 = 6.1823e6 - 4.7943e6
echangenbf = enbf - dnbf; %1.1776e6 = 2.6009e6 - 1.4233e6
echangernb = ernb - drnb; %7.7377e6 = 1.3837e9 - 1.3759e9
