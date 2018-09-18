function CL = sorted_class_list(L)
    % L is a cell with some number of classes with total of n elements
    % output is a list of length n with correponding SORTED class numbers 
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    m = zeros(numel(L),1);
    for j = 1:numel(L)
        m(j) = min(L{j});
    end
    [B,~] = sort(m); %B is the sorted m, I is the indices
    [II,~] = permutation_from_to(B,m);

    for j = 1:numel(L)
        for k = 1:numel(L{j})
            CL(L{j}(k)) = II(j);
        end
    end
    
    CL = CL(:);
end