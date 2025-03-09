% Inputs :
%    fwdCurve : forward curve data
%    T: time to expiry of the option
%    cps: vetor if 1 for call , -1 for put
%    deltas : vector of delta in absolute value (e.g. 0.25)
%    vols : vector of volatilities
% Output :
%    curve : a struct containing data needed in getSmileK
function [curve]=makeSmile(fwdCurve, T, cps, deltas, vols)
    % Hints :
    % 1. assert vector dimension match
    % 2. resolve strikes using deltaToStrikes
    % 3. check arbitrages
    % 4. compute spline coefficients
    % 5. compute parameters aL , bL , aR and bR


    % Ensure all input vectors have the same length
    arguments

        fwdCurve (1,1) struct
        T (1,1) double {mustBeGreaterThanOrEqual(T,0)}
        cps (:,1) double {mustBeMember(cps, [-1, 1])} 
        deltas (:,1) double {mustBeGreaterThanOrEqual(deltas,0), mustBeLessThanOrEqual(deltas,1)} 
        vols (:,1) double {mustBeGreaterThanOrEqual(vols,0)} 
 
    end

    assert(length(cps) == length(deltas) && length(deltas) == length(vols), ...
           'ErrorId:vectorLengthMismatch','Error: All input vectors must have the same length.');


    fwdSpot = getFwdSpot(fwdCurve, T);
    strikes = arrayfun(@(cp, vol, delta) getStrikeFromDelta(fwdSpot, T, cp, vol, delta), cps, vols, deltas);
    
    calls = getBlackCall(fwdSpot, T, [0; strikes], [0; vols]); 
    checkConvexArbitrage(calls, [0; strikes]);

    pp = csape(strikes, vols,'variational');
    pp_der = fnder(pp);

    sigma_prime_K1 = ppval(pp_der, strikes(1));
    sigma_prime_KN = ppval(pp_der, strikes(end));
    
    KL = strikes(1)^2 / strikes(2);
    KR = strikes(end)^2 / strikes(end-1);

    bL = atanh(sqrt(0.5)) / (strikes(1) - KL); 
    bR = atanh(sqrt(0.5)) / (KR - strikes(end)); 
    aR = sigma_prime_KN / bR;
    aL = -sigma_prime_K1 / bL;

    curve.pp = pp; 
    curve.aL = aL;
    curve.bL = bL;
    curve.aR = aR;
    curve.bR = bR;
    curve.K1 = strikes(1);
    curve.KN = strikes(end);
    curve.vol1 = vols(1);
    curve.volN = vols(end);
end

function checkConvexArbitrage(calls, strikes) 
     
    for i = 2:length(strikes) - 1
         
        slope_left = (calls(i) - calls(i-1)) / (strikes(i) - strikes(i-1));
        slope_right = (calls(i+1) - calls(i)) / (strikes(i+1) - strikes(i));
        
        if slope_left > slope_right
            error('ErrorId:arbitrageDetected',['Arbitrage opportunity detected between strikes ', num2str(strikes(i-1)), ', ', ...
                   num2str(strikes(i)), ' and ', num2str(strikes(i+1)), '.']);
        end
    end
   
end