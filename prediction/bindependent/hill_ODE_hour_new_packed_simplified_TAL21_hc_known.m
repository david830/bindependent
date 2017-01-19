% Fit to Hill equation model:
% A Hill equation will give us a relation between input concentration and production rate

function dy = hill_ODE_hour_new_packed_simplified_TAL21_hc_known(t, y)

global R1 dilution P alpha_in ;
% unpack y into named concentrations
In = y(1);
Out = y(2);

% Model: input builds up linarly, output builds in response

% alpha_in includes both Dox induction and plasmid copy count implicitly
alpha_in_eff = alpha_in / (1/(4*dilution)+exp(-6* dilution)/(4*dilution) + exp(-26 * dilution)/(2*dilution) - exp(-46 * dilution)/dilution) ;
P_eff = 0.5^floor(t/20);

dIn = alpha_in_eff * P_eff - dilution*In;

dOut = R1.alpha_out * P_eff * P^R1.G4 / (1 + (In / (R1.DK * P^R1.G3) )^1) + R1.alpha_out/10^3 * P_eff * P^R1.G4 - dilution*Out;

dy = [dIn; dOut];
