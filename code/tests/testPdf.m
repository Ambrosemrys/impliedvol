classdef testPdf < matlab.unittest.TestCase
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
        % integral of pdf function is 1
        function testIntegralPdfEqualsOne(testCase)
            expSum = 1;
            func = @(x) getPdf(testCase.volSurf,1,x);
            actSum = integral(func,0,Inf);
            testCase.verifyEqual(actSum,expSum,'AbsTol', 1e-3);
            
            % pdf plot
            x = linspace(0, 6,1e3);
          
            y = func(x);
            figure; 
            plot(x, y); 
            xlabel('Ks'); 
            ylabel('Pdf'); 
            title('Pdf of Ks');
            grid on;
            
        end
        
        % mean of pdf is the forward
        function testMeanEqualsFwd(testCase)
            expMean = getFwdSpot(testCase.fwdCurve,1);
            % calculate mean using integral of x * pdf
            func = @(x) getPdf(testCase.volSurf,1,x).*x;
            actMean = integral(func,0,Inf);
            testCase.verifyEqual(actMean,expMean,'AbsTol', 1e-3);
        end
    end

end