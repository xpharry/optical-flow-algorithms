function psi = psiDeriv(s2, epsilon)

if nargin < 2
    epsilon = 0.001;
end

psi = 0.5./sqrt(s2+epsilon^2);