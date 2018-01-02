%% 1
%Perform calculations in Matlab given the following information:
%a is a double-precision number equal to 500.2
%b is an integer with the value 3
%c is a single-precision decimal number with the value 3.0
%What are the quantities a/b and a/c (to one decimal place)? Are they equal, and why or why
%not? Briefly discuss the differences between numerical precision and ?classes? and how they
%affect calculations

a = 500.2; %matlab defaults to double precision
b = int8(3); %integer
c = single(3.0); %single-precision

d = a/b; %127
e = a/c; %166.7333

%int8 maps values in an array outside the limit to the nearst endpoint (2^7 or 2^7-1)
%also will struggle to understnad infinity

%% 2

%Though computers allow us to do difficult calculations much more efficiently, they do have
%some shortcomings with respect to numerical solutions. Identify and discuss two ways that
%computer (or Matlab specifically) calculations will be incorrect due to the limitations of
%computers. (Hint: for one, think about the limits of computing memory)

%only stores to 16 sig figs (default)
%

%% 3

%Being able to store data within vectors and matrices is an integral part of computer
%programming. Build the following objects:
%a. A 1-by-10 vector containing the numbers 1 through 10 in order
threea = (1:10);
%b. A 1-by-7 vector containing increasing even numbers starting with 4
threeb = zeros(1,7);
for i = 2:7
    threeb(1) = 4;
    threeb(i) = threeb(i-1) + 2;
end
%c. An 8-by-1 vector starting with 100 and decreasing by 6 each element
threec = zeros(8,1);
for i = 2:8
    threec(1) = 100;
    threec(i) = threec(i-1) - 6;
end
%d. A 4x4 matrix of all zeroes
threed = zeros(4);
%e. A 3x9 matrix where the first row is consecutive odd numbers, the middle row is equal
%to the elements of the first row element-wise multiplied by 4.5, and the 3rd row is
%alternating 1s and 0s.
threee = zeros(3,9);
for i = 1:9
    threee(1,i) = 1 + 2*(i-1);
    threee(2,i) = threee(1,i) * 4.5;
    r = rem(i,2);
    if r == 0;
        threee(3,i) = 0;
    else
        threee(3,i) = 1;
    end
end

%% 4

%Another very important part of computing is reading and writing data. Take the matrix you
%built for part e in the previous question and write it to a csv named "Assignment1Data."
%Then, read the data from that csv back into Matlab and use indexing to report the first and 5th
%columns of the csv.

csvwrite('AssignmentData',threee)
foura = csvread('AssignmentData');
fourb = [foura(:,1) foura(:,5)];

%% 5 

%Logical operations allow us to perform any number of useful operations on large amounts of
%data, which make them perfect for programming. Similarly, if statements let us differentiate
%strategies based on logical observations. Based on the following information, write if
%statements (which incorporate logical operations) that produce the proper results.
%a. Given a day of the calendar year (where each month is 30 days long and January 1st
%is day 1 and December 31st is day 365), accept the number of the current day and
%return the name of the current season (Winter, Summer, etc.). For simplification, you
%can assume the first three months of the year are Winter, the next three are Spring,
%and so on. Show the results of your if statements for the 23rd, 150th, 270th, 271st,
%and 300th days of the year.

for i = [23, 150, 270, 271, 300]
    if i <= 90
        'Winter'
    elseif (90 < i) && (i <= 180)
        'Spring'
    elseif (180 < i) && (i <= 270)
        'Summer'
    elseif (270 < i) && (i <= 365)
        'Fall'
    end
end
% winter spring summer fall fall
%% 6

%Arguably the most important concept in programming is looping. For and while loops can be
%used to perform calculations over and over again with the click of a button. They are even
%more powerful when used in concert with if statements. Using both tools together, build a 2-
%by-X matrix that is a subset of e from Question 3. Your new matrix should contain the values
%from the first two rows of each column of e where the value of the third row in that column is 
%1. (Hint: you should iterate across columns and use indexing to extract the information you
%want. Think about how you would do this for a single column and then generalize it)

j = 1;
six = zeros(2,5);
for i = 1:9
    if threee(3,i) == 1
           six(1,j) = threee(1,i);
           six(2,j) = threee(2,i);
           j = j + 1;
    end
end

%% 7 

%Something else we have talked about is the use of functions to perform operations for us. For
%this problem, build a function that accepts a number and tells you whether or not that number
%is a prime number. Here is some information that may be helpful:
%a. 1. the modulo function in Matlab (mod(x,y)) accepts two input arguments (x and y)
%and returns the integer remainder of the calculation x/y
%b. 2. a prime number is only divisible by 1 and itself (meaning if you performed a
%modulo operation on a prime number p, the result of the calculations mod(p,1) and
%mod(p,p) would both be 0, there would be no other number x for which mod(p,x) equals 0)
%Write the code for your function below, and also return the outputs of your function for the
%numbers 2, 3, 19, 20, 43, and 599.


%function [ z ] = primefinder( p )

%z = 'prime';
%if p < 4
    %z = 'prime';
%else 
    %for x = 2:(p-1)
        %if mod(p,x) == 0
            %z = 'not';
        %end
    %end
%end
%end

p = [2,3,19,20,43,599];
for i = 1:6
    seven(i) = primefinder( p(i) );
end

%prime prime prime not prime prime
        
%% 8 

%Data analysis is useless unless you have a way to visualize it. Matlab is good for this
%because of its simple plotting tools and ease in calculating statistical properties of data. Take
%the following example:
%a. For the Triangle, long-term average precipitation (P) is about 42 in/yr and average
%evapotranspiration (ET) is about 26 in/yr. Annual P has a standard deviation of 10
%inches, while annual ET std. dev. is 5 in. We may assume that annual observations are
%independent and can be represented with normal distributions. Knowing this, and the
%general water balance equation Q = P - ET, build a 50yr synthetic timeseries of runoff
%(Q) based on timeseries of P and ET, then plot all 3 on the same graph. Include a title,
%legend, and all necessary labels. The x-axis will be the year (starting in year 1 and
%going to year 50), the y-axis will be inches of either Q, P, or ET for the given
%simulated year. Finally, report the average and standard deviation of Q. Does average
%Q and ET roughly add up to P? How does std. dev. of Q compare to the other std.
%devs?
%To do this, you will need to use the statistical properties of P and ET to build 50 year
%timeseries. This is possible using the Matlab function normrnd(mu,sigma,t,1) which would
%generate a t-length vector of normal random numbers relative to an average mu and standard
%deviation sigma.

annualprecip = 42; %in/year
annualET = 26; % in/year
stddevP = 10; %in/year
stddevET = 5; %in
P = normrnd(annualprecip,stddevP,50,1);
ET= normrnd(annualET,stddevET,50,1);
Q = P - ET;
average = mean(Q);
standarddeviation = std(Q);
year = 1:50;

plot(year,P,year,ET,year,Q);
title('50 Year Runoff');
xlabel('Year');
ylabel('Inches');
legend('Precipitation','Evapotranspiration','Runoff');

%% 9

%Matlab is a good programming language because of its ability to handle systems of
%with Q = 500 AF/yr of allocation available. The MNBs of each sector are as follows:
%a. MNBa = 300 - 3*wa
%b. MNBb = 250 - wb
%c. MNBc = 900 - 4*wc
%d. MNBd = 555 - 2*wd
%e. MNBe = 768 - 6*we
%Note that each equation is linear (so you do not need to use a solving function, just use linear
%algebra with vectors and matrices). What is the efficient allocation to each sector? 

% MNBa = MNBb
% MNBb = MNBc
% MNBc = MNBd
% MNBd = MNBe

% 300 - 3*wa = 250 - 1*wb
% 250 - 1*wb = 900 - 4*wc
% 900 - 4*wc = 555 - 2*wd
% 555 - 2*wd = 768 - 6*we

ws = [3 -1 0 0 0; 0 -1 4 0 0; 0 0 4 -2 0; 0 0 0 -2 6; 1 1 1 1 1];
u = [50 650 345 213 500];
nine = inv(ws) * u';
%final=[28.81,36.44,171,170,92.40];
%Q = 500;

%% 10

%I wish we had spent more time on lsqnonlin and similar functions that make
%solving systems a whole lot easier - there are so many handy little tricks
%to know!

%David, thanks so much for being so wonderful. You've definitely gone above
%and beyond this semester, and my understanding of all this material is a
%whole lot better because of you!
