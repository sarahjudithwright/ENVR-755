% commented out
x = 1:
%% Section 2

%things to remember go here
%practicing and edits go in the command window - doesn't get saved

%class(variable) -> double - decimal with more digits, single - decimal
%with fewer digits
%if using math functions with different classes, default to lowest memory
%for vectors and matrices, use brackets - horizontal use spaces and vertical use ;
%for index, use parentheses
%vector' flips matrix
% .* is element-wise multiplication

y = [1 2 3 4 5]
for iteration = 1:5
    x = 1 + iteration
    y(iteration)
end
