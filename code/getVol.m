% Inputs:
%    volSurf: volatility surface data
%    T: time to expiry of the option
%    Ks: vector of strikes
% Output:
%    vols: vector of volatilities
%    fwd: forward spot price for maturity T
function [vols, fwd] = getVol(volSurf, T, Ks)

    arguments

        volSurf (1,1) struct 
        T (1,1) double {mustBeGreaterThanOrEqual(T,0)}
        Ks (:,:) double {mustBeGreaterThanOrEqual(Ks,0)}
         
    end

    if T > volSurf.Ts(end)
        error('getVol:ExtrapolationNotAllowed',...
            'Extrapolation beyond the last tenor is not allowed.');
    end

    fwd = getFwdSpot(volSurf.fwdCurve, T);
    
    % Bracketing tenors for the given T
    prevTenorIndex = find(volSurf.Ts <= T, 1, 'last');
    nextTenorIndex = find(volSurf.Ts >= T, 1, 'first');

    if T <= volSurf.Ts(1)
        vols = getSmileVol(volSurf.smiles{1},  Ks * volSurf.fwds(1) / fwd);
    else  
        T_prev = volSurf.Ts(prevTenorIndex);
        T_next = volSurf.Ts(nextTenorIndex);
        K_prev = Ks * volSurf.fwds(prevTenorIndex) / fwd;
        K_next = Ks * volSurf.fwds(nextTenorIndex) / fwd;
        vols_prev = getSmileVol(volSurf.smiles{prevTenorIndex}, K_prev);
        if prevTenorIndex == nextTenorIndex % case in which T is a member of Ts
            vols = vols_prev;
        else
            vols_next = getSmileVol(volSurf.smiles{nextTenorIndex}, K_next);
            vols = sqrt(((T_next - T) * vols_prev.^2 * T_prev + (T - T_prev) * vols_next.^2 * T_next) / ((T_next - T_prev)*T));
        end
    end
end

