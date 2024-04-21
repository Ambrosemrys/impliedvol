function K = getStrikeFromDelta(fwd, T, cp, sigma, delta)
    % getStrikeFromDelta: Computes the strike from a given delta
    %
    % Inputs:
    % fwd: forward spot for time T, i.e., E[S(T)]
    % T: time to expiry of the option
    % cp: 1 for call, -1 for put
    % sigma: implied Black volatility of the option
    % delta: delta in absolute value (e.g., 0.25)
    %
    % Output:
    % K: strike of the option

    % Calculate d1 for the given delta. Use inverse of the standard normal cdf.
    % For a call, delta = N(d1), for a put, delta = N(-d1).
    if cp == 1 % Call option
        d1 = norminv(delta);
    else % Put option
        d1 = norminv(1 - delta);
    end

    % Rearrange the Black-Scholes d1 formula to solve for K
    K = fwd * exp(-d1 * sigma * sqrt(T) + (0.5 * sigma^2 * T));
end
 