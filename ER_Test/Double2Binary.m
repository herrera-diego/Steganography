function binary = Double2Binary(double)

    a = double;     % your float point number
    n = 8;         % number bits for integer part of your number      
    m = 8;         % number bits for fraction part of your number
    
    % binary number
    binary = fix(rem(a*pow2(-(n-1):m),2));
    
end