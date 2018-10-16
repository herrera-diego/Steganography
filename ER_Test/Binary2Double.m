function double = Binary2Double(binaryArray)

    n = 8;         % number bits for integer part of your number      
    m = 8;         % number bits for fraction part of your number
    
    % the inverse transformation
    double = binaryArray*pow2(n-1:-1:-m).';
    
end