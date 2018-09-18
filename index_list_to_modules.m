function modules = index_list_to_modules(idx,idxs)
    % Inputs:
    %   idx: a list on length n with k distinct numbers in it
    %       idx(i) is the modules number that i belongs to
    %   idxs: the list of the "names" of original nodes to be put in
    %       Default: 1:n
    %
    % Outputs: 
    %   modules: a cell of k lists where i in is list idx(i)
    %       different clusters,
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    n = numel(idx); %number of objects
    if nargin < 2
        idxs = 1:n;
    end
    nmods = max(idx); %number of modules
    modules = cell(1,nmods); %preassign modules
     for i = 1:nmods
         modules{i} = [];
     end
     for i = 1:n
         modules{idx(i)} = [modules{idx(i)},idxs(i)];
     end
end