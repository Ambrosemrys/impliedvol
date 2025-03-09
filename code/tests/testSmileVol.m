classdef testSmileVol < matlab.unittest.TestCase

    properties
        fwdCurve;
    end

    methods (TestClassSetup)
        function createSmileVol(testCase)
            Ts = [0.1;0.5; 1];
            domCurve = makeDepoCurve (Ts , [0.99962;0.99922;0.99882] );
            forCurve = makeDepoCurve (Ts , [0.99923;0.99845;0.99766] );
            testCase.fwdCurve = makeFwdCurve ( domCurve , forCurve , 1.5 , 2 / 365  );
        end
    end

    methods (Test)
        function samelengthInput(testCase)    
            T = 0.5;
            cps = [1,-1,1,1];
            deltas  = [0.2,0.25,0.3,0.35];
            vols = [0.3,0.25,0.2];
            testCase.verifyError(@()makeSmile ( testCase.fwdCurve , T, cps , deltas , vols), ...
                'ErrorId:vectorLengthMismatch');
        end
        
        function noconvexarbitrageInput(testCase)
            cps = [-1,1,1,1]; 
            deltas = [0.2,0.25,0.30,0.35]; 
            vols = [0.30,0.33,0.35,0.37];   
            T = 1;
            testCase.verifyError(@()makeSmile(testCase.fwdCurve, T, cps, deltas, vols), ...
                'ErrorId:arbitrageDetected')
        end
        
        function InterpolationPoints(testCase)
            cps = [-1;-1;1;1;1]; 
            deltas = [0.2;0.25;0.35;0.30;0.25]; 
            vols = [0.312;0.303;0.300;0.306;0.310];   
            T = 1;
            smile = makeSmile(testCase.fwdCurve, T, cps, deltas, vols);

            fwdSpot = getFwdSpot(testCase.fwdCurve, T); 
            % calculate the strikes from deltas
            strikes = arrayfun(@(cp, vol, delta) getStrikeFromDelta(fwdSpot, T, cp, vol, delta), cps, vols, deltas);
            
            % check interpolation points
            impliedVols = getSmileVol(smile, strikes);
            testCase.verifyEqual(impliedVols, vols, 'AbsTol', 1e-4);
        end

        function checkFixedPoints(testCase)
            cps = [-1,-1,1,1,1]; 
            deltas = [0.2,0.25,0.35,0.30,0.25]; 
            vols = [0.312,0.303,0.300,0.306,0.310];   
            T = 1;
            smile = makeSmile(testCase.fwdCurve, T, cps, deltas, vols);

            % check fixed points
            ks = [0.5,1,1.5];
            actualvols = getSmileVol(smile, ks);
            expvols = [0.32216 0.3221 0.29012];
            testCase.verifyEqual(actualvols, expvols, 'AbsTol', 1e-4);
        end

        function atmvolMin(testCase)
            cps = [-1,-1,1,1]; 
            deltas = [0.2,0.25,0.35,0.30]; 
            vols = [0.312,0.303,0.300,0.306];   
            T = 1;
            smile = makeSmile(testCase.fwdCurve, T, cps, deltas, vols);
            atmK = getFwdSpot(testCase.fwdCurve , T);
            atmvol = getSmileVol(smile, atmK);

            anyKs = linspace(atmK-1, atmK+1, 5);
            anyvols = getSmileVol(smile, anyKs);
            testCase.assertGreaterThanOrEqual(anyvols, atmvol-1e-5, 'Vols should be greater than or equal atmvol');

        end

        function splinePlot(testCase)
            cps = [-1,-1,1,1,1]; 
            deltas = [0.1,0.25,0.6,0.25,0.1]; 
            vols = [0.312,0.303,0.300,0.306,0.3241];   
            smile = makeSmile(testCase.fwdCurve, 1, cps, deltas, vols);
            
            f = getFwdSpot(testCase.fwdCurve , 1);
            ks = linspace(0.1, 3, 200);  
            impliedVols = getSmileVol(smile, ks);  
            
            figure;
            plot(ks, impliedVols, 'b-', 'LineWidth', 2); 
            hold on;  
            
            plot(smile.K1, getSmileVol(smile, smile.K1), 'ro', 'MarkerSize', 10);  % smile.K1
            plot(smile.KN, getSmileVol(smile, smile.KN), 'ro', 'MarkerSize', 10);  % smile.KN
            plot(f, getSmileVol(smile, f), 'ro', 'MarkerSize', 10);  % atmK

            line([smile.K1 smile.K1], ylim, 'Color', 'red', 'LineStyle', '--');  
            line([smile.KN smile.KN], ylim, 'Color', 'red', 'LineStyle', '--'); 

            text(smile.K1, getSmileVol(smile, smile.K1), ' K1', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
            text(smile.KN, getSmileVol(smile, smile.KN), ' KN', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
            text(f, getSmileVol(smile, f), ' atmK', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left')

            title('Implied Volatility Smile');
            xlabel('Strike Price');
            ylabel('Implied Volatility');
            grid on;  
            hold off; 
            
        end
    end
end