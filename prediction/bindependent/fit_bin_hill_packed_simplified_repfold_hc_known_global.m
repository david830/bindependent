load('../../devices/TAL14/TAL14-Fine.mat');

TAL14.in = results.Means{1, 2};
TAL14.in = TAL14.in(19:39, [1 5:end]);
TAL14.out = results.Means{3, 2};
TAL14.out = TAL14.out(19:39, [1 5:end]);

load('../../devices/TAL21/TAL21-Fine.mat');
TAL21.in = results.Means{1, 2};
TAL21.in = TAL21.in(19:39, [1 5:end]);
TAL21.out = results.Means{3, 2};
TAL21.out = TAL21.out(19:39, [1 5:end]);

load('../../devices/LmrA/LmrA-Fine.mat');
LmrA.in = results.Means{1, 2};
LmrA.in = LmrA.in(19:39, [1 5:end]);
LmrA.out = results.Means{3, 2};
LmrA.out = LmrA.out(19:39, [1 5:end]);

devices = {TAL14, TAL21, LmrA};
device_name = {'TAL14','TAL21','LmrA'};

model_set = 'geo_mefl';
model_name = 'Geo. Bin MEFL';

global P R1 dilution alpha_in;
dilution = 1 - (1/2)^(1/20);

devices = {TAL14, TAL21, LmrA};
seeds = ...
[5 5 0 log10(0.1);
5 4.8 0 log10(0.1);
5 4.4 0 log10(0.1);
];

seeds_TAL14 = ...
    [5 5 0 log10(0.1) log10(0.12) log10(0.1);
    5 5 0.3 log10(0.1) log10(0.12) log10(0.1);
    ];
seeds_TAL21 = ...
    [5 5 0 log10(0.1) log10(0.10) log10(0.08);
    5 5 0.3 log10(0.1) log10(0.10) log10(0.08);
    ];
seeds_LmrA = ...
    [5 4 0 log10(0.1) log10(0.17) log10(0.10);
    5 4 0.3 log10(0.1) log10(0.17) log10(0.10);
    ];

results = cell(3,1); % devices x seeds
model_results = cell(3,5);
model_err = zeros(3,5);

warning('off', 'all');

for c=1:3,
	selected_model = devices{c};
	data.in = selected_model.in(:, :);
% 	data.in = data.in.';
	data.out = selected_model.out(:, :);
%	data.out = data.out.';
%     for s=2:2,
    fprintf('Device %i:\n',c);
    % Search for the best params
    if c == 1,
        minfn = @(param) (test_repressor_bin_ode_model_packed_simplified_TAL14_hc_known(data,param));
    elseif c == 2,
        minfn = @(param) (test_repressor_bin_ode_model_packed_simplified_TAL21_hc_known(data,param));
    else
        minfn = @(param) (test_repressor_bin_ode_model_packed_simplified_LmrA_hc_known(data,param));
    end
    start = seeds(c,:);
    ub = [8 8 0 0];
    lb = [2 2 -4 -2]; 
    opts = optimoptions('fmincon','Algorithm','sqp');
    problem = createOptimProblem('fmincon', 'objective', minfn, 'x0', start, 'ub', ub, 'lb', lb, 'options', opts);
%     [params err] = fminsearch(minfn,start);%,os); 
    gs = GlobalSearch;
%     ms = MultiStart;
    [params, err] = run(gs, problem);
    fprintf('\nErr = %.3f; Params: %.2f %.2f %.2f %.2f \n',...
        err,params(1),params(2),params(3),params(4));
    R1 = devices{c};
    R1.DK = 10.^params(1);
    R1.alpha_out = 10.^params(2);
    R1.G3 = 10.^params(3);  % DK
    R1.G4 = 10.^params(4);  % alpha_out
    results{c, 1} = R1;
        
end

