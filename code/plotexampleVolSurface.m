
function plotexampleVolSurface()

    [spot , lag , days , domdfs , fordfs , vols , cps , deltas ] = getMarket ();
    tau = lag / 365;  
    Ts = days / 365;
    domCurve = makeDepoCurve (Ts , domdfs );
    forCurve = makeDepoCurve (Ts , fordfs );
    fwdCurve = makeFwdCurve ( domCurve , forCurve , spot , tau );
    volSurface = makeVolSurface ( fwdCurve , Ts , cps , deltas , vols ); 

    lcol = [135,14,179]/255;  

     
    numTenors = 100;
    Ts_Grid = linspace(volSurface.Ts(1)*0.8,volSurface.Ts(end),numTenors);
     
    strikeGrid = zeros(numTenors, 100);   
    volatilityGrid = zeros(numTenors, 100);
    tenorGrid = zeros(numTenors, 100); 
    
    for i = 1:numTenors
        currentSmile = volSurface.smiles{10};         
        strikeGrid(i, :) = linspace(0.9* currentSmile.K1, 1.1* currentSmile.KN, 100);    
        volatilityGrid(i, :) = getVol(volSurface,Ts_Grid(i),strikeGrid(i, :));
        tenorGrid(i, :) = Ts_Grid(i);
    end
    
 
    surf(strikeGrid, tenorGrid, volatilityGrid,'FaceAlpha',0.2);
    
    
    xlabel('Strike Price');
    ylabel('Time to Maturity (Years)');
    zlabel('Implied Volatility');
    title('Implied Volatility Surface');
    colorbar;  

    hold on;  

    for i = 1:10
        
        currentSmile = volSurface.smiles{i};
        K_values = linspace(currentSmile.K1, currentSmile.KN, 100);  
        V_values = getSmileVol(currentSmile,K_values);  

        
        originalVols = [currentSmile.vol1, currentSmile.volN];
        originalStrikes = [currentSmile.K1, currentSmile.KN];

        T_values = repmat(volSurface.Ts(i), size(K_values));
        plot3(originalStrikes, T_values([1, end]), originalVols, 'r.', 'MarkerSize', 30);

        plot3(K_values, T_values, V_values, 'Color',lcol, 'LineWidth', 2);
    end

     
    hold off; 
    xlabel('Strike Price');
    ylabel('Time to Maturity (Years)');
    zlabel('Implied Volatility');
    title('Implied Volatility Surface with Original Data Points');
    colorbar;   
end 
