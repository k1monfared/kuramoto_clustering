function the_plot = my_polar(theta,labels,idx,vector)
    % theta is the list of angles
    % labels is boolean, 0 hides the labels, 1 shows the labels, default 0
    % idx is a clustering, it colors the points according to their clusters
    % vector is boolean, 0 hides the order vector, 1 shows it, default 0
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    if nargin < 4
        vector = 0;
        if nargin < 3
            idx = ones(size(theta));
            if nargin < 2
                labels = 0;
            end
        end
    end
    
    
    clusters = unique(idx);
    nclusters = length(clusters);
    
    ptemp = kuramoto_polar(0); %just for drawing the grid
    set(ptemp,'visible','off')
    
    cmp = distinguishable_colors(nclusters);

    hold on
    for i = 1:nclusters
        ppp = kuramoto_polar(theta(idx == clusters(i)));
        alpha(1/nclusters)
        set(ppp,'color',cmp(i,:))
    end
    
    rho = 1;
    xx = rho .* cos(theta);
    yy = rho .* sin(theta);
    if labels
        % label nodes
        node_labels = 1:length(theta);

        % print node labels
        for i = 1 : length(node_labels)
            text(1.15*xx(i), 1.15*yy(i), num2str(node_labels(i)),...
                'HorizontalAlignment', 'center', ...
                'HandleVisibility', 'off', 'Parent', gca,...
                'FontSize', 12);
        end
    end
    
    v = order_vector(theta);
    if vector 
        quiver(0, 0, v(1), v(2), 'color','black','linewidth',2);
    end
    
    text(0,-1.5,['r = ' num2str(norm(v))],...
        'color','black',...
        'HorizontalAlignment', 'center');
    
    if nargout == 1
        the_plot = ppp;
    end
end