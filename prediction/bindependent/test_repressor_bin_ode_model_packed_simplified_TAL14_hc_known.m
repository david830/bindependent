function err = test_repressor_bin_ode_model_packed_simplified_TAL14_hc_known(data,param)

global P R1 dilution alpha_in;
R1.DK = 10^(param(1));
R1.alpha_out = 10^(param(2));
R1.G3 = 10^(param(3));
R1.G4 = 10^(param(4));

% Fixed parameter:
dilution = 1 - (1/2)^(1/20);
% 46 hour span
tspan = [0 46];

plasmid_count = 10.^(0:20);
model_out = zeros(21,12);
for i=1:21,     % plasmid copy counts
    for j=1:12, % Dox levels
        P = plasmid_count(i);
        alpha_in = data.in(i,j);
        [T,Y] = ode15s(@hill_ODE_hour_new_packed_simplified_TAL14_hc_known,tspan,[0;0],[]);
        model_out(i,j) = Y(end,2);
    end
    %fprintf('.');
end
%fprintf('\n');
fprintf('.');

% param
err = fit_goodness([],data.out,[],model_out) + sum(sum(isnan(model_out)));
%param
%err
