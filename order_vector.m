function v = order_vector(y)
    % Input: y is a set of phases of oscilators
    % Output: v is their sum if normalized to be on the unit circle
    % Note: norm(v) is called the order parameter of y
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    Nosc = length(y);
    sum = [0. 0.];
    for i = 1:Nosc
        sum(1) = sum(1) + cos(y(i));
        sum(2) = sum(2) + sin(y(i));
    end
    v = sum/Nosc;
end