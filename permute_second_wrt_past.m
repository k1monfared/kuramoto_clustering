function [id2e,max_match] = permute_second_wrt_past(history,id2)
    % given a list as clusterings, permutes it so that the
    % match between the list and all the previous ones (hist) is maximized. 
    % inputs: a list of clustering, a two dimensional history
    % outouts: 
    %   id2e: the second list permuted
    %   benefit: how much the matching increased
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    if min(size(history)) == 1
        [id2e,~] = permute_second_wrt_first(history,id2);
        max_match = sum(id2e(:)==history(:));
        return
    else
        id2e_hist = zeros(size(history));
        match_hist = zeros(size(history,2),1);
        for j = 1:size(history,2) %each column of the hist is one clustering
            id1 = history(:,j);
            [id2e,~] = permute_second_wrt_first(id1,id2);
            id2e_hist(:,j) = id2e(:);
            match_hist(j) = sum(id2e(:)==id1(:));
        end
        [max_match,idx] = max(match_hist);
        id2e = id2e_hist(:,idx);
    end
end