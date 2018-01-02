%%%%%%%%%%%%%%%%%%%%BASIC MATLAB STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This is an .m file.  It is the built-in editor used by matlab and can be
%used to record a series of matlab commands.  Commands will be run in order
%by pressing the green 'play' button in the toolbar above.  Lines that are
%begun with a percentage sign (%), like these, will be overlooked by matlab
%and can be used to write comments to yourself and others

%% BASIC CALCULATOR FUNCTION
%%In its simplest form, matlab can function as a calculator to evaluate
%%arithmetic equations.  Some examples follow:

5+5
4-2
3*2
10/5
10\5 %either way works
3^4
4-3*2
(4-3)*2%Order of operations (same as in middle school!)
        %Parentheses
        %Exponents
        %Multiplication/Division (Left to right)
        %Addition/Subtraction
8^4/2-5*(3+3)^4

%% VARIABLES
%Matlab also has memory, which can be used to create and store variables.
%Variables can be manipulated after they are created.

x = 10
x = 5 %variables can be re-assigned after they are created
x = x + 30 %they can also be changed relative to themselves

x = 6; %use a semi-colon after the statement in order to suppress output
x

y = x; %variables can be created based on the values of other variables
x = x + 6;

%y = x+z;%variables must be initialized with a value 
                                    %before they are used.  note the error
                                    %message provides the location of the
                                    %error as well as a description of what
                                    %went wrong
z = 5;
y = x+z;

%% VARIABLE TYPES
% There are a variety of variable types available for use in matlab, and
% sometimes this can create confusion when doing basic arithmetic or using
% logical statements.

% Matlab stores inputs in a variety of ways.  With respect to numbers,
% there are integers, and either double or single precision floating-point
% decimal numbers.  The difference in decimal number storage is based on
% the amount of memory allocated to it.  Single precision floating-point
% numbers are less precise than doubles, because less memory is allocated
% for them.

a = 2.5;
class(a)
    % numeric variables in matlab default to double-precision,
    % floating-point variables
    % class type can be checked using this function

d = double(a);
class(d)
    % variables can also be coerced into other data types
    % here, a is already a double class variable, so this technically does
    % nothing, but now d is the same.
    
i = int16(a);
class(i)
    % however, now we see that a has been coerced into an integer. because
    % a was equal to 2.5, it is rounded up to 3 to become i. 

a = 2.5;
d = 2.0;
s = single(d);
i = int32(d);
    % now, notice what happens when different number types are used in
    % arithmetic operations together:

a/d
class(ans)
    % still double, because both variables were of class double
a/s
class(ans)
    % class single, because matlab defaults to single when it is used with
    % a double type
a/i
class(ans)
    % integer! this is important to remember, because the answer is rounded
    % and therefore not correct.  beware of this when importing data that
    % may contain integers

% There are a few other things to understand regarding precision of
% computers.  As there are different types of numbers with different
% amounts of memory allocated for each, the computer will only remember
% calculations to a certain precision.  Matlab's default precision is 16
% digits; this is when significant digits are actually important!

format long
    % typing this will force matlab to show digits it can store
eps(100)
    % here is an example of memory limits.  This output represents the 
    % difference between 100 and the next greatest double number that
    % matlab could produce next; any real number between 100 and 100 +
    % eps(100) is not accessible.  This distance is greater for single
    % precision numbers than for doubles. 

% If you find that you are working with numbers of high precision (in the
% trillions or greater) and you want to store extra values, keep in mind
% how much memory is allocated for a single variable.  After 16 digits,
% matlab may return numbers, but they are random and have no significance.
% This effect is compounded when calculating - multiplying together or
% dividing two numbers of many digits will reduce the number of meaningful
% digits (just like keeping up with sig figs).

a = (2^53 + 1) - 2^53;
    % here is an example of the limits of precision.  This is clearly equal
    % to 1...
a
    % but turns out to be 0, because Matlab can't remember significant
    % digits past 16, so adding 1 to this number is meaningless.

% Matlab is also limited by its inability to handle fractions.  See this
% example:

a = 1 - 3 * (4/3 - 1);
    % here, we write a statement that should be equal to 0
a
    % however, because the computer can't store 4/3 as a fraction, it must
    % round to 1.333333333333333, resulting in a not being equal to 0.

% Matlab also conceptualizes infitity and the lack of numbers well.  

a = 1/0;
a
    % Matlab returns Inf, rather than saying that this is impossible.
    % Remember, if you have a large calculation that returns Inf or -Inf
    % when it should not, you probably divided by 0.
    
% There is also the NaN class, which you will often see in imported excel
% files or other types of data.  It is what Matlab will fill space with in
% arrays or vectors when the other elements are numbers but either
% something is missing or there is an unexpected value.  Be aware of this
% possibility when importing data.

    
%% VECTORS&MATRICIES
%Variables can hold more than one value at a time.  When holding a group of
%values, variables are called vectors (1-d) or matricies (multiple d's).
%The fundamental blocks for much of matlab's usefulness is matricies -
%matlab is short for matrix laboratory.  Originally matlab was designed
%solely for the maniuplation of matricies and solving linear algebra
%problems.  It has since expanded its capabilities, but matricies are still
%a common and useful function of matlab

%Creating Vectors
shortVector = [1 2 3 4];
shortVector = 1:4;
shortVector = 1:2:40;
shortVector(5)
shortVector(5) = 10;
%you can do scalar math with vectors
shortVector = shortVector + 5;
shortVector = shortVector*2;
shortVector = 0;%vectors can be re-assigned to be single variables
shortVector = [x y z];
shortVector = [x + 5 y*2 x+z];
shortVector = shortVector';
shortVector = [x; y; z];

twoDimVector = [2 1; 3 4; 5 6];
twoDimVector(3,2) = z;
twoDimVector(3,3,1) = 1 ;
%%Matrix mulitplication
shortVector = [1 2 3];
shortVector2 = [1; 2; 3];
combined = shortVector*shortVector2;

lewis = [1 2 3; 4 5 6; 7 8 9];
alex = [9 8 7; 6 5 4; 3 2 1];
peter = lewis*alex;
peter = alex*lewis;%not the same

peter = alex.*lewis;%element-wise multiplication
peter = alex./lewis;%element-wise division


lewis = alex/peter;%for solving system of equations

%% Built-in matlab commands
%%matlab also has built in commands that are programmed to do common tasks.

lewis = linspace(125, 17000);
%linspace is a function that creates vectors.  
%You specify three different variables, one for the first number in the
%vector (1.2), one for the last number in the vector (17.4), and one for
%the total numbers in the vector (31), and it creates a vector with evenly
%spaced components

length_Lewis = length(lewis);
%give it a vector and it will tell you the total number of arguments in the
%vector.  note: if you input a matrix with more than one dimension, it will
%give you the length of the first dimension

size_Peter = size(peter);
%give it a matrix and it will return the lengths of each dimension in a
%vector.  the vector will have a length equal to the number of dimensions
%that are in the matrix

size_Peter_rows = size(peter,1);
%if you add a number to the size function, it only returns the length of
%the dimension that you specify with the number (in 2-d matricies, up/down
%is dimension 1 and left/right is dimension 2)

peter = zeros(5,5);
%zeros will initialize a matrix with all zeros.  The first number is how
%many rows of zeros you want, the second is how many columns
peter = zeros(5,4,3,2);
%matricies can take multiple dimensions

peter = ones(5,5);
%ones will initialize a matrix with all ones, in the same way zeros works.
peter = 5*ones(5,5);

peter = rand(5,5);
%rand will initialize a matrix with random numbers of a uniform
%distributions from 0-1 in the same way ones and zeros works.

peter = randn(5,5);
%randn will do the same thing as rand, but using a normal distribution with
%a mean of zero and a standard deviation of 1

peter = 5*randn(5,5) + 3;
%gives the distribution a mean of three and a standard deviation of 5;

peter = eye(4);
%creates a 4x4 identity matrix (ones down the diagonal in a square matrix)
peter = eye(4,3);
%creates a 4x3 matrix with ones down the diagonal, starting in space (1,1),
%leaving an empty row at the bottom because there are four rows but only
%three columnns

peter = diag(1:4);
%creates a matrix with the vector 1:4 down the diagonal



%% Loops in Matlab
%%matlab also allows you to automate the evaluation of a command or series
%%of commands many times under changing conditions.  The easiest ways to
%%do this are for and while loops:

%For loops
%for loops have the structure

%for <series of changing conditions>
%   <commands to be executed>
%end
for x = 1:10
    chris(x) = x;
end

%first, x is set equal to one, so the statement chrisMatthews(1) = 1 is 
%evaluated.  the loop reaches the end of the command list, goes back to the
%top, and then moves to the next condition in the list, x = 2, then
%evaluates chrisMatthews(2) = 2. This is repeated until x = 10, then the
%loop is completed

%multiple loops can also be nested, so that for every iteration of the
%outside loop, the inside loop has to finish all of its iterations (I like
%to think of it like the minute and hour hands on a clock)
for x = 1:10
    for y = 1:10
        chris(x,y) = x*y;
    end
end


%%%Examples

%Sum a vector
%Running sum of a vector
%Fibanacci sequence
%Duplicate elements in a vector

%A multiplication table
%A vector displaying factorials
%Convert a Matrix to a vector




%% Logical Statements
%In addition to numerical values, variables and matricies can also take
%logical values, where 0 = false and 1 = true.  Logical values are used
%when comparing variables using relational operators, less than (<), less
%than or equal to (<=), greater than (>), greater than or equal to (>=),
%equal (==), and not equal (~=).  The difference between == and = is
%that == will return a logical, while = will set a value.  Logicals are
%what is used in while loops to determine if the loop keeps going.

vince = 5;
julius = 10;
logicalOne = vince>julius;
logicalTwo = vince<julius;
logicalThree = julius>vince;
logicalFour = julius<vince;
logicalFive = julius==vince;
logicalSix = julius~=vince;

%logicals can also be used with arrays
micheal = [1 2 3; 4 5 6; 7 8 9];
michealLogical = micheal > 5;
michealLogical = micheal >= 5;
michealLogical = micheal == 5;
michealLogical = micheal ~= 5;

%Logical statements can also be combined using & (and) or | (or).  If the &
%operator is used, a statement is only true if all parts are true.  If the
%| operator is used, a statement is true if any of the parts are true

michealLogical = micheal > 4 & micheal < 7;
michealLogical = micheal < 4 | micheal > 7;

%If statements
%logicals can be used to evaluate commands only when certain conditions are
%met.  There are three basic formulations of an if statements

% 1) If/end statements

chris = 8;
if chris > 4 && chris < 7
    stuart = 6;
end

% 2) If/else/end statements

chris = 8;
if chris < 4 || chris > 7
    stuart = 6;
else
    stuart = 0;
end

% 3) If/elseif/else/end statements

chris = 50;

if chris < 4
    stuart = 7;
elseif chris < 10
    stuart = 9;
elseif chris > 20
    stuart = 10;
elseif chris > 30
    stuart = 11;
else

end

%In If/elseif/else/end statements, the final else part can be left out.
%This will result in nothing happening if none of the previous expressions
%are true.


%Examples
%What's the letter grade?
%Find the even numbers
%Daily vector showing month of the year


%While loops
%while loops are similar to for loops, but instead of a pre-described list
%of changing conditions, the commands are executed while a given statement
%remains true.  While loops can run for an indeterminant amount of time,
%and you should make sure that you have not written an infinite loop (i.e.
%the given condition will always be true).  To stop an infinite loop,
%press control-C
clear chris
counter = 1;
number = 50;
while number > 5
    chris(counter) = number;
    number = number^.5;
    counter = counter+1;
end

%% Practice Exercise

% Using what we have learned with indexing, vectors, matrices, if statements, 
% and looping structures, 

% use a for loop to build a matrix that is 8 rows by 5 columns, 
% where the first row is even numbers beginning with 2, the second
% row is every 3rd number beginning with 1, the third row is the numbers 1
% through 5 in order, the fourth row is equal to the third row with each
% element multiplied by 2, the fifth row is equal to the fourth row
% multiplied by 2, and so on until the matrix is filled.

% repeat this with a while loop!

% report the sum of each row and column.

M = zeros(8,5);

for row = 1:8;
  if row == 1;
      M(row,1:5) = 2:2:10;
  elseif row == 2;
      M(row,:) = 1:3:13;
  elseif row == 3;
      M(row,:) = [1 2 3 4 5];
  else
      M(row,:) = M(row-1,:) .* 2;   
  end
end

% ALTERNATE WAY

M(1,:) = 2:2:10;
M(2,:) = 1:3:13;
M(3,:) = 1:5;

row = 4;
while row < 9
    M(row,:) = M(row-1,:) .* 2;
    row = row + 1;
end

M











