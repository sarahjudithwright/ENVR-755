matrix = zeros(8,5);

for row = 1:8
    if row == 1
        matrix(row,:) = [0:2:8];
    elseif row == 2
        matrix(row,:) = [1:3:13];
    elseif row == 3
        matrix(row,:) = [1:5];
    else
        matrix(row,:) = 2 * matrix(row-1,:);
    end
end
matrix
        