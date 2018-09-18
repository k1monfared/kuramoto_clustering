function run_kuramoto_cluster(A,tmax,coupling,m,tol,imax,verbose,maxk,repl,maxiter)
    % inputs: see "initialization" below for inputs.
    % for a simple stable run just input the matrix A.
    % outputs: all variables and figures are saved
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    MYDATETIME = string_date_time;
    n = size(A,1);
    % take a look at the matrix
    f1 = figure(); 
        imagesc(A);
        colormap('jet')
        caxis([-1,1])
        colorbar
        axis square
        title('Input network')
        
    % initialization:
    if nargin < 10
        maxiter = 1000; % max number of iterations in kmeans
        if nargin < 9
            repl = 10; % number of replications in kmeans
            if nargin < 8
                maxk = length(theta); % max number of cluters in kmeans
                if nargin < 7
                    verbose = 1; %wether to print percentages completed
                    if nargin < 6
                        imax = 1000; % will average over imax iterations with different random initializations in Kuramoto
                        if nargin < 5
                            tol = 10^(-5); % tolerance for stabilization in Kuramoto
                            if nargin < 4
                                m = 1000; % length of memory for stabilization in Kuramoto
                                if nargin < 3
                                    coupling = .1; % coupling strength in Kuramoto
                                    if nargin < 2
                                        tmax = 5000; % number of iterations for ode45 method in Kuramoto
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    fprintf('Running the Kuramoto model. This might take a while... \n');
    % Run the Kuramoto model to see how and when it converges
    [I, V, R, Y0, Yn] =  Kuramoto_stable(A,tmax,coupling,m,tol,imax,verbose);
        %   I: times for convergence for each initialization
        %   V: order vectors for each initialization
        %   R: order parameter after convergence for each initialization
        %   Y0: all initializations 
        %   Yn: final phases
    
    % throw away the runs that did not converge
    div = find(I==tmax+1); % what has not been converged has a convergence time of tmax+1
    if verbose
        fprintf('out of %d runs, %d did not converge, and will be ignored.\n',tmax,length(div));
    end

    I(div) = [];
    V(:,div) = [];
    R(div) = [];
    Y0(:,div) = [];
    Yn(:,div) = [];

    % take a look at outputs
    f2 = figure(); 
        boxplot(I,'notch','on',...
                  'labels',{'times for convergence'})
        hold on
        hline(median(I),'-.k','median')

    f3 = figure(); 
        boxplot(R,'notch','on',...
                  'labels',{'order parameters'})
        hline(median(R),'-.k','median')

    f4 = figure(); 
        [~,idm] = min(R);
        [~,idM] = max(R);
        subplot(2,1,1)
            my_polar(Yn(:,idm),1,ones(1,n),1)
            title(['a final phase with min order parameter.'])
            xlabel(['time for convergence: ' num2str(I(idm))])
        subplot(2,1,2)
            my_polar(Yn(:,idM),1,ones(1,n),1)
            title(['a final phase with max order parameter.'])
            xlabel(['time for convergence: ' num2str(I(idM))])

    % cluster the final phases
    best_sumd = inf;
    id = 0;
    fprintf('Clustering the Kuramoto results. This might take a while... \n');
    for k = 1:length(I) % for each of the initiations find the best clustering with best number of clusters accroding to the min sumd
        if verbose
            fprintf('clustering: %2.2f%% \n', k/length(I)*100);
        end
        [temp_idx,temp_sumd] = best_polar_cluster_kmeans_stable(Yn(:,k),maxk,repl,maxiter); 
        if temp_sumd < best_sumd
            best_sumd = temp_sumd;
            best_idx = temp_idx;
            id = k;
        end
    end

    modularity = girvan_newman_modularity(A,index_list_to_modules(best_idx));
    sumd = best_sumd;
    clusters = best_idx;
    
    % final output plots
    [C,p] = permute_with_clustering(A,clusters);

    f5 = figure(); 
        subplot(1,3,1)
            imagesc_clustered(A,clusters)
            colormap('jet')
            caxis([-1,1])
            colorbar
            axis square
            title('Original network')

        subplot(1,3,2)
            pp = my_polar(Yn(:,id),...
                              1,...
                              clusters,...
                              1);

            title(['Clustering of run ' num2str(id)])
            xlabel(['sumd = ' num2str(sumd)])

        subplot(1,3,3)
            imagesc_clustered(C,clusters(p))
            colormap('jet')
            caxis([-1,1])
            colorbar
            axis square
            title('Permuted network')
            set(gca,'xtick', 1:n);
            set(gca,'ytick', 1:n);
            set(gca,'xticklabels', p);
            set(gca,'yticklabels', p);
            xlabel(['modularity = ' num2str(modularity)])
    
            
    % save all variables and outputs
    if verbose
        fprintf('Saving all variables as outputs_%s_.mat \n', MYDATETIME);
    end
    save(['outputs_' MYDATETIME '.mat'],'A','best_idx','best_sumd','clusters','coupling','div','I','id','idm','idM','imax','modularity','R','sumd','tmax','tol','V','Y0','Yn');
    
    for i = 1:5
        if verbose
            fprintf('Saving figure %d as outputs_%s_fig_%d.png \n', i, MYDATETIME, i);
        end
        eval(sprintf('f = f%d;', i));
        save_as_png(f,['outputs_' MYDATETIME '_fig_' num2str(i)], 300, 4000, 4000)
    end
    close(f1,f2,f3,f4,f5)
end