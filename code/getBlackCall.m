function u = getBlackCall(f, T, Ks, Vs)
    % getBlackCall: Calculate the Black formula for the forward price of call options
    % using a vectorized approach.
    %
    % Inputs:
    % f: forward spot for time T, i.e., E[S(T)]
    % T: time to expiry of the option
    % Ks: vector of strikes
    % Vs: vector of implied Black volatilities
    %
    % Output:
    % u: vector of call options' undiscounted prices

    % Calculate d1 and d2 using vectorized operations
    d1 = (log(f ./ Ks) + 0.5 .* Vs.^2 .* T) ./ (Vs .* sqrt(T));
    d2 = d1 - Vs .* sqrt(T);

    % Calculate the call option price using the cumulative normal distribution function
    u = f .* normcdf(d1) - Ks .* normcdf(d2);
end
