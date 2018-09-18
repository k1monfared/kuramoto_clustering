%% Create a random matrix that looks like a correlation matrix
% initialization:
n = 10; % number of oscillators
A = 2 * rand(n,n) - 1; % creat a random matrix between -1 and 1
A = (A + A') / 2; % symmetrize it
A = A - diag(diag(A)) + eye(n); % make diagonal entries equal to 1
                                % this will immitate a correlation matrix
%%                                
% take a look at the matrix
f1 = figure(); 
    imagesc(A);
    colormap('jet')
    caxis([-1,1])
    colorbar
    axis square
    title('Network')
%% Run the Kuramoto model to see how and when it converges
% initialization:
tmax = 5000; % number of iterations for ode45 method
coupling = .1; % coupling strength
m = 1000; % length of memory for stabilization
tol = 10^(-5); % tolerance for stabilization
imax = 1000; % will average over imax iterations with different random initializations

% run
[I, V, R, Y0, Yn] =  Kuramoto_stable(A,tmax,coupling,m,tol,imax);
    %   I: times for convergence for each initialization
    %   V: order vectors for each initialization
    %   R: order parameter after convergence for each initialization
    %   Y0: all initializations 
    %   Yn: final phases

% save all variables and outputs
save(['example_inputs_outputs.mat']);



%% reload
clear; clc;
load('example_inputs_outputs.mat')

%%
% throw away the runs that did not converge
div = find(I==tmax+1); % what has not been converged has a convergence time of tmax+1
fprintf('out of %d runs, %d did not converge, and will be ignored.\n',tmax,length(div));

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
        
%% cluster the final phases
best_sumd = inf;
id = 0;
for k = 1:length(I) % for each of the initiations find the best clustering with best number of clusters accroding to the min sumd
    fprintf('completed: %2.2f%% \n', k/length(I)*100);
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

% save all variables and outputs
save(['example_inputs_outputs.mat']);
%% final output plots

[C,p] = permute_with_clustering(A,clusters);

%%
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