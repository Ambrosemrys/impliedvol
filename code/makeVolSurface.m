% Inputs :
%    fwdCurve : forward curve data
%    Ts: vector of expiry times
%    cps: vetor of 1 for call , -1 for put
%    deltas : vector of delta in absolute value (e.g. 0.25)
%    vols : matrix of volatilities
% Output :
%    surface : a struct containing data needed in getVol
function volSurf = makeVolSurface(fwdCurve, Ts, cps, deltas, vols)

    arguments

        fwdCurve (1,1) struct
        Ts (:,1) double {mustBeGreaterThanOrEqual(Ts,0)}
        cps (:,1) double {mustBeMember(cps, [-1, 1])} 
        deltas (:,1) double {mustBeGreaterThanOrEqual(deltas,0), mustBeLessThanOrEqual(deltas,1)} 
        vols (:,:) double {mustBeGreaterThanOrEqual(vols,0)} 

    end

    assert(size(vols, 1) == length(Ts), 'Each tenor must have a corresponding row of volatilities.');
    assert(size(vols, 2) == length(deltas), 'Each delta must have a corresponding column of volatilities.');
     
    
    smiles = arrayfun(@(T) makeSmile(fwdCurve, T, cps, deltas, vols(Ts == T, :)), Ts, 'UniformOutput', false);
    
    % No-arbitrage checks (for atm calls)
    fwds = arrayfun(@(T) getFwdSpot(fwdCurve, T), Ts);  
    atmvols = arrayfun(@(idx) getSmileVol(smiles{idx}, getFwdSpot(fwdCurve, Ts(idx))), 1:length(Ts));
    calls = arrayfun(@(fwd, T, vol) getBlackCall(fwd, T, fwd, vol),fwds,Ts, atmvols');
    if ~all((calls(2:end) - calls(1:end-1)) > 0)
        error('Arbitrage Opportunity detected.')
    end

     
    volSurf.fwdCurve = fwdCurve;
    volSurf.smiles = smiles;
    volSurf.Ts = Ts;
    volSurf.fwds = fwds;
    volSurf.G0 = fwdCurve.spot;  
end
