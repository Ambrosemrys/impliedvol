% Inputs:
%    domCurve: domestic IR curve data
%    forCurve: foreign IR curve data
%    spot: spot exchange rate
%    tau: lag between spot and settlement
% Output:
%    curve: a struct containing data needed by getFwdSpot
function curve = makeFwdCurve(domCurve, forCurve, spot, tau)

    arguments
        domCurve (1,1) struct 
        forCurve (1,1) struct  
        spot (1,1) double {mustBeGreaterThan(spot,0)}
        tau (1,1) double {mustBeGreaterThanOrEqual(tau,0)}

    end
     
    curve.domCurve = domCurve;
    curve.forCurve = forCurve;
    curve.spot = spot;
    curve.tau = tau;
    % calculate cash exchange rate X0 from S0
    curve.spotX = spot / exp(getRateIntegral(domCurve, tau) - getRateIntegral(forCurve, tau));

end
