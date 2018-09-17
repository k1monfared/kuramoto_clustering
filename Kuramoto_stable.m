function [I, V, R, Y0, Yn] = Kuramoto_stable(adj_matrix,tmax,coupling,m,tol,imax)
    % outputs: 
    %   I: times for convergence for each initialization
    %   R: order parameter after convergence for each initialization
    %   Y0: all initializations 
    %   Yn: final phases
    %   
    %
    % Program to integrate the Kuramoto model 
    % 
    % load the adjacency matrix first to ensure that the non-zero edges are
    % used for the synchronization studies
    %
    % Nosc = Number of oscillators
    % tmax = 10000;    % original
    % imax = 1000; %average over imax iterations
    %
    % Other modules use:
    %   Nkuramoto.m
    %   order_vector.m
    %   canonical_polar.m
    %   stable_yet.m
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    if nargin < 6
        imax = 100;
        if nargin < 5
            tol = 10^(-5);
            if nargin < 4
                m = 1000;
                if nargin < 3
                    coupling = 0.10;
                    if nargin < 2
                        tmax = 10000;
                    end
                end
            end
        end
    end
    
    A = adj_matrix;
    Nosc = size(A,1);
    
    % Generating intrinsic frequencies with Cauchy (Lorentzian)
    % distribution, parameters a = 0 and b = 1, as in a + b * tan( pi*(rand(n) - 0.5) )
    %myomega = cauchyrnd(0, 1, 1, Nosc);
    %%% or let them all to be zero
    myomega = 0 * ones(1,Nosc);

    % Generating random initial conditions
    xmin = -pi;
    xmax = pi;
    % Write here the vector tspan as tinit : dt : tfinal
    tspan = [0:1:tmax];
    I = [];
    V = [];
    R = [];
    Y0 = [];
    Yn = [];
    T = zeros(1,numel(tspan));
    for i = 1:imax
        % This solves the ODE system defined in the sub-function "dydt.m" and 
        % returns the vector y(t,i) (for i = 1 to the number of dependent variables) 
        % at the times t defined in the vector tspan. Note that if you set 
        % tspan = [tinit tfinal] without specifying dt then the solver chooses
        % the times of output and returns them in the vector t
        ystart = unifrnd(xmin,xmax,Nosc,1);
        [t,y] = ode45(@(t,y) Nkuramoto(y,myomega,A,coupling),tspan,ystart);
        r = zeros(1,numel(t));
        for n = 1:numel(t)
            %y(n,:) = y(n,:) - y(n,1); % apply rotational symmetry so that the first one is always at 0 radians
            r(n) = norm(order_vector(y(n,:)));
        end
        idx = stable_yet(r, m, tol);
        
        I = [ I, idx ];
        V = [ V, order_vector(y(idx,:))'];
        R = [ R, r(idx) ];
        Y0 = [ Y0, canonical_polar(ystart) ];
        Yn = [ Yn, canonical_polar(y(idx,:)') ];
        
    end
end
