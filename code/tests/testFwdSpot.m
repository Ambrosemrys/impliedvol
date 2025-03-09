classdef testFwdSpot < matlab.unittest.TestCase

    properties
        fwdCurve;
    end
    
    methods(TestClassSetup)
        function createFwdCurve(testCase)
            Ts = [0.1; 0.5; 1];
            domCurve = makeDepoCurve (Ts , [0.99962;0.99922;0.99882] );
            forCurve = makeDepoCurve (Ts , [0.99923;0.99845;0.99766] );
            testCase.fwdCurve = makeFwdCurve ( domCurve , forCurve , 1.5 , 2 / 365 );
        end
    end
  

    methods(Test)

        function testFwdAccuracy(testCase)
             Ts = [0,0.25,0.5,0.75,1];
             us = [1.5000,1.4992,1.4989,1.4986,1.4983];
             for i = 1:numel(Ts)
                 T = Ts(i);
                 u = us(i);
                 fwd = getFwdSpot(testCase.fwdCurve,T);
                 testCase.verifyEqual(fwd,u,'AbsTol',1e-4);
             end
        end
        function testFwdNonNegative(testCase)
            % property test: fwd >= 0
            Ts = [0,0.3,0.5,0.7,1];
            for i = 1:numel(Ts)
                T = Ts(i);
                fwd = getFwdSpot(testCase.fwdCurve,T);
                testCase.verifyGreaterThanOrEqual(fwd,0,sprintf('Property test failed: Negative Forward Price when T=%f',T));
            end
        end
    end

end