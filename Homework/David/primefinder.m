function [ z ] = primefinder( p )

z = 'prime';
if p < 4
    z = 'prime';
else 
    for x = 2:(p-1)
        if mod(p,x) == 0
            z = 'not prime';
        end
    end
end
end

