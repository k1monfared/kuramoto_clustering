function idx = stable_yet(L,m,tol)  
    % Inputs:
    %   L: a given list
    %   m: length of memory, default: 1000
    %   tol: tolerance, default: 10^(-5)
    % 
    % Output:
    %   idx: the index for which the list hasn't changed more than tol for
    %        m steps. Note, this change is from an entry i to entry i+1.
    %        So, the total change can be m * tol at worst. If the
    %        conditions are not met, then the ooutput is the length of this
    %        list, which can be used as a flag. Like:
    %        if idx == length(L)
    %           print('Unstable!')
    %        end
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    if nargin < 3
        tol = 10^(-5);
        if nargin < 2
            m = 1000;
        end
    end
    n = length(L);
    dL = zeros(1,n-1);
    
    for i = 1:n-1
        dL(i) = abs(L(i+1) - L(i));
    end
    
    stable = 0; 
    for i = 1:n-1
        if dL(i) < tol
            stable = stable + 1;
            if stable > m
                break
            end
        else
            stable = 0;
        end
    end
    if i < n-1
        idx = i - m + 1;
    else
        idx = n;
    end
end