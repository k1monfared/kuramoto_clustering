function [start_indices,side_lengths] = find_sections_lengths(B)
    % given a list B of integers that are repeated (a clustering) this
    % returns the indices where each section of a cluster starts and how
    % long it goes. For example for 
    %      1 2  3 4 5   6 7     8 9     10 11   12
    % B = [1,1, 2,2,2,  1,1,    4,4,    2, 2,   4];
    % it returns 
    %   for 1: 1 and 6 as indices and 2 and 2 for lengths
    %   for 2: 3 and 10 as indices and 3 and 2 for lengths
    %   for 4: 8 and 12 as indices and 2 and 1 for lengths
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    u = unique(B);
    k = length(u);
    start_indices = cell(1,k);
    side_lengths = cell(1,k);
    
    for i = 1:k
        C = B==u(i);
        C = C(:)';
        D = [0, C(1:end-1)];
        s = find(C-D ~= 0);
        
        if mod(length(s),2) %taking care of the last numbers 
            s = [s,length(B)+1];
        end
        
        start_indices{i} = s(1:2:end);
        side_lengths{i} = s(2:2:end) - s(1:2:end);
    end
end
