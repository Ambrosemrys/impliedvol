% Inputs:
%    curve: pre-computed fwd curve data
%    T: forward spot date
% Output:
%    fwdSpot: E[S(t) | S(0)]
function fwdSpot = getFwdSpot(curve, T)
    arguments
        curve (1,1) struct 
        T (1,1) double {mustBeGreaterThanOrEqual(T,0)}
    end

     
    int_dom = getRateIntegral(curve.domCurve, T+curve.tau);
    int_for = getRateIntegral(curve.forCurve, T+curve.tau);

    fwdSpot = curve.spotX * exp(int_dom - int_for);
end