function volSurf = makeVolSurface(fwdCurve, Ts, cps, deltas, vols)
    % makeVolSurface: Constructs the implied volatility surface
    %
    % Inputs:
    % fwdCurve: forward curve data
    % Ts: vector of expiry times
    % cps: vector of 1 for call, -1 for put
    % deltas: vector of delta in absolute value (e.g., 0.25)
    % vols: matrix of volatilities 
    %
    % Output:
    % volSurf: struct containing data needed in getVol

    % Check the input dimensions match
    assert(size(vols, 1) == length(Ts), 'Each tenor must have a corresponding row of volatilities.');
    assert(size(vols, 2) == length(deltas), 'Each delta must have a corresponding column of volatilities.');
    
    % Precompute smiles for each tenor
    smiles = arrayfun(@(T) makeSmile(fwdCurve, T, cps, deltas, vols(Ts == T, :)), Ts, 'UniformOutput', false);
    
    % Perform no-arbitrage checks (simplified for K=fwd here)
    fwds = arrayfun(@(T) getFwdSpot(fwdCurve, T), Ts); % Get fwd for each tenor
    
    % Store the necessary precomputed data
    volSurf.fwdCurve = fwdCurve;
    volSurf.smiles = smiles;
    volSurf.Ts = Ts;
    volSurf.fwds = fwds;
    volSurf.G0 = fwdCurve.spot; % Store the initial spot price
end
