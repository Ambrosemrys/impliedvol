function vols = getSmileVol(curve, Ks)
    % getSmileVol: Gets the implied volatility at strikes Ks using pre-computed smile data
    %
    % Inputs:
    % curve: pre-computed smile data
    % Ks: vector of strikes
    %
    % Output:
    % vols: implied volatility at strikes Ks

    % Pre-allocate the output
    vols = zeros(size(Ks));

    % Determine indices for different regions
    idxLeft = Ks < curve.Ks(1);
    idxRight = Ks > curve.Ks(end);
    idxMiddle = ~idxLeft & ~idxRight;

    % For the left extrapolation region
    vols(idxLeft) = curve.vols(1) + ...
                    curve.aL .* tanh(curve.bL .* (curve.Ks(1) - Ks(idxLeft)));

    % For the right extrapolation region
    vols(idxRight) = curve.vols(end) + ...
                     curve.aR .* tanh(curve.bR .* (Ks(idxRight) - curve.Ks(end)));

    % For the middle interpolation region
    vols(idxMiddle) = ppval(curve.pp, Ks(idxMiddle));
end
