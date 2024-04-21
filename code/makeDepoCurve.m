function curve = makeDepoCurve(ts, dfs)
    % makeDepoCurve: Create a structure to hold the interest rate curve data
    %
    % Inputs:
    % ts: array of times to settlement in years
    % dfs: array of discount factors
    %
    % Output:
    % curve: a struct containing data needed by getRateIntegral

    
    rates = -log(dfs) ./ ts;
   
    curve.ts = ts;
    curve.dfs = dfs;
    curve.rates = rates;
    curve.lastRate = rates(end);
end


