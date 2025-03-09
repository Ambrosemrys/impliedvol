% Inputs :
%    curve : pre - computed data about an interest rate curve
%    t: time
% Output :
%    integ : integral of the local rate function from 0 to t
function integ = getRateIntegral(curve, t)

    arguments 
        curve (1,1) struct 
        t (1,1) double {mustBeGreaterThanOrEqual(t,0)}         
    end

    if any(t < 0)
        error('ErrorId:Integralnegative',...
            'Time (t) must be greater than or equal to 0');
    end


    
    index = find(curve.ts >= t, 1);
    if index == 1 
        integ = curve.rates(1) * t;
    
    elseif t >= curve.ts(end)
            if ((curve.ts(end) + 30/365) < t)
                error('ErrorId:Integralbeyond',...
            'Extrapolation of interest rate beyond the last tenor is allowed up to 30 days');
            else
                time_interval = t - curve.ts(end);
                integral_before_last_point = sum(diff([curve.ts]) .* curve.rates(2:end));
                integ = curve.rates(end) * time_interval + curve.ts(1) * curve.rates(1) + integral_before_last_point;
            end
    else
        
        time_intervals = diff([curve.ts(1:index-1)]);
        rates = curve.rates(2:index-1);
        time_interval = t - curve.ts(index-1);
        integral_before_t = sum(time_intervals .* rates);
        integ = curve.ts(1) * curve.rates(1) + integral_before_t + time_interval * curve.rates(index);
    end

end
