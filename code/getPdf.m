% Compute the probability density function of the price S(T)
% Inputs:
%    volSurf: volatility surface data
%    T: time to expiry of the option
%    Ks: vector of strikes
% Outputs:
%    pdf: vector of pdf(Ks)
function pdf = getPdf(volSurf, T, Ks)

    arguments

        volSurf (1,1) struct
        T (1,1) double {mustBeGreaterThanOrEqual(T,0)}
        Ks (:,:) double {mustBeGreaterThanOrEqual(Ks,0)}

    end
    

    fwd = getFwdSpot(volSurf.fwdCurve, T);
    
    % set threhold on small Ks
    zero_index = (Ks <= 0.1);
    non_zero = ~zero_index;
    hs = Ks(non_zero) * .1e-3;

    % calculate the second derivative using finite differences
    vLeft = getVol(volSurf, T, Ks(non_zero) - hs);
    cLeft = getBlackCall(fwd, T, Ks(non_zero) - hs, vLeft);
    
    v = getVol(volSurf, T, Ks(non_zero));
    c = getBlackCall(fwd, T, Ks(non_zero), v);
    
    vRight = getVol(volSurf, T, Ks(non_zero) + hs);
    cRight = getBlackCall(fwd, T, Ks(non_zero) + hs, vRight);

    pdf(non_zero) = (cRight - 2 * c + cLeft) ./ (hs.^2);
    pdf(zero_index) = 0;
end
