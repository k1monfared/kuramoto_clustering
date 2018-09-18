function [Q,E] = simple_girvan_newman_modularity(A,modules)
    % Inputs:
    %   A: a symmetric matrix with only nonnegative entries which is the
    %       (weighted) adjacecy matrix of a graph
    %   modules: a cell with indices of cluster i in its i-th entry
    %
    % Outputs:
    %   Q: the Girvan-Newman modilarity as defined in [1].
    %   E: the similarity matrix
    %
    %   NOTE: the formula in the paper says q = trace(E) - |E^2| while it
    %   should be q = trace(E) - |E.^2|. This is fixed here.
    %
    % Example:
    % m = 5;
    % n = 10;
    % A = [ones(m,m), zeros(m,n);
    %      zeros(n,m), ones(n,n)];
    % modules = {1:m, m+1:m+n};
    % [Q,E] = simple_girvan_newman_modularity(A,modules)
    %
    % [1] Newman, Girvan, Finding and evaluating community structure in
    % networks. Phys. Rev. E. 69, 026113 (2004)
    %
    % Other routines use:
    %   numesdges.m
    % 
    % To do:
    %   [ ] make the input to accept class index list
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    k = length(modules); % number of clusters 
    idxs = []; %all the indices appeared, in case of a subgraph
    E = zeros(k); % E is a matrix that rows and columns of it correspond to
                  % clusters, and E_ij is the fraction of edges that
                  % connect cluster i to cluster j
    for i=1:k
        for j = 1:k
            if i == j
                E(i,j) = numedges(A(modules{i},modules{j})); %number of intra edges of i
            else
                E(i,j) = sum(sum(A(modules{i},modules{j}))); %number of interedges between i and j
            end
        end
        idxs = [idxs,modules{i}]; % all the indices used, in case of a subgraph
    end
    m = numedges(A(idxs,idxs)); % total number of edges of the (sub)graph
    if m ~= 0 %if the graph is nonempty
        E = E/m; %devide E by total number of edges so that each entry becomes "fraction" of edges
    end
    Q = trace(E) - sum(sum(E^2)); %the formula as given in [1]
end