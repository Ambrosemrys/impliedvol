


function testInterestRateCurve()
    % Sample data for times to settlement and discount factors
    ts = [0.25, 0.5, 1, 2]; % in years
    dfs = [0.99, 0.975, 0.95, 0.9]; % sample discount factors

    % Make the interest rate curve
    curve = makeDepoCurve(ts, dfs);
    
    % Display the curve information
    fprintf('Interest Rate Curve:\n');
    fprintf('Times (years): %s\n', mat2str(curve.ts));
    fprintf('Discount Factors: %s\n', mat2str(curve.dfs));
    fprintf('Rates: %s\n', mat2str(curve.rates));
    
    % Test times to calculate the rate integral
    testTimes = [0.1, 0.25, 0.75, 1.5, 2, 3]; % in years
    fprintf('\nRate Integral Tests:\n');
    for t = testTimes
        integ = getRateIntegral(curve, t);
        fprintf('Integral up to %g years: %g\n', t, integ);
    end
end


