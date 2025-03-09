% Inputs :
%    curve : pre - computed smile data
%    Ks: vetor of strikes
% Output :
%    vols : implied volatility at strikes Ks
function vols=getSmileVol(curve, Ks)

    arguments
        
        curve (1,1) struct 
        Ks (:,:) double {mustBeGreaterThanOrEqual(Ks,0)}

    end

    vols = zeros(size(Ks));
    
    %get indices for different Ks
    leftIndices = Ks <= curve.K1;
    rightIndices = Ks >= curve.KN;
    middleIndices = ~leftIndices & ~rightIndices;
    
    %volatility smile interpolation 
    vols(leftIndices) = curve.vol1 + curve.aL * tanh(curve.bL * (curve.K1 - Ks(leftIndices)));
    vols(rightIndices) = curve.volN + curve.aR * tanh(curve.bR * (Ks(rightIndices) - curve.KN));
    vols(middleIndices) = ppval(curve.pp, Ks(middleIndices));

end

