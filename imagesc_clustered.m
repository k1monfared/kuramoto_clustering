function [first,second] = imagesc_clustered(A,B)
    % A is a matrix
    % B is a clustering of its rows
    % output is the imagesc A with squares around the clusters with
    % different colors
    % Example:
    % B = [1,1,1,1,1,1,2,2,2,2,2,2,1,1,1,2,2,2,1,1,2,2,2,2,2,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4];
    % A = rand(length(B),length(B));
    % imagesc_clustered(A,B)
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    imagesc(A)
    hold on

    [start_indices,side_lengths] = find_sections_lengths(B);
    cmp = distinguishable_colors(length(side_lengths));
    for i = 1:length(side_lengths)
        top_left_corners = [start_indices{i};start_indices{i}]';
        draw_square(top_left_corners,side_lengths{i},'white',3)
        draw_square(top_left_corners,side_lengths{i},cmp(i,:),1.5)
    end
    
    if nargout > 0
        first = start_indices;
        second = side_lengths;
    end
end