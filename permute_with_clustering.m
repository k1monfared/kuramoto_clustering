function [C,P] = permute_with_clustering(A,idx)
    % permute the rows and columns of A according to clustering given in
    % idx so that the clusters are next to each other.
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    k = max(idx);
    P = [];
    for t = 1:k
        p = find(idx==t);
        P = [P; p];
        C = A(P,P);
    end

end