% All use the same color model

stem1031 = '../../../2012-10-31-Triplicate_full_set/Controls/';
stem1106 = '../../../2012-11-06-LmrA-data/controls/';
stem1110 = '../../../2012-11-10-Last_set/Controls/';

load('../../controls/CMtriplicate.mat');

% Blue, Red, Yellow, RBY
% Set of controls
files = { ...
  {[stem1031 'EBFP2-1_H9_H09_P3.fcs'], [stem1031 'mkate-1_H8_H08_P3.fcs'], [stem1031 'EYFP-1_H10_H10_P3.fcs'], [stem1031 'RBY-1_H11_H11_P3.fcs']}, ...
  {[stem1031 'EBFP2-2_H9_H09_P3.fcs'], [stem1031 'mkate-2_H8_H08_P3.fcs'], [stem1031 'EYFP-2_H10_H10_P3.fcs'], [stem1031 'RBY-2_H11_H11_P3.fcs']}, ...
  {[stem1031 'EBFP2-3_H9_H09_P3.fcs'], [stem1031 'mkate-3_H8_H08_P3.fcs'], [stem1031 'EYFP-3_H10_H10_P3.fcs'], [stem1031 'RBY-3_H11_H11_P3.fcs']}, ...
  {[stem1106 'EBFP2-1_H9_H09_P3.fcs'], [stem1106 'mkate-1_H8_H08_P3.fcs'], [stem1106 'EYFP-1_H10_H10_P3.fcs'], [stem1106 'RBY-1_H11_H11_P3.fcs']}, ...
  {[stem1110 '2012-10-31_EBFP2_P3.fcs'], [stem1110 '2012-10-31_mkate_P3.fcs'], [stem1110 '2012-10-31_EYFP_P3.fcs'], [stem1110 '2012-10-31_RBY_P3.fcs']} ...
  };

names = {'10/31 #1', '10/31 #2', '10/31 #3', '11/06 #1', '11/10 #1'};

which_file = [1 2 3 4 4 4]; % blue, red, yellow, RBY(B), RBY(R), RBY(Y)
channels =   [1 2 3 1 2 3];
n_sets = numel(channels);
n_runs = numel(names);

MEFLPerPlasmid = 1000;
pem_drop_threshold = 5;

PEM = cell(n_sets,n_runs);
for i=1:n_sets,
    fprintf('Working on control %d, run',i);

    c_index = channels(i);
    CFP_af = get_autofluorescence_model(CM,c_index);
    CFP_noise_model = get_noise_model(CM);
    CFP_noise = CFP_noise_model.noisemin(c_index);

    for j=1:n_runs,
        fprintf(' %s...',names{j});
	sample = files{j}{which_file(i)};
    	data = readfcs_compensated_MEFL(CM,sample, false, true);
        PEM{i,j} = PlasmidExpressionModel(data(:,c_index),CFP_af,CFP_noise,MEFLPerPlasmid,CM,pem_drop_threshold);
    end
    fprintf('\n');
end


fractions = zeros(n_sets,n_runs);
activities = zeros(n_sets,n_runs);
std_activities = zeros(n_sets,n_runs);
for i=1:n_sets,
    for j=1:n_runs,
    	dist = get_active_component(PEM{i,j});
        fractions(i,j) = dist.weight;
        activities(i,j) = dist.mu;
        std_activities(i,j) = sqrt(dist.Sigma);
    end
end

cname = {'Blue','Red','Yellow'};
for i=1:numel(cname),
    h = figure('PaperPosition',[1 1 5 3.66]);
    meanset = activities(i+[0 3],:);
    stdset = std_activities(i+[0 3],:);
    errorbar(1:5,meanset(1,:),stdset(1,:),'*'); hold on;
    errorbar(0.1+(1:5),meanset(2,:),stdset(2,:),'*');
    xlabel('Control Set'); ylabel('log10(CFP MEFL)');
    title(sprintf('%s expression level',cname{i}));
    set(gca,'XTick',1:5);
    set(gca,'XTickLabel',names);
    outputfig(h,sprintf('%s-expression-levels',cname{i}));
end

save('ExpressionCalibration.mat','files','channels','which_file','names','MEFLPerPlasmid',...
     'PEM','fractions','activities','std_activities');
