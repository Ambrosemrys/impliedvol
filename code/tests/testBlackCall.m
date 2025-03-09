classdef testBlackCall < matlab.unittest.TestCase
    methods (Test)
        function testZeroStrike(testCase)
            f = 100;   
            T = 1;     
            Ks = [0, 90, 100, 110];   
            Vs = [0.2, 0.3, 0.25, 0.15]; 
            expected_u = [100, 17.0129, 9.9476, 2.5002];  
            u = getBlackCall(f, T, Ks, Vs);
            testCase.verifyEqual(u, expected_u, 'AbsTol', 1e-4); 
        end
        function testExtremeCases(testCase)
            f= 100;
            T=1;
            Ks = 0:1:200;
            Vs = 0:0.005:1;
       
            for i= 1:numel(Ks)
                for j= 1:numel(Vs)
                    u= getBlackCall(f,T,Ks(i),Vs(j));
                    testCase.verifyGreaterThanOrEqual(u,0, 'option price nust be non-negative');
                    testCase.verifyLessThanOrEqual(u, f, 'option price must be less t');
                end
            end
        end
    end
end
