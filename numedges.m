% Returns the total number of edges given the adjacency matrix
% Valid for both directed and undirected, simple or general graph
% INPUTs: adjacency matrix
% OUTPUTs: m - total number of edges/links
% Other routines used: selfloops.m, issymmetric.m
% GB, Last Updated: October 1, 2009
% Author: http://strategic.mit.edu/downloads.php?page=matlab_networks

function m = numedges(adj)

    sl = selfloops(adj); % counting the number of self-loops: sum of diags

    if issymmetric(adj) && sl == 0    % undirected simple graph
        m = sum(sum(adj))/2; 
        return
    elseif issymmetric(adj) && sl > 0 % undirected with self loops
        m = (sum(sum(adj))-sl)/2 + sl; % counting the self-loops only once
        return
    elseif not(issymmetric(adj))   % directed graph (not necessarily simple)
        m = sum(sum(adj));
        return
    end
end