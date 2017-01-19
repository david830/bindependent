% All use the same color model

stem1031 = '../../../2012-10-31-Triplicate_full_set/';
stem1106 = '../../../2012-11-06-LmrA-data/';
stem1110 = '../../../2012-11-10-Last_set/';

names = {'LmrA','TAL14','TAL21','LmrA-TAL14','LmrA-TAL21','TAL14-LmrA','TAL14-TAL21','TAL21-LmrA','TAL21-TAL14'};

load('../../controls/CMtriplicate.mat');

% Blue, Red, Yellow, RBY
% Set of controls
high_files = { ...
  {[stem1106 'LmrA/LmrA-1_B3_B03_P3.fcs'],  [stem1106 'LmrA/LmrA-2_E12_E12_P3.fcs'],  [stem1106 'LmrA/LmrA-3_B3_B03_P3.fcs']}, ... % devices
  {[stem1031 'TAL14/TAL14-1_C6_C06_P3.fcs'],  [stem1031 'TAL14/TAL14-2_B3_B03_P3.fcs'], [stem1110 'TAL14/TAL14_B3_B03_P3.fcs']}, ...
  {[stem1031 'TAL21/TAL21-1_D9_D09_P3.fcs'], [stem1031 'TAL21/TAL21-2_C4_C04_P3.fcs']}, ... % using dox 500 for 2nd point
  {[stem1031 'LmrA-TAL14/LmrA-TAL14-1_D9_D09_P3.fcs'],  [stem1110 'LmrA-TAL14/LmrA-TAL14-1_G3_G03_P3.fcs'],  [stem1110 'LmrA-TAL14/LmrA-TAL14-2_H6_H06_P3.fcs']}, ... % cascades
  {[stem1031 'LmrA-TAL21/LmrA-TAL21-1_B3_B03_P3.fcs'],  [stem1031 'LmrA-TAL21/LmrA-TAL21-2_E12_E12_P3.fcs'], [stem1110 'LmrA-TAL21/LmrA-TAL21_D9_D09_P3.fcs']}, ...
  {[stem1106 'TAL14-LmrA/TAL14-LmrA-1_C6_C06_P3.fcs'],  [stem1106 'TAL14-LmrA/TAL14-LmrA-2_G3_G03_P3.fcs'],  [stem1106 'TAL14-LmrA/TAL14-LmrA-3_C6_C06_P3.fcs']}, ...
  {[stem1031 'TAL14-TAL21/TAL14-TAL21-1_E12_E12_P3.fcs'], [stem1031 'TAL14-TAL21/TAL14-TAL21-2_D9_D09_P3.fcs'],  [stem1110 'TAL14-TAL21/TAL14-TAL21_B3_B03_P3.fcs']}, ...
  {[stem1106 'TAL21-LmrA/TAL21-LmrA-1_D9_D09_P3.fcs'],  [stem1106 'TAL21-LmrA/TAL21-LmrA-2_H6_H06_P3.fcs'],  [stem1110 'TAL21-LmrA/TAl21-LmrA_E12_E12_P3.fcs']}, ...
  {[stem1031 'TAL21-TAL14/TAL21-TAL14-1_G3_G03_P3.fcs'],  [stem1031 'TAL21-TAL14/TAL21-TAL14-2_E12_E12_P3.fcs'], [stem1110 'TAL21-TAL14/TAL21-TAL14_C6_C06_P3.fcs']}, ...
  };

n_runs = numel(names);

c_index = find(CM,channel_named(CM, 'Red')); % Determine data column from ColorModel
i_index = find(CM,channel_named(CM, 'Blue')); % Determine data column from ColorModel
o_index = find(CM,channel_named(CM, 'Yellow')); % Determine data column from ColorModel

CFP_af = get_autofluorescence_model(CM,c_index);
CFP_noise_model = get_noise_model(CM);
CFP_noise = CFP_noise_model.noisemin(c_index);
MEFLPerPlasmid = 1000;
pem_drop_threshold = 5;

PEM = cell(n_runs,1);
expressions = cell(n_runs,1);
for i=1:n_runs,
    fprintf('Analyzing levels for %s',names{i});

    n_reps = numel(high_files{i});
    PEM{i} = cell(n_reps,1);
    expressions{i} = zeros(n_reps,1);
    for j=1:n_reps,
        fprintf('.');
    	sample = high_files{i}{j};
    	data = readfcs_compensated_MEFL(CM,sample, false, true);
        PEM{i}{j} = PlasmidExpressionModel(data(:,c_index),CFP_af,CFP_noise,MEFLPerPlasmid,CM,pem_drop_threshold);
        
        active_thresh = 1e4;
        while(estimate_fraction_active(PEM{i}{j},active_thresh)<0.5), active_thresh = active_thresh * 1.1; end;
        
        which = data(:,c_index)>active_thresh;
        expressions{i}(j) = geomean(data(which,i_index));
    end
    fprintf('\n');
end

IFP_means = zeros(n_runs,1);
CFP_means = zeros(n_runs,1);
for i=1:n_runs,
    IFP_means(i) = geomean(expressions{i});

    n_reps = numel(high_files{i});
    mu = zeros(n_reps,1);
    for j=1:n_reps, 
        tmp_PEM = get_active_component(PEM{i}{j});
        mu(j) = tmp_PEM.mu;
    end;
    CFP_means(i) = 10.^mean(mu);
end
relative_IFP = IFP_means/1e7;
relative_CFP = CFP_means/5e6;

%%%%%%%%% 
% Now we'll do the same thing with OFP, using the low active expression part of the zero-dox files

low_files = { ...
  {[stem1106 'LmrA/LmrA-1_A1_A01_P3.fcs'],  [stem1106 'LmrA/LmrA-2_D10_D10_P3.fcs'], [stem1106 'LmrA/LmrA-3_A1_A01_P3.fcs']}, ... % devices
  {[stem1031 'TAL14/TAL14-1_B4_B04_P3.fcs'],  [stem1031 'TAL14/TAL14-2_A1_A01_P3.fcs'],[stem1110 'TAL14/TAL14_A1_A01_P3.fcs']}, ...
  {[stem1031 'TAL21/TAL21-1_C7_C07_P3.fcs'], [stem1031 'TAL21/TAL21-2_B6_B06_P3.fcs']}, ... % using dox 0.2 for 2nd data point
  {[stem1031 'LmrA-TAL14/LmrA-TAL14-1_C7_C07_P3.fcs'],  [stem1110 'LmrA-TAL14/LmrA-TAL14-1_F1_F01_P3.fcs'],  [stem1110 'LmrA-TAL14/LmrA-TAL14-2_G4_G04_P3.fcs']}, ... % cascades
  {[stem1031 'LmrA-TAL21/LmrA-TAL21-1_A1_A01_P3.fcs'],  [stem1031 'LmrA-TAL21/LmrA-TAL21-2_D10_D10_P3.fcs'], [stem1110 'LmrA-TAL21/LmrA-TAL21_C7_C07_P3.fcs']}, ...
  {[stem1106 'TAL14-LmrA/TAL14-LmrA-1_B4_B04_P3.fcs'],  [stem1106 'TAL14-LmrA/TAL14-LmrA-2_F1_F01_P3.fcs'],  [stem1106 'TAL14-LmrA/TAL14-LmrA-3_B4_B04_P3.fcs']}, ...
  {[stem1031 'TAL14-TAL21/TAL14-TAL21-1_D10_D10_P3.fcs'], [stem1110 'TAL14-TAL21/TAL14-TAL21_A1_A01_P3.fcs']}, ...
  {[stem1106 'TAL21-LmrA/TAL21-LmrA-1_C7_C07_P3.fcs'],  [stem1106 'TAL21-LmrA/TAL21-LmrA-3_C7_C07_P3.fcs'],  [stem1110 'TAL21-LmrA/TAl21-LmrA_D10_D10_P3.fcs']}, ...
  {[stem1031 'TAL21-TAL14/TAL21-TAL14-1_F1_F01_P3.fcs'],  [stem1031 'TAL21-TAL14/TAL21-TAL14-2_D10_D10_P3.fcs'], [stem1110 'TAL21-TAL14/TAL21-TAL14_B4_B04_P3.fcs']}, ...
  };

PEMlow = cell(n_runs,1);
low_expressions = cell(n_runs,1);
for i=1:n_runs,
    fprintf('Analyzing levels for %s',names{i});

    n_reps = numel(low_files{i});
    PEMlow{i} = cell(n_reps,1);
    low_expressions{i} = zeros(n_reps,1);
    for j=1:n_reps,
        fprintf('.');
    	sample = low_files{i}{j};
    	data = readfcs_compensated_MEFL(CM,sample, false, true);
        PEMlow{i}{j} = PlasmidExpressionModel(data(:,c_index),CFP_af,CFP_noise,MEFLPerPlasmid,CM,pem_drop_threshold);

        active_thresh = 1e4;
        while(estimate_fraction_active(PEMlow{i}{j},active_thresh)<0.5), active_thresh = active_thresh * 1.1; end;
        
        tmp_PEM = get_active_component(PEMlow{i}{j});
        %which = data(:,c_index)>active_thresh & data(:,c_index)<10.^tmp_PEM.mu;
        which = data(:,c_index)>5e5 & data(:,c_index)<5e6;
        %which = data(:,c_index)>active_thresh;
        low_expressions{i}(j) = geomean(data(which,o_index));
    end
    fprintf('\n');
end

OFP_means = zeros(n_runs,1);
for i=1:n_runs,
    OFP_means(i) = geomean(low_expressions{i});
end
relative_OFP = OFP_means/5e5;

save('ExpressionCalibration.mat','high_files','low_files','names','MEFLPerPlasmid', ...
     'PEM','PEMlow','expressions','low_expressions', ...
     'IFP_means','relative_IFP','CFP_means','relative_CFP','OFP_means','relative_OFP');
