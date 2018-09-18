# kuramoto_clustering
runs the kuramoto model on a network and clusters the network based on the final phases of oscillators

Let's start with creating a random signed matrix with 3 apparent clusters:

    clear; clc;
    N = [5,5,5];
    P = [.90,.10,.10; 
         .10,.85,.20; 
         .10,.20,.90];
    A = 2*random_multi_bottleneck_graph(N,P)-1 + eye(sum(N)); 
<img src="/outputs_2018_9_18_14_27_15_fig_1.png" width="400">

Then initialize,

    tmax = 5000; % number of iterations for ode45 method
    coupling = .1; % coupling strength
    m = 1000; % length of memory for stabilization
    tol = 10^(-5); % tolerance for stabilization
    imax = 1000; % will average over imax iterations with different random initializations

and run the Kuramoto model:

    [I, V, R, Y0, Yn] =  Kuramoto_stable(A,tmax,coupling,m,tol,imax);
        %   I: times for convergence for each initialization
        %   V: order vectors for each initialization
        %   R: order parameter after convergence for each initialization
        %   Y0: all initializations 
        %   Yn: final phases
        
throw away the runs that did not converge

    div = find(I==tmax+1); % what has not been converged has a convergence time of tmax+1
    fprintf('out of %d runs, %d did not converge, and will be ignored.\n',tmax,length(div));

    I(div) = [];
    V(:,div) = [];
    R(div) = [];
    Y0(:,div) = [];
    Yn(:,div) = [];

Let's take a look at outputs: time for convergence, order parameters, and final phases with min and max order paremters
<img src="/outputs_2018_9_18_14_27_15_fig_2.png" width="200">
<img src="/outputs_2018_9_18_14_27_15_fig_3.png" width="200">
<img src="/outputs_2018_9_18_14_27_15_fig_4.png" width="200">

cluster the final phases using kmeans:

    best_sumd = inf;
    id = 0;
    for k = 1:length(I) % for each of the initiations find the best clustering with best number of clusters accroding to the min sumd
        [temp_idx,temp_sumd] = best_polar_cluster_kmeans_stable(Yn(:,k)); 
        if temp_sumd < best_sumd
            best_sumd = temp_sumd;
            best_idx = temp_idx;
            id = k;
        end
    end

    modularity = girvan_newman_modularity(A,index_list_to_modules(best_idx));
    sumd = best_sumd;
    clusters = best_idx;
    
permute and plot the final result:

    [C,p] = permute_with_clustering(A,clusters);

<img src="/outputs_2018_9_18_14_27_15_fig_5.png" width="900">

Here the model found the clusters exactly as they were seen in the original network.



Same thing can be done for a weighted network, for example, one that is generated from a correlation matrix

    n = 10; % number of oscillators
    A = 2 * rand(n,n) - 1; % creat a random matrix between -1 and 1
    A = (A + A') / 2; % symmetrize it
    A = A - diag(diag(A)) + eye(n); % make diagonal entries equal to 1
                                    % this will immitate a correlation matrix

    run_kuramoto_cluster(A)
    
<img src="/fig5_clusters.png" width="900">
    
