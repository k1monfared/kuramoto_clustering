function [best_idx,best_sumd] = best_polar_cluster_kmeans_stable(theta,maxk,repl,maxiter)
    % Inputs:
    %   theta: list of points on the unit circle, angles in radian
    %   repl: number of replicates in kemans. default: 10
    %   maxiter: max number of iteration in kmeans. default: 1000
    % Outputs:
    %   best_idx: best clustering based on the "elbow" method
    %   best_sumd: the sum of distances from centroids from best_idx
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    if nargin < 4
        maxiter = 1000; % max number of iterations
        if nargin < 3
            repl = 10; % number of replications
            if nargin < 2
                maxk = length(theta); % max number of cluters
            end
        end
    end
    xx = cos(theta(:));
    yy = sin(theta(:));
    
    idxs = zeros(length(theta),maxk); %idx history
    sumds = zeros(1,maxk);
    for i = 1:maxk
        [idx,~,sumd] = kmeans([xx,yy],i,'MaxIter',maxiter,'Replicates',repl);
        idxs(:,i) = idx;
        sumds(i) = sum(sumd);
    end
    
    id = elbow(sumds); %the elbow method
    best_idx = idxs(:,id);
    best_sumd = sumds(id);
end