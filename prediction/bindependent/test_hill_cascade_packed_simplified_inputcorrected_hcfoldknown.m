
load('../../cascades/LmrA-TAL14/LmrA-TAL14-Fine.mat');   
LmrATAL14.geo_mefl.in = results.Means{1, 2};
LmrATAL14.geo_mefl.in = LmrATAL14.geo_mefl.in(19:39, [1 5:end]);
LmrATAL14.geo_mefl.out = results.Means{3, 2};
LmrATAL14.geo_mefl.out = LmrATAL14.geo_mefl.out(19:39, [1 5:end]);

load('../../cascades/LmrA-TAL21/LmrA-TAL21-Fine.mat');
LmrATAL21.geo_mefl.in = results.Means{1, 2};
LmrATAL21.geo_mefl.in = LmrATAL21.geo_mefl.in(19:39, [1 5:end]);
LmrATAL21.geo_mefl.out = results.Means{3, 2};
LmrATAL21.geo_mefl.out = LmrATAL21.geo_mefl.out(19:39, [1 5:end]);

load('../../cascades/TAL14-LmrA/TAL14-LmrA-Fine.mat');
TAL14LmrA.geo_mefl.in = results.Means{1, 2};
TAL14LmrA.geo_mefl.in = TAL14LmrA.geo_mefl.in(19:39, [1 5:end]);
TAL14LmrA.geo_mefl.out = results.Means{3, 2};
TAL14LmrA.geo_mefl.out = TAL14LmrA.geo_mefl.out(19:39, [1 5:end]);

load('../../cascades/TAL14-TAL21/TAL14-TAL21-Fine.mat');
TAL14TAL21.geo_mefl.in = results.Means{1, 2};
TAL14TAL21.geo_mefl.in = TAL14TAL21.geo_mefl.in(19:39, [1 5:end]);
TAL14TAL21.geo_mefl.out = results.Means{3, 2};
TAL14TAL21.geo_mefl.out = TAL14TAL21.geo_mefl.out(19:39, [1 5:end]);

load('../../cascades/TAL21-LmrA/TAL21-LmrA-Fine.mat');
TAL21LmrA.geo_mefl.in = results.Means{1, 2};
TAL21LmrA.geo_mefl.in = TAL21LmrA.geo_mefl.in(19:39, [1 5:end]);
TAL21LmrA.geo_mefl.out = results.Means{3, 2};
TAL21LmrA.geo_mefl.out = TAL21LmrA.geo_mefl.out(19:39, [1 5:end]);

load('../../cascades/TAL21-TAL14/TAL21-TAL14-Fine.mat');   
TAL21TAL14.geo_mefl.in = results.Means{1, 2};
TAL21TAL14.geo_mefl.in = TAL21TAL14.geo_mefl.in(19:39, [1 5:end]);
TAL21TAL14.geo_mefl.out = results.Means{3, 2};
TAL21TAL14.geo_mefl.out = TAL21TAL14.geo_mefl.out(19:39, [1 5:end]);

load('params_simplified_repfoldknown_realglobal_floorcorrected.mat');
TAL14 = params(1, :);
TAL21 = params(2, :);
LmrA = params(3, :);

% Fixed parameter:
dilution = 1 - 0.5^(1/20);

global R1 R2 P dilution alpha_in;

% 46 hour span
tspan = [0 46]; % 9000s x longest path

% system initial condition, packed into y_0
In_0 = 0; 
Mid_0 = 0;
Out_0 = 0;
y_0 = [In_0; Mid_0; Out_0];

% cascade_dev = {{LmrA, TAL14}, {LmrA, TAL21}, {TAL14, LmrA}, {TAL14, TAL21}, {TAL21, LmrA}, {TAL21, TAL14}};
cascade_dev_2 = {LmrATAL14, LmrATAL21, TAL14LmrA, TAL14TAL21, TAL21LmrA, TAL21TAL14};
cascade_names = {'LmrA-TAL14', 'LmrA-TAL21', 'TAL14-LmrA', 'TAL14-TAL21', 'TAL21-LmrA', 'TAL21-TAL14'};
errset = zeros(6,1);
cascade_model = cell(6,1);
plasmid_count = 10.^(0:20);
meanerrset = zeros(2, 2, 2);

for alph = 1:1,
    for bet = 1:1,
        for gamm = 1:1,
            selected_TAL14 = TAL14{alph};
            selected_TAL21 = TAL21{bet};
            selected_LmrA = LmrA{gamm};
            cascade_dev = {{selected_LmrA, selected_TAL14}, {selected_LmrA, selected_TAL21}, {selected_TAL14, selected_LmrA}, {selected_TAL14, selected_TAL21}, {selected_TAL21, selected_LmrA}, {selected_TAL21, selected_TAL14}};
            for c=1:6,
                model_out = zeros(21,12);
                for i=1:21,     % plasmid copy counts
                    for j=1:12, % Dox levels
                        alpha_in = cascade_dev{c}{1}.in(i, j);
                        R1 = cascade_dev{c}{1}; R2 = cascade_dev{c}{2};
                        P = plasmid_count(i);
                        [T,Y] = ode15s(@hill_cascade_ODE_packed_simplified,tspan,y_0,[]);
                        model_out(i,j) = Y(end,3);
                    end
                    fprintf('.');
                end
                fprintf('\n');
                cascade_model{c} = model_out;
                c_out = cascade_dev_2{c}.geo_mefl.out;
                [MSE meanerr maxerr stderr] = fit_goodness([],c_out,[],model_out);
                err = 10^meanerr
                errset(c) = err;
            end
            mean(errset)
            meanerrset(alph, bet, gamm) = mean(errset);
        end
    end
end

for c=1:6,
    c_out = cascade_dev_2{c}.geo_mefl.out;
    c_in = cascade_dev_2{c}.geo_mefl.in;
    model_out = cascade_model{c};
    h=figure('PaperPosition',[1 1 6 4]);
    for i=1:21,
        loglog(c_in(i,:),c_out(i,:),'*-','Color',hsv2rgb([i/21 1 1])); hold on;
        loglog(cascade_dev{c}{1}.in(i,:),model_out(i,:),'--','Color',hsv2rgb([i/21 1 1]));
    end
    title(strcat('Cascade ', int2str(c), ': ', cascade_names(c)), 'FontSize', 20);
    xlabel('IFP MEFL'); ylabel('OFP MEFL');
    set(gca,'XScale','log'); set(gca,'YScale','log');
    xlim([1e4 3e8]); ylim([1e4 3e8]);
end
