classdef testEuropean < matlab.unittest.TestCase
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
         
        function testPutCallParity(testCase)
            T = 0.8;
            fwd =  getFwdSpot(testCase.fwdCurve,T);
             
            K = fwd*0.9;
            payoffC = @(x)max(x-K ,0);
            payoffP = @(x)max(K-x,0);
            c = getEuropean(testCase.volSurf , T, payoffC); % 0.2105
            p = getEuropean(testCase.volSurf , T, payoffP , [0,K]); % 0.0733
            
            actVal = c-p; % 0.1372
            expVal = (fwd - K) / (fwd / testCase.fwdCurve.spotX);  
            testCase.verifyEqual(actVal,expVal,'AbsTol',1e-2);

        end

         
        function testEqualsBS(testCase)
            consvols = [25.00 25.00 25.00; 25.00 25.00 25.00 ;25.00 25.00 25.00]/100;
            Ts = [0.1; 0.5; 1];
            dummyvolSurf = makeVolSurface (testCase.fwdCurve , Ts , [-1,-1,1], [0.1 , 0.25 , 0.5],  consvols); 
            T = 0.8;
            fwd =  getFwdSpot(testCase.fwdCurve,T);
            K = fwd;
            payoff = @(x)max(x-K ,0);
            actPrice = getEuropean(dummyvolSurf , T, payoff);
            bsPrice = getBlackCall(fwd,T,K,0.25);
            testCase.verifyEqual(actPrice,bsPrice,'AbsTol',1e-4);

        end
        
        % test digital call with vanilla replication +(C(K-h) - C(K+h))/2h
        function testDigital(testCase)
            fwd = getFwdSpot(testCase.fwdCurve,0.8);
            bump_size = 1e-4;

            payoffL = @(x)max(x-(1-bump_size)*fwd,0);
            payoffR = @(x)max(x-(1+bump_size)*fwd,0);         
            actPrice = (getEuropean(testCase.volSurf,0.8,payoffL) - getEuropean(testCase.volSurf,0.8,payoffR))/(2*bump_size*fwd);

            payoffD = @(x) (x > fwd) .* 1;
            expPrice =  getEuropean(testCase.volSurf,0.8,payoffD);

            testCase.verifyEqual(actPrice,expPrice,'AbsTol', 1e-6);
 
        end
    end
end