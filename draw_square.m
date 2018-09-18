function [fst,scnd] = draw_square(top_left_corners,side_lengths,color,lw)
    % top_left_corners is list of points for the top left corners of
    % suqares. Each ROW is a point
    % side_lengths, is a list of side lengths for squares in the same order
    % as top_left_corners.
    % if color is not given, it is red.
    % lw is linewidth, if it's not given it is 2
    % output is a bunch of square with a given color
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    if nargin < 4
        lw = 2;
        if nargin < 3
            color = 'r';
        end
    end
    
    for i = 1:length(side_lengths)
        t = top_left_corners(i,:)-1;
        l = side_lengths(i);
        first = [t, t+l];
        second = [t(1), t+l, t(2)+l];

        first = first + 0.5;
        second = second + 0.5;

        hold on
        plot(first, second, 'Color', color,'LineWidth',lw);
        plot(second, first, 'Color', color,'LineWidth',lw);
    end
    if nargout > 0
        fst = first;
        scnd = second;
    end
end