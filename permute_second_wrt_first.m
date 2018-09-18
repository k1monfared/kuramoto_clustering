function [id2e,benefit] = permute_second_wrt_first(id1,id2)
    % given two lists as clusterings, permutes the second one so that the
    % match between the first one and the second one is maximized. 
    % inputs: two lists of clusterings 
    % outouts: 
    %   id2e: the second list permuted
    %   benefit: how much the matching increased
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    [A,~,~,labels] = crosstab(id1,id2); %find the crosstab matrix. This is
                                        %the matrix we want to choose ncols
                                        %entries of it, no two in the same
                                        %row or column, so that the sum of
                                        %the entires is maximum. Here
                                        %labels will be used to change the
                                        %labels at the end. the crosstab
                                        %function sorts the unique labels
                                        %by default.

    m = max(max(A)); % since the munkres function minimizes the quantity
    B = m - A;       %the we want to maxmimize, and it works only with
                     %nonnegative matrices, we subtract the matrix from its
                     %maximum
    
    [assignment,~] = munkres(B); %find the optimal assignment. Here the 
                                 %output is a vector of the length equal to
                                 %the number of unique elements of id2.
                                 %assignment(i) says id2 == assignment(i) 
                                 % should be converted to id1 == i
    
    unassigned = setdiff(1:size(A,2),assignment); %in case that id2
    assignment = [assignment, unassigned];        %has more unique
                                                  %elements than id1,
                                                  %the unassigned
                                                  %entries will be
                                                  %relabeled so that
                                                  %the smallest
                                                  %numbers are chosen
    
    L = zeros(size(labels));                %Change the labels from strings
    for i = 1:numel(labels)                 %to numbers and take care of 0s
        if ~ isempty(labels{i})             %and other details
            L(i) = str2double(labels{i});
        end
    end
    nonnew1 = setdiff(1:size(L,1), L(:,1));
    count1 = 1;
    for i = 1:size(L,1)
        if L(i,1) == 0
            L(i,1) = nonnew1(count1);
            count1 = count1 + 1;
        end
    end
    
    id2e = zeros(size(id2)); %preaassign the new labeling for id2
    for i = 1:length(assignment)
        if assignment(i) > 0
            id2e(id2 == L(assignment(i),2)) = L(i,1); %relabel id2
        end
    end
    benefit = sum(id2e(:)==id1(:)) - sum(id2(:)==id1(:)); %compute how many more labels
                                              %are matched
end