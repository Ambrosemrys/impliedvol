% Computes the price of a European payoff by integration
% Input :
%   volSurface : volatility surface data
%   T : time to maturity of the option
%   payoff : payoff function
%   subints : optional , partition of integration domain into sub - intervals
%         e.g. [0, 3, +Inf]. Defaults to [0, +Inf]
% Output :
%   u : forward price of the option (undiscounted price)
function u = getEuropean(volSurface, T, payoff, ints)
    
    arguments 
        volSurface (1,1) struct 
        T (1,1) double {mustBeGreaterThanOrEqual(T,0)}
        payoff (1,1) function_handle
        ints (:,1) double = [0, +Inf]
    end


    func = @(x) payoff(x) .* getPdf(volSurface, T, x);

    integrals = arrayfun(@(lower,upper) integral(func,lower,upper),ints(1:end-1),ints(2:end));
    u = sum(integrals);

end


