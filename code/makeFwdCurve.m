function curve = makeFwdCurve(domCurve, forCurve, spot, tau)
    % makeFwdCurve: Create a structure to hold the forward curve data
    %
    % Inputs:
    % domCurve: domestic IR curve data
    % forCurve: foreign IR curve data
    % spot: spot exchange rate
    % tau: lag between spot and settlement
    %
    % Output:
    % curve: a struct containing data needed by getFwdSpot

    % Store the input data in the curve structure
    curve.domCurve = domCurve;
    curve.forCurve = forCurve;
    curve.spot = spot;
    curve.tau = tau;
end
