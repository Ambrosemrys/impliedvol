function [vols, fwd] = getVol(volSurf, T, Ks)
    % getVol: Interpolates the volatility for given maturity T and strikes Ks
    %
    % Inputs:
    % volSurf: volatility surface data
    % T: time to expiry of the option
    % Ks: vector of strikes
    %
    % Output:
    % vols: vector of volatilities for each strike
    % fwd: forward spot price for maturity T

    % Get the forward spot for the given T
    fwd = getFwdSpot(volSurf.fwdCurve, T);
    
    % Find the bracketing tenors for the given T
    prevTenorIndex = find(volSurf.Ts <= T, 1, 'last');
    nextTenorIndex = find(volSurf.Ts > T, 1, 'first');
    
    % If T is beyond our last tenor, return an error
    if isempty(nextTenorIndex)
        error('Interpolation beyond the last tenor is not allowed.');
    end
    
    % Linear in variance interpolation scheme along moneyness lines
    T_prev = volSurf.Ts(prevTenorIndex);
    T_next = volSurf.Ts(nextTenorIndex);
    K_prev = Ks * volSurf.fwds(prevTenorIndex) / fwd;
    K_next = Ks * volSurf.fwds(nextTenorIndex) / fwd;
    
    % Get volatilities for bracketing tenors and strikes
    vols_prev = getSmileVol(volSurf.smiles{prevTenorIndex}, K_prev);
    vols_next = getSmileVol(volSurf.smiles{nextTenorIndex}, K_next);
    
    % Calculate the interpolated variances
    variances = ((T_next - T) * vols_prev.^2 * T_prev + (T - T_prev) * vols_next.^2 * T_next) / (T_next - T_prev);
    vols = sqrt(variances / T);
end
