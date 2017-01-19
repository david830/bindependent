% Load an inverter model:
% Changed for using structures instead, since the .mat files are long out of date
function [inverter, inducer] = device_to_bulk_model(results,prune_inactive)

% input (Blue) should be channel 1
if ~strcmp(results.Means{1,1}.name,'Pacific Blue-A'), error('Input not channel 1'); end;
inverter.input = results.Means{1,2};
% output (Yellow) should be channel 2
if ~strcmp(results.Means{3,1}.name,'FITC-A'), error('Input not channel 1'); end;
inverter.output = results.Means{3,2};
inverter.bincounts = results.BinCounts;

inducer_levels = getInducerLevelsToFiles(results.Experiment,1);
% replace zero inductions with 1/10 min induction, to prevent log failure
min_pos = min(inducer_levels(inducer_levels>0));
inducer_levels(inducer_levels==0) = min_pos/10;

AP = results.AnalysisParameters;
inducer.input = ones(get_n_bins(AP.bins),1)*inducer_levels;
inducer.output = inverter.input;
inducer.bincounts = results.BinCounts;

% Kludge plasmid counts:
linear_pc_est = get_bin_centers(AP.bins); % replace with MEFL bins
for i=1:size(inverter.input,2)
    inverter.plasmids(:,i) = linear_pc_est;
    inducer.plasmids(:,i) = linear_pc_est;
end

% Kludge to drop everything with CFP < 5e5 or > 1e8 (both suspect ranges)
lowtrim = 19; hightrim = 39;
if prune_inactive
    inducer.input = inducer.input(lowtrim:hightrim,:);
    inducer.output = inducer.output(lowtrim:hightrim,:);
    inducer.plasmids = inducer.plasmids(lowtrim:hightrim,:);
    inducer.bincounts = inducer.bincounts(lowtrim:hightrim,:);

    inverter.input = inverter.input(lowtrim:hightrim,:);
    inverter.output = inverter.output(lowtrim:hightrim,:);
    inverter.plasmids = inverter.plasmids(lowtrim:hightrim,:);
    inverter.bincounts = inverter.bincounts(lowtrim:hightrim,:);
end

% Kludge to drop Dox = 0.1 nm ... 2.0 nm (columns 2:6)
subset = [1 5:14]; % subset = [1 5:12 15]; % previously: [1 7:15]
inverter.input = inverter.input(:,subset);
inverter.output = inverter.output(:,subset);
inverter.plasmids = inverter.plasmids(:,subset);
inverter.bincounts = inverter.bincounts(:,subset);

inducer.input = inducer.input(:,subset);
inducer.output = inducer.output(:,subset);
inducer.plasmids = inducer.plasmids(:,subset);
inducer.bincounts = inducer.bincounts(:,subset);

end
