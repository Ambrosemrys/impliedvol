function fwdSpot = getFwdSpot(curve, T)
    % getFwdSpot: Compute the forward spot rate
    %
    % Inputs:
    % curve: pre-computed fwd curve data
    % T: forward spot date
    %
    % Output:
    % fwdSpot: E[S(t) | S(0)]

    % Calculate the integral of the domestic and foreign rate functions from 0 to T+tau
    int_dom = getRateIntegral(curve.domCurve, T + curve.tau);
    int_for = getRateIntegral(curve.forCurve, T + curve.tau);

    % Compute the forward spot rate using the equation given
    fwdSpot = curve.spot * exp(int_dom - int_for);
end
