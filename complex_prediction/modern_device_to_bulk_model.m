% Load an inverter model:
% Changed for using structures instead, since the .mat files are long out of date
function [inverter inducer] = modern_device_to_bulk_model(results,prune_inactive,binrange)

% input (Blue) should be channel 1
inverter.input = get_channel_results(results,'input');
[inverter.output tmp inverter.stddev] = get_channel_results(results,'output');
inverter.bincounts = getBinCounts(results);

experiment = getExperiment(results);
inducer_levels = getInducerLevelsToFiles(experiment,1);
% replace zero inductions with 1/10 min induction, to prevent log failure
min_pos = min(inducer_levels(inducer_levels>0));
inducer_levels(inducer_levels==0) = min_pos/10;

AP = getAnalysisParameters(results);
inducer.input = ones(get_n_bins(getBins(AP)),1)*inducer_levels;
inducer.output = inverter.input;
inducer.bincounts = getBinCounts(results);

% Kludge plasmid counts:
linear_pc_est = get_bin_centers(getBins(AP)); % replace with MEFL bins
for i=1:size(inverter.input,2)
    inverter.plasmids(:,i) = linear_pc_est;
    inducer.plasmids(:,i) = linear_pc_est;
end

lowtrim = 19; hightrim = 39;

% kludge to cut the saturated data:
for i=(binrange(2)+1):hightrim
    inverter.input(i,:) = NaN;
    inverter.output(i,:) = NaN;
    inverter.stddev(i,:) = NaN;
end

% Kludge to drop everything with CFP < 5e5 or > 1e8 (both suspect ranges)
if prune_inactive
    inducer.input = inducer.input(lowtrim:hightrim,:);
    inducer.output = inducer.output(lowtrim:hightrim,:);
    inducer.plasmids = inducer.plasmids(lowtrim:hightrim,:);
    inducer.bincounts = inducer.bincounts(lowtrim:hightrim,:);

    inverter.input = inverter.input(lowtrim:hightrim,:);
    inverter.output = inverter.output(lowtrim:hightrim,:);
    inverter.stddev = inverter.stddev(lowtrim:hightrim,:);
    inverter.plasmids = inverter.plasmids(lowtrim:hightrim,:);
    inverter.bincounts = inverter.bincounts(lowtrim:hightrim,:);
end


% Don't need to drop, because these were taken without the lowest Dox levels


% compensate for color model & Dox expression differences between Noah & Samira:


% New color model:
%        NaN    0.9616    1.1908
%     1.0366       NaN    1.2913
%     0.8362    0.7728       NaN

% Old color model:
%       NaN    2.6927    1.9910
%     0.3675       NaN    0.6952
%     0.5013    1.4314       NaN

% Red to yellow = 1.0366 vs. 0.3675
% Blue to yellow = 0.8362 vs. 0.5013

% Kludge to match CFP levels:
CFP_correction = 0.3545;
inverter.plasmids = inverter.plasmids * CFP_correction;
inducer.plasmids = inducer.plasmids * CFP_correction; 


% kludge to match IFP levels:
IFP_correction = 0.5995 * 11.1126; % color correction vs. expression correction
inverter.input = inverter.input * IFP_correction; 
inducer.output = inducer.output * IFP_correction; 

% New geomeans: 8.1028e+05, 9.0728e+05, 1.2459e+06 --> geommean = 9.7115e+05
% Old geomean: 1.0792e+07 (LmrA)


end
