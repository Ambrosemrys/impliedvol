% Inputs :
%    ts: array of size N containing times to settlement in years
%    dfs: array of size N discount factors
% Output :
%    curve : a struct containing data needed by getRateIntegral
function curve = makeDepoCurve(ts, dfs)
    arguments

        ts (:,:) double {mustBeGreaterThanOrEqual(ts,0)} 
        dfs (:,:) double {mustBeGreaterThan(dfs,0)} 
   
    end

    assert(all(size(ts) == size(dfs)), 'ts and dfs must have same size.');
   
    rates = zeros(size(dfs));
    
    if ts(1) == 0
        rates(1) = 0; 
    elseif ts(1) > 0
        rates(1) = -log(dfs(1)) / ts(1);
    end
    
    for i = 2:length(dfs)
        discount_factor_interval = dfs(i) / dfs(i-1);
        rates(i) = -log(discount_factor_interval) / (ts(i) - ts(i-1));
    end

    curve.ts = ts;
    curve.dfs = dfs;
    curve.rates = rates;
end
