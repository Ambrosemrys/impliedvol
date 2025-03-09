classdef testVol < matlab.unittest.TestCase
    
    properties
        volSurf;
        fwdCurve;
    end
    
    methods(TestClassSetup)
        function createVolSurface(testCase)
            
            Ts = [0.1; 0.5; 1];
            domCurve = makeDepoCurve (Ts , [0.99962;0.99922;0.99882] );
            forCurve = makeDepoCurve (Ts , [0.99923;0.99845;0.99766] );
            testCase.fwdCurve = makeFwdCurve ( domCurve , forCurve , 1.5 , 2 / 365 );
            vols = [20.80 20.20 20.00; 21.32 20.71 20.50 ;21.84 21.21 21.00]/100;
            testCase.volSurf = makeVolSurface (testCase.fwdCurve , Ts , [-1,-1,1], [0.1 , 0.25 , 0.5],  vols); 

        end
    end
    
    methods(Test)
        function testInterpolation(testCase)
             
            expVols = [0.2226 0.2075];
            expfwd = 1.4986;

            [actVols, actFwd] = getVol(testCase.volSurf, 0.75, [1,2]);

            testCase.verifyEqual(actFwd, expfwd, 'AbsTol', 1e-4);
            testCase.verifyEqual(actVols, expVols, 'AbsTol', 1e-4);

        end
 
        function testInterpolated(testCase)

            expVols_terminal =[0.2238,0.2093];
            fwd_terminal = 1.4983;

            [actVols_terminal, actFwd_terminal] = getVol(testCase.volSurf, 1, [1,2]);

            testCase.verifyEqual(actFwd_terminal, fwd_terminal, 'AbsTol', 1e-4);
            testCase.verifyEqual(actVols_terminal, expVols_terminal, 'AbsTol', 1e-4);

        end 

        function testErrorOnExtrapolation(testCase)

            T = 2.0;  
            Ks = [1.00, 1.05, 1.10];  
            
            testCase.verifyError(@()getVol(testCase.volSurf, T, Ks),'getVol:ExtrapolationNotAllowed');
        end

    end
end
