function curve = makeSmile(fwdCurve, T, cps, deltas, vols)
    % makeSmile: Pre-computes all data necessary for the smile interpolation
    %
    % Inputs:
    % fwdCurve: forward curve data
    % T: time to expiry of the option
    % cps: vector if 1 for call, -1 for put
    % deltas: vector of delta in absolute value (e.g., 0.25)
    % vols: vector of volatilities
    %
    % Output:
    % curve: a struct containing data needed in getSmileVol

    % Assert vector dimension match
    assert(length(cps) == length(deltas) && length(deltas) == length(vols), ...
        'Input vectors must have the same length.');

    % Resolve strikes using getStrikeFromDelta
    Ks = arrayfun(@(cp, delta, vol) getStrikeFromDelta(fwdCurve.spot, T, cp, vol, delta), ...
                  cps, deltas, vols);

    % Check for arbitrages and add a dummy strike at the beginning
    Ks = [0, Ks];
    vols = [vols(1), vols]; % Assume same volatility for the dummy strike

    % Calculate call prices for arbitrage check
    Cs = arrayfun(@(K, vol) getBlackCall(fwdCurve.spot, T, K, vol), Ks, vols);

    % Check for monotonicity
    assert(all(diff(Cs) <= 0), 'Arbitrage detected: Call prices not monotonically decreasing.');

    % Check for convexity
    assert(all(diff(Cs, 2) >= 0), 'Arbitrage detected: Call price curve not convex.');

    % Remove the dummy strike added for arbitrage checking
    Ks(1) = [];
    vols(1) = [];

    % Compute spline coefficients using the 'spline' MATLAB function
    pp = spline(Ks, vols);

    % Compute the slopes of the spline at the endpoints
    spline_slope_left = pp.coefs(1, 3);
    spline_slope_right = pp.coefs(end, 3);

    % Compute parameters aL, bL, aR, bR
    KL = Ks(1) * Ks(1) / Ks(2);
    KR = Ks(end) * Ks(end) / Ks(end - 1);

    bR = atanh(sqrt(0.5)) / (KR - Ks(end));
    bL = -atanh(sqrt(0.5)) / (Ks(1) - KL);

    aR = spline_slope_right / bR;
    aL = -spline_slope_left / bL;

    % Store computed data in the curve structure
    curve.Ks = Ks;
    curve.vols = vols;
    curve.pp = pp;
    curve.aL = aL;
    curve.bL = bL;
    curve.aR = aR;
    curve.bR = bR;
    curve.T = T;
end
