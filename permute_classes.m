function D = permute_classes(C,p)
    % C: a given class index list
    % p: a permutation
    % permutes entries of C accoring to the permutation p
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    D = zeros(size(C));
    for i = 1:length(C)
        D(i) = p(C(i));
    end
end