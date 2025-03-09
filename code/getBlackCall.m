% Inputs :
%    f: forward spot for time T, i.e. E[S(T)]
%    T: time to expiry of the option
%    Ks: vector of strikes
%    Vs: vector of implied Black volatilities
% Output :
%    u: vector of call options undiscounted prices
function u = getBlackCall(f, T, Ks, Vs)

    arguments 

        f (1,1) double {mustBeGreaterThanOrEqual(f,0)}
        T (1,1) double {mustBeGreaterThanOrEqual(T,0)}
        Ks (:,:) double {mustBeGreaterThanOrEqual(Ks,0)}
        Vs (:,:) double {mustBeGreaterThanOrEqual(Vs,0)}

    end

    assert(all(size(Ks) == size(Vs)), 'Ks and Vs must have same size much.');

    
    % Regular Cases
    zero_idx = (Ks < 1e-8);
    non_zero_idx = ~zero_idx;
    non_zero_Ks = Ks(non_zero_idx);

    d1 = zeros(size(Ks));
    d2 = zeros(size(Ks));
    d1(non_zero_idx) = (log(f ./ non_zero_Ks) + 0.5 .* Vs(non_zero_idx).^2 .* T) ./ (Vs(non_zero_idx) .* sqrt(T));
    d2(non_zero_idx) = d1(non_zero_idx) - Vs(non_zero_idx) .* sqrt(T);
    u = f .* normcdf(d1) - Ks .* normcdf(d2);
    
    % ExtremeCase Handling
    u(zero_idx) = f;
    u(abs(u) < 1e-8) = 0; 
    u(Vs == 0) = max(f - Ks(Vs == 0), 0);

end
