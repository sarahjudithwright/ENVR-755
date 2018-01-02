%ENVR 755 Homework 2 part 2
%% F - municipal demand increases 1% per year

%loop that finds the total net benefit for all four sectors combined over
%five years

%[indoor, outdoor, veg, field]
growth = 0.01;
ipopulation = 1817000;
wpc = 140/325851; %water per capita
ei = -0.3;
eo = -0.75;
ev = -0.5;
ef = -1.5;
e = [ei, eo, ev, ef];
av = 547723;
af = 24154565;
p = [978, 978, 30, 30];
r = [532000, 400000];
q0 = [532000/4, 532000/4, 532000/4, 532000/4];

for year = 1:5;
    population = ipopulation * ((1 + growth).^(year-1));
    qtime = population * wpc;
    
    ai = (qtime*0.667)/(p(1)^ei);
    ao = (qtime*0.333)/(p(2)^eo);
    
    a = [ai, ao, av, af];
    
    %for 532000
    Qmore = lsqnonlin(@(q) lsquant(q, e, a, p, r(1)), q0, [0 0 0 0], [Inf Inf Inf Inf]);
    %for 400000
    Qless = lsqnonlin(@(q) lsquant(q, e, a, p, r(2)), q0, [0 0 0 0], [Inf Inf Inf Inf]);
    
    nb = netben(e, a, p, Qless, Qmore);
    tpvnb = nb/(1.08)^year;
end
tnb = sum(tpvnb); %-1.126e6
%% G

%market failure in this situation falls under the 'public good' category,
%implicitly valuing the endangered species

%% H

%[indoor, outdoor, veg, field]
growth = 0.01;
ipopulation = 1817000;
wpc = 140/325851; %water per capita
ei = -0.3;
eo = -0.75;
ev = -0.5;
ef = -1.5;
e = [ei, eo, ev, ef];
av = 547723;
af = 24154565;
p = [978, 978, 30, 30];
r = [400000, 400000];
q0 = [532000/4, 532000/4, 532000/4, 532000/4];
ai = (qtime*0.667)/(p(1)^ei);
ao = (qtime*0.333)/(p(2)^eo);
a = [ai, ao, av, af];

for year = 1:5;
    population = ipopulation * ((1 + growth).^(year-1));
    qtime = population * wpc;
    
        
    Qmore = lsqnonlin(@(q) lsquant(q, e, a, p, r(1)), q0, [0 0 0 0], [Inf Inf Inf Inf]);
    Qless = lsqnonlin(@(q) lsquant(q, e, a, p, r(2)), q0, [0 0 37594 55263], [Inf Inf Inf Inf]);
    
    hnb = netben(e, a, p, Qless, Qmore);
    htpvnb = hnb/(1.08)^year;
end
htnb = sum(htpvnb); %-1.126e6


% Based on my numbers from f and h, the difference is zero becasue these
% values came out the same. I'm not sure where my error popped up, but the
% net benefits of the situation with the transfer restrictions should be
% lower than with no restrictions. 

%% J

%The transfer retrictions implicitly value farmers and more rural 
%communities who depend on the farming industry. This is an example of a
%positive externality - supporting a whole slice of the population by changing the water
%allocations.



