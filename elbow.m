function idx = elbow(D,plot_flag)
    % Input: D, a list of decreasing numbers 
    % Output: idx, where the elbow is. That is if you plot D, where will
    %         you see the smallest angle. If there are multiple smallest
    %         ones, this prefers the first occurences, i.e. less number of
    %         clusters.
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    if nargin < 2
        plot_flag = 0;
    end
    left_angles = zeros(1,length(D));
    left_angles(1) = pi/2;
    Dla = zeros(1,length(D));
    for i = 2:length(D)
        left_angles(i) = atan(D(i-1)-D(i));
        Dla(i-1) = left_angles(i) - left_angles(i-1);
    end
    Dla(end) = -left_angles(end);
    [~,idx] = min(Dla); % elbos is the minimum angle
    
    if plot_flag
        plot(D,'-b','linewidth',2)
        hold on
        plot(idx,D(idx),'or','linewidth',2)
        hold off
    end
end