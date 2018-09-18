function [Q] = girvan_newman_modularity(A,modules)
    % Inputs:
    %   A: the (simple/signed/weigthed) adjacency matrix of a graph
    %   modules: a cell with indices of cluster i in its i-th entry
    %       e.g. modules = {[1,2,3], [4,5,6,7,8], [9,10]}
    %
    % Outputs:
    %   Q: the signed version of the Girvan-Newman modularity as defined by
    %       Gomez et al. [1].
    %
    %   [1] ...
    %
    % Other routines used:
    %   positive_matrix.m
    %   negative_matrix.m
    %   numedges.m
    %
    % To do:
    %   [ ] update so that instead of modules it accepts a class index list
    %       as input
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    QsP = 0; %modulairty of the positive part
    QsN = 0; %modularity of the negative part
    AP = positive_matrix(A); % the positive part of the matrix
    AN = negative_matrix(A); % the negative part of the matrix
    % note that A = AP - AN
    nedgesP=numedges(AP); % compute the total weight of positive edges
    nedgesN=numedges(AN); % compute the total weight of negative edges
    if nedgesP == 0
        QsP = 0;
    else
        QsP = simple_girvan_newman_modularity(AP,modules);
    end
    if nedgesN == 0
        QsN = 0;
    else
        QsN = simple_girvan_newman_modularity(AN,modules);
    end
    Q = (nedgesP*QsP - nedgesN*QsN)/(nedgesP+nedgesN);
end 