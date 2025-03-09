classdef testRateIntegral < matlab.unittest.TestCase
    
    methods (Test)
        
        function testRateIntegralZeroTime(testCase)
            % Test when t = 0
            ts = [0, 1, 2, 3];
            dfs = [1, 2, 3, 0.80];
            curve = makeDepoCurve(ts, dfs);
            t = 0;
            integ = getRateIntegral(curve, t);
            expectedInteg = 0;
            testCase.verifyEqual(integ, expectedInteg);
        end
        
        function testRateIntegralLastTime(testCase)
            % Test when t is greater than or equal to the last time point
            ts = [0, 1, 2, 3];
            dfs = [1, 2, 3, 0.80];
            curve = makeDepoCurve(ts, dfs);
            t = 3.05;
            integ = getRateIntegral(curve, t);
            expectedInteg = curve.rates(end) * (t - curve.ts(end)) + curve.ts(1) * curve.rates(1) + sum(diff([curve.ts]) .* curve.rates(2:end));
            testCase.verifyEqual(integ, expectedInteg);
        end
        function testRateIntegralbeyond(testCase)
            % Test when t is greater than or equal to the last time point
            ts = [0, 1, 2, 3];
            dfs = [1, 2, 3, 0.80];
            curve = makeDepoCurve(ts, dfs);
            t = 4;
            testCase.verifyError(@()getRateIntegral(curve, t),'ErrorId:Integralbeyond');

        end
        
        function testRateIntegralTenorTime(testCase)
            % Test integral calculation when t = 0
            ts = [0, 1, 2, 3];
            dfs = [1, 2, 3, 0.80];
            curve = makeDepoCurve(ts, dfs);
            t = 1;
            integ = getRateIntegral(curve, t);
            expectedInteg = 2;
            testCase.verifyEqual(exp(-integ), expectedInteg);
        end
        
        function testOriginalPoint(testCase)
           
            ts = [1, 2, 3, 4, 5];
            dfs = [0.95, 0.90, 0.85, 0.80, 0.75];
            
            curve = makeDepoCurve(ts, dfs);
            
            % Verify returned curve contains the original input data
            testCase.verifyEqual(curve.ts, ts);
            testCase.verifyEqual(curve.dfs, dfs);
        end

    end
end

