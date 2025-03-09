% Inputs:
%    fwd: forward spot for time T, i.e., E[S(T)]
%    T: time to expiry of the option
%    cp: 1 for call, -1 for put
%    sigma: implied Black volatility of the option
%    delta: delta in absolute value (e.g. 0.25)
% Output:
%    K: strike of the option

function K = getStrikeFromDelta(fwd, T, cp, sigma, delta)

    arguments 

        fwd (1,1) double {mustBeGreaterThan(fwd,0)}
        T (1,1) double {mustBeGreaterThanOrEqual(T,0)}
        cp (1,1) double {mustBeMember(cp, [-1, 1])}
        sigma (1,1) double {mustBeGreaterThan(sigma,0)}
        delta (1,1) double {mustBeGreaterThanOrEqual(delta,0), mustBeLessThanOrEqual(delta,1)}
        
    end

    if cp == 1  
        d1 = norminv(delta);
    else  
        d1 = -norminv(delta);
    end

    K = fwd * exp(-d1 * sigma * sqrt(T) + (0.5 * sigma^2 * T));
end