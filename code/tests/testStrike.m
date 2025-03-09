classdef testStrike < matlab.unittest.TestCase

    methods(Test)

        % test if getStrikeFromDelta returns desired output
        function testStrikeAccuracy(testCase)          
             Fwds = [1.3,1.5];
             Ts = [0.8,0.8];
             cps = [1,-1];
             sigmas = [0.25,0.25];
             deltas = [0.5,0.5];
             Ks = [1.3329,1.5380];
             for i = 1:numel(Fwds)
                 Fwd = Fwds(i);
                 T = Ts(i);
                 cp = cps(i);
                 sigma = sigmas(i);
                 delta = deltas(i);
                 actVal = getStrikeFromDelta(Fwd,T,cp,sigma,delta);
                 expVal = Ks(i);
                 testCase.verifyEqual(actVal,expVal,'AbsTol',1e-4);
             end
        end
 
        % test if K output always non negative
        function testStrikeNonNegative(testCase)
             Fwds = [1.3,1.5,1.4];
             Ts = [0.25,0.5,1];
             cps = [1,-1,1];
             sigmas = [0.25,0.25,0.30];
             deltas = [0.5,0.5,0.1];
             for i = 1:numel(Fwds)
                 Fwd = Fwds(i);
                 T = Ts(i);
                 cp = cps(i);
                 sigma = sigmas(i);
                 delta = deltas(i);
                 actVal = getStrikeFromDelta(Fwd,T,cp,sigma,delta);
                 testCase.verifyGreaterThanOrEqual(actVal,0,'Property test failed: Negative Strike');
             end
        end
    end

end