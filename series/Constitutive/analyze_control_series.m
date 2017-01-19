% All use the same color model

stem1107 = '../../../2012-11-07-Time_series_x2/Time_data/';

load('../../controls/CMtriplicate.mat');

times = [12 16 18 20 22 24 26 28 30 42 48 58 60 63 69 72];

% Set of controls
files = { ...
  {{'T12-1_H9_H09_P3.fcs', 'T12-1_H10_H10_P3.fcs',[], [], [], [], []}, ...
   {'T12-2_H11_H11_P3.fcs','T12-2_H12_H12_P3.fcs',[], [], [], [], []}}, ...
  {{'T16-1_A1_A01_P3.fcs', 'T16-1_A2_A02_P3.fcs', 'T16-1_A3_A03_P3.fcs', 'T16-1_A4_A04_P3.fcs', 'T16-1_A5_A05_P3.fcs', 'T16-1_A6_A06_P3.fcs', 'T16-1_A7_A07_P3.fcs'}, ...
   {'T16-2_D1_D01_P3.fcs', 'T16-2_D2_D02_P3.fcs', 'T16-2_D3_D03_P3.fcs', 'T16-2_D4_D04_P3.fcs', 'T16-2_D5_D05_P3.fcs', 'T16-2_D6_D06_P3.fcs', 'T16-2_D7_D07_P3.fcs'}}, ...
  {{'T18-1_A8_A08_P3.fcs', 'T18-1_A9_A09_P3.fcs', 'T18-1_A10_A10_P3.fcs','T18-1_A11_A11_P3.fcs','T18-1_A12_A12_P3.fcs','T18-1_B1_B01_P3.fcs', 'T18-1_B2_B02_P3.fcs'}, ...
   {'T18-2_D8_D08_P3.fcs', 'T18-2_D9_D09_P3.fcs', 'T18-2_D10_D10_P3.fcs','T18-2_D11_D11_P3.fcs','T18-2_D12_D12_P3.fcs','T18-2_E1_E01_P3.fcs', 'T18-2_E2_E02_P3.fcs'}}, ...
  {{'T20-1_B3_B03_P3.fcs', 'T20-1_B4_B04_P3.fcs', 'T20-1_B5_B05_P3.fcs', 'T20-1_B6_B06_P3.fcs', 'T20-1_B7_B07_P3.fcs', 'T20-1_B8_B08_P3.fcs', 'T20-1_B9_B09_P3.fcs'}, ...
   {'T20-2_E3_E03_P3.fcs', 'T20-2_E4_E04_P3.fcs', 'T20-2_E5_E05_P3.fcs', 'T20-2_E6_E06_P3.fcs', 'T20-2_E7_E07_P3.fcs', 'T20-2_E8_E08_P3.fcs', 'T20-2_E9_E09_P3.fcs'}}, ...
  {{'T22-1_B10_B10_P3.fcs','T22-1_B11_B11_P3.fcs','T22-1_B12_B12_P3.fcs','T22-1_C1_C01_P3.fcs', 'T22-1_C2_C02_P3.fcs', 'T22-1_C3_C03_P3.fcs', 'T22-1_C4_C04_P3.fcs'}, ...
   {'T22-2_E10_E10_P3.fcs','T22-2_E11_E11_P3.fcs','T22-2_E12_E12_P3.fcs','T22-2_F1_F01_P3.fcs', 'T22-2_F2_F02_P3.fcs', 'T22-2_F3_F03_P3.fcs', 'T22-2_F4_F04_P3.fcs'}}, ...
  {{'T24-1_A1_A01_P3.fcs', 'T24-1_A2_A02_P3.fcs', 'T24-1_A3_A03_P3.fcs', 'T24-1_A4_A04_P3.fcs', 'T24-1_A5_A05_P3.fcs', 'T24-1_A6_A06_P3.fcs', 'T24-1_A7_A07_P3.fcs'}, ...
   {'T24-2_C1_C01_P3.fcs', 'T24-2_C2_C02_P3.fcs', 'T24-2_C3_C03_P3.fcs', 'T24-2_C4_C04_P3.fcs', 'T24-2_C5_C05_P3.fcs', 'T24-2_C6_C06_P3.fcs', 'T24-2_C7_C07_P3.fcs'}}, ...
  {{'T26-1_A1_A01_P3.fcs', 'T26-1_A2_A02_P3.fcs', 'T26-1_A3_A03_P3.fcs', 'T26-1_A4_A04_P3.fcs', 'T26-1_A5_A05_P3.fcs', 'T26-1_A6_A06_P3.fcs', 'T26-1_A7_A07_P3.fcs'}, ...
   {'T26-2_D7_D07_P3.fcs', 'T26-2_D8_D08_P3.fcs', 'T26-2_D9_D09_P3.fcs', 'T26-2_D10_D10_P3.fcs','T26-2_D11_D11_P3.fcs','T26-2_D12_D12_P3.fcs','T26-2_E1_E01_P3.fcs'}}, ...
  {{'T28-1_A8_A08_P3.fcs', 'T28-1_A9_A09_P3.fcs', 'T28-1_A10_A10_P3.fcs','T28-1_A11_A11_P3.fcs','T28-1_A12_A12_P3.fcs','T28-1_B1_B01_P3.fcs', 'T28-1_B2_B02_P3.fcs'}, ...
   {'T28-2_E2_E02_P3.fcs', 'T28-2_E3_E03_P3.fcs', 'T28-2_E4_E04_P3.fcs', 'T28-2_E5_E05_P3.fcs', 'T28-2_E6_E06_P3.fcs', 'T28-2_E7_E07_P3.fcs', 'T28-2_E8_E08_P3.fcs'}}, ...
  {{'T30-1_B3_B03_P3.fcs', 'T30-1_B4_B04_P3.fcs', 'T30-1_B5_B05_P3.fcs', 'T30-1_B6_B06_P3.fcs', 'T30-1_B7_B07_P3.fcs', 'T30-1_B8_B08_P3.fcs', 'T30-1_B9_B09_P3.fcs'}, ...
   {'T30-2_E9_E09_P3.fcs', 'T30-2_E10_E10_P3.fcs','T30-2_E11_E11_P3.fcs','T30-2_E12_E12_P3.fcs','T30-2_F1_F01_P3.fcs', 'T30-2_F2_F02_P3.fcs', 'T30-2_F3_F03_P3.fcs'}}, ...
  {{'T42-1_A8_A08_P3.fcs', 'T42-1_A9_A09_P3.fcs', 'T42-1_A10_A10_P3.fcs','T42-1_A11_A11_P3.fcs','T42-1_A12_A12_P3.fcs','T42-1_B1_B01_P3.fcs', 'T42-1_B2_B02_P3.fcs'}, ...
   {'T42-2_C8_C08_P3.fcs', 'T42-2_C9_C09_P3.fcs', 'T42-2_C10_C10_P3.fcs','T42-2_C11_C11_P3.fcs','T42-2_C12_C12_P3.fcs','T42-2_D1_D01_P3.fcs', 'T42-2_D2_D02_P3.fcs'}}, ...
  {{'T48-1_B10_B10_P3.fcs','T48-1_B11_B11_P3.fcs','T48-1_B12_B12_P3.fcs','T48-1_C1_C01_P3.fcs', 'T48-1_C2_C02_P3.fcs', 'T48-1_C3_C03_P3.fcs', 'T48-1_C4_C04_P3.fcs'}, ...
   {'T48-2_F4_F04_P3.fcs', 'T48-2_F5_F05_P3.fcs', 'T48-2_F6_F06_P3.fcs', 'T48-2_F7_F07_P3.fcs', 'T48-2_F8_F08_P3.fcs', 'T48-2_F9_F09_P3.fcs', 'T48-2_F10_F10_P3.fcs'}}, ...
  {{[],'../T58/T58-1_Dox_P3.fcs','../T58/Controls-T58-1_A5_A05_P3.fcs','../T58/Controls-T58-1_A6_A06_P3.fcs','../T58/Controls-T58-1_A7_A07_P3.fcs','../T58/Controls-T58-1_A8_A08_P3.fcs','../T58/Controls-T58-1_A9_A09_P3.fcs'}, ...
   {'../T58/T58-2_No_Dox_P3.fcs','../T58/T58-2_Dox_P3.fcs','../T58/Controls-T58-2_B5_B05_P3.fcs','../T58/Controls-T58-2_B6_B06_P3.fcs','../T58/Controls-T58-2_B7_B07_P3.fcs','../T58/Controls-T58-2_B8_B08_P3.fcs','../T58/Controls-T58-2_B9_B09_P3.fcs'}}, ...
  {{'T60-1_C5_C05_P3.fcs', 'T60-1_C6_C06_P3.fcs', 'T60-1_C7_C07_P3.fcs', 'T60-1_C8_C08_P3.fcs', 'T60-1_C9_C09_P3.fcs', 'T60-1_C10_C10_P3.fcs','T60-1_C11_C11_P3.fcs'}, ...
   {'T60-2_F5_F05_P3.fcs', 'T60-2_F6_F06_P3.fcs', 'T60-2_F7_F07_P3.fcs', 'T60-2_F8_F08_P3.fcs', 'T60-2_F9_F09_P3.fcs', 'T60-2_F10_F10_P3.fcs','T60-2_F11_F11_P3.fcs'}}, ...
  {{'T63-1_B3_B03_P3.fcs', 'T63-1_B4_B04_P3.fcs', 'T63-1_B5_B05_P3.fcs', 'T63-1_B6_B06_P3.fcs', 'T63-1_B7_B07_P3.fcs', 'T63-1_B8_B08_P3.fcs', 'T63-1_B9_B09_P3.fcs'}, ...
   {'T63-2_D3_D03_P3.fcs', 'T63-2_D4_D04_P3.fcs', 'T63-2_D5_D05_P3.fcs', 'T63-2_D6_D06_P3.fcs', 'T63-2_D7_D07_P3.fcs', 'T63-2_D8_D08_P3.fcs', 'T63-2_D9_D09_P3.fcs'}}, ...
  {{'T69-1_C5_C05_P3.fcs', 'T69-1_C6_C06_P3.fcs', 'T69-1_C7_C07_P3.fcs', 'T69-1_C8_C08_P3.fcs', 'T69-1_C9_C09_P3.fcs', 'T69-1_C10_C10_P3.fcs','T69-1_C11_C11_P3.fcs'}, ...
   {'T69-2_F11_F11_P3.fcs','T69-2_F12_F12_P3.fcs','T69-2_G1_G01_P3.fcs', 'T69-2_G2_G02_P3.fcs', 'T69-2_G3_G03_P3.fcs', 'T69-2_G4_G04_P3.fcs', 'T69-2_G5_G05_P3.fcs'}}, ...
  {{'T72-1_C12_C12_P3.fcs','T72-1_D1_D01_P3.fcs', 'T72-1_D2_D02_P3.fcs', 'T72-1_D3_D03_P3.fcs', 'T72-1_D4_D04_P3.fcs', 'T72-1_D5_D05_P3.fcs', 'T72-1_D6_D06_P3.fcs'}, ...
   {'T72-2_G6_G06_P3.fcs', 'T72-2_G7_G07_P3.fcs', 'T72-2_G8_G08_P3.fcs', 'T72-2_G9_G09_P3.fcs', 'T72-2_G10_G10_P3.fcs','T72-2_G11_G11_P3.fcs','T72-2_G12_G12_P3.fcs'}} ...
  };

which_file = [1 2 3 4 5 6 6 6]; % dox=0, dox=1, red, blue, yellow, RBY(B), RBY(R), RBY(Y)
channels =   [2 2 2 1 3 1 2 3];
n_sets = numel(channels);
n_times = numel(times);

MEFLPerPlasmid = 1000;
pem_drop_threshold = 5;

PEM = cell(n_sets,n_times);
for i=1:n_sets,
    fprintf('Working on control %d, time =',i);

    c_index = channels(i);
    CFP_af = get_autofluorescence_model(CM,c_index);
    CFP_noise_model = get_noise_model(CM);
    CFP_noise = CFP_noise_model.noisemin(c_index);

    for j=1:n_times,
        fprintf(' %d',times(j));
        samples = cell(0);
        for k=1:numel(files{j}),
            sample = files{j}{k}{which_file(i)};
            if ~isempty(sample), samples{numel(samples)+1} = sample; end;
        end
        
        for k=1:numel(samples),
    	    data = readfcs_compensated_MEFL(CM,[stem1107 samples{k}], false, true);
            PEM{i,j}{k} = PlasmidExpressionModel(data(:,c_index),CFP_af,CFP_noise,MEFLPerPlasmid,CM,pem_drop_threshold);
            fprintf('.');
        end
    end
    fprintf('\n');
end

sample_times = cell(n_sets,1);
sample_fractions = cell(n_sets,1);
sample_activities = cell(n_sets,1);
mean_fractions = zeros(n_sets,n_times);
mean_activities = zeros(n_sets,n_times);

for i=1:n_sets,
    sample_fractions{i} = [];
    sample_activities{i} = [];
    sample_times{i} = [];
    idx = 0;
    for j=1:n_times,
        n = numel(PEM{i,j});
        if(n>0)
            dists = cell(0);
            for k=1:n, dists{k} = get_active_component(PEM{i,j}{k}); end;
            dists=[dists{:}];
            sample_times{i}(idx+(1:n)) = times(j);
            sample_fractions{i}(idx+(1:n)) = [dists(:).weight];
            mean_fractions(i,j) = mean([dists(:).weight]);
            sample_activities{i}(idx+(1:n)) = 10.^[dists(:).mu];
            mean_activities(i,j) = mean(10.^[dists(:).mu]);
            idx = idx+n;
        end
    end
end

colors = 'kkrbycmg';
h = figure('PaperPosition',[1 1 5 3.66]);
for i=1:n_sets
    plot(sample_times{i},sample_fractions{i},['*' colors(i)]); hold on;
    plot(times,mean_fractions(i,:),['-' colors(i)]);
end
xlabel('Time (hours)');  ylabel('Fraction Active');
xlim([0 75]); ylim([0 1]);
title('Constitutive fraction active vs time');
outputfig(h,'Const-fraction-active');

h = figure('PaperPosition',[1 1 5 3.66]);
for i=1:n_sets
    plot(sample_times{i},sample_activities{i},['*' colors(i)]); hold on;
    plot(times,mean_activities(i,:),['-' colors(i)]);
end
xlabel('Time (hours)');  ylabel('OFP MEFL');
xlim([0 75]);
title('Constitutive active population mean MEFL vs time');
outputfig(h,'Const-population-mean');
set(gca,'YScale','log');
outputfig(h,'Const-population-mean-log');

consensus_mean_fraction = zeros(n_times,1);
consensus_std_fraction = zeros(n_times,1);
consensus_mean_activity = zeros(n_times,1);
consensus_std_activity = zeros(n_times,1);
for i=1:n_times
    which = [sample_times{:}]==times(i);
    fractions = [sample_fractions{:}];
    consensus_mean_fraction(i) = mean(fractions(which));
    consensus_std_fraction(i) = std(fractions(which));
    activities = [sample_activities{:}];
    consensus_mean_activity(i) = geomean(activities(which));
    consensus_std_activity(i) = geostd(activities(which));
end

h = figure('PaperPosition',[1 1 5 3.66]);
%for i=1:n_sets
%    plot(sample_times{i},sample_fractions{i},'*'); hold on;
%end
plot(times,consensus_mean_fraction,'k*-'); hold on;
plot(times,consensus_mean_fraction+2*consensus_std_fraction,'k:');
plot(times,consensus_mean_fraction-2*consensus_std_fraction,'k:');
xlabel('Time (hours)');  ylabel('Fraction Active');
xlim([0 75]); ylim([0 1]);
title('Constitutive fraction active vs time');
outputfig(h,'Const-fraction-active-consensus');

h = figure('PaperPosition',[1 1 5 3.66]);
for i=1:n_sets
    plot(sample_times{i},sample_activities{i},'*'); hold on;
end
plot(times,consensus_mean_activity,'r-'); hold on;
plot(times,consensus_mean_activity.*(2*consensus_std_activity),'r--');
plot(times,consensus_mean_activity./(2*consensus_std_activity),'r--');
xlabel('Time (hours)');  ylabel('OFP MEFL');
xlim([0 75]);
title('Constitutive active population mean MEFL vs time');
outputfig(h,'Const-population-mean-consensus');
set(gca,'YScale','log');
outputfig(h,'Const-population-mean-log-consensus');


save('ControlSeries.mat','files','channels','which_file','times','MEFLPerPlasmid',...
    'PEM','sample_times','sample_fractions','sample_activities','mean_fractions','mean_activities', ...
    'consensus_mean_activity','consensus_std_activity','consensus_mean_fraction','consensus_std_fraction');

%%% Find the expression model:
addpath('..');
s_levels = [sample_activities{:}];
s_times = [sample_times{:}];
s_fractions = [sample_fractions{:}];
samples = [s_times' s_levels' s_fractions'];

fn = @(params)(expression_error(params(1),params(2),params(3),params(4),samples));
expression_fit = fminsearch(fn,[18 12 1e6 0.7]);
% ans = [37.9 7.3 3.0e5 0.67]
div_time = expression_fit(1);
shock_time = expression_fit(2);
mean_divisions = (72-shock_time-(div_time/2))/div_time
% ans = 1.21 --> now 1.20

[model_levels model_acts] = expression_model(expression_fit(1), expression_fit(2), expression_fit(3), expression_fit(4), 72, 0.1);

h = figure('PaperPosition',[1 1 5 3.66]);
for i=1:n_sets
    plot(sample_times{i},sample_activities{i},'*'); hold on;
end
plot(times,consensus_mean_activity,'-'); hold on;
plot(0:0.1:72,model_levels,'r-');
xlabel('Time (hours)');  ylabel('OFP MEFL');
xlim([0 75]); ylim([1e5 1.5e7]);
title('Expression Model');
outputfig(h,'Const-population-mean-model');
set(gca,'YScale','log'); ylim([1e5 1e8]);
outputfig(h,'Const-population-mean-model-log-consensus');

h = figure('PaperPosition',[1 1 5 3.66]);
for i=1:n_sets
    plot(sample_times{i},sample_fractions{i},'*'); hold on;
end
plot(times,consensus_mean_fraction,'-'); hold on;
plot(0:0.1:72,model_acts,'r-');
xlabel('Time (hours)');  ylabel('OFP MEFL');
xlim([0 75]);
title('Activation Model');
outputfig(h,'Const-fraction-active-model');


% PEM = cell(n_sets,numel(dirs));
% MEFLPerPlasmid = 1000;
% bins = BinSequence(4,0.1,10,'log_bins');
% for i=1:6, % there are 6 sets of files
%     fprintf('Working on control %d, time = ',i);
%     for j=1:numel(dirs),
%         fprintf('%d...',times(j));
%         fileName = sprintf('%s/%s',dirs{j},files{j}{i});
%         c_index = channels(i);
%         data = readfcs_compensated_MEFL(CM,fileName, false, true);
%         [counts means stds] = subpopulation_statistics(bins, data(:,c_index), 1, 'geometric');
%         % Compute plasmid model
%         CFP_af = CM.autofluorescence_model{c_index};
%         CFP_noise = CM.noise_model.noisemin(c_index);
%         PEM{i,j} = PlasmidExpressionModel(data(:,c_index),CFP_af,CFP_noise,MEFLPerPlasmid,CM,7);
%     end
%     fprintf('\n');
% end
% save('ControlSeries.mat','dirs','files','channels','bins','MEFLPerPlasmid','PEM');
