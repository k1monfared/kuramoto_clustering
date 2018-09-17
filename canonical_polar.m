function y = canonical_polar(y)
    %   Input: given a vector y as the phases of a bunch of oscillators this 
    %          first, makes y(1) to be zero
    %          second, mods everything by 2*pi
    %          third, makes y(2) to be in the upper half plane
    %
    % Credit: Keivan Hassani Monfared, k1monfared@gmail.com
    
    y = y - y(1); % rotate so that y(1) is at zero radians.
    y = mod(y,2*pi); % mod by 2*pi
    if sin(y(2)) < 0 
        y = -y; % flip it so that y(2) is in the upper halp plane
    end
end