% Fit to Hill equation model:
% A Hill equation will give us a relation between input concentration and production rate

function dy = hill_cascade_ODE_packed_simplified(t, y)

global R1 R2 P dilution alpha_in;
% unpack y into named concentrations
In = y(1);
Mid = y(2);
Out = y(3);

% Model: input builds up linarly, output builds in response

% alpha_in includes both Dox induction and plasmid copy count implicitly
alpha_in_eff = alpha_in / (1/(4*dilution)+exp(-6* dilution)/(4*dilution) + exp(-26 * dilution)/(2*dilution) - exp(-46 * dilution)/dilution) ;
P_eff = 0.5^floor(t/20);

dIn = alpha_in_eff * P_eff - dilution*In;

dMid = R1.alpha_out * P^R1.G4 * P_eff * 1 / (1 + (In / (R1.DK * P^R1.G3))^R1.H) + R1.alpha_out_base * P^R1.G4 * P_eff - dilution * Mid;
dOut = R2.alpha_out * P^R2.G4 * P_eff * 1 / (1 + (Mid / (R2.DK * P^R2.G3))^R2.H) + R2.alpha_out_base * P^R2.G4 * P_eff- dilution * Out;

dy = [dIn; dMid; dOut];
