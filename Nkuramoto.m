function dydt = Nkuramoto(y,omega,A,coupling)
    % Inputs:
    %   y is the initial point
    %   omega is the natural frequencies of the oscilators, default: zero.
    %   A is the adjacency matrix, default: global coupling, that is A = J.
    %   coupling: coupling strength, default: 0.1
    % output:
    %   y after one iteration
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com

    Nosc = length(y);
    if nargin < 4
        coupling = 0.1;
        if nargin < 3
            A = ones(Nosc,Nosc);
            if nargin < 2
                omega = zeros(1,Nosc);
            end
        end
    end

    dydt = zeros(Nosc,1); 

    for i=1:Nosc
        dydt(i) = omega(i) ;
        for j=1:Nosc 
          dydt(i) = dydt(i) + (coupling/Nosc) * A(i,j) * sin( y(j)-y(i) );
        end
    end
end