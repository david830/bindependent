load('device_data_set');
load('circuits');
load('circuit_predictions');

subset = [1 5 6];

% Get quality information
MSE = zeros(size(feed_forwards));
mean_err = zeros(size(feed_forwards));
max_err = zeros(size(feed_forwards));
std_err = zeros(size(feed_forwards));
minout = zeros(size(feed_forwards));
maxout = zeros(size(feed_forwards));
for i=subset,
    pred = ff_predictions{i};
    expt = feed_forwards{i};
    %which = safe_range{i}==1; % use only those where we were able to interpolate the whole way
    %which = pred.safe_range>=0; % use all predictions
    which = (pred.lower_extrapolations + pred.upper_extrapolations) <=9; % use predictions with less than 10% extrapolation
    [MSE(i) mean_err(i) max_err(i) std_err(i)] = fit_goodness([],expt.output(which),[],pred.output(which));
    minout(i) = min(expt.output(which));
    maxout(i) = max(expt.output(which));
    fprintf('Fold error for %s: MSE is %.2f, mean error is %.2f, max error is %.2f \n',expt.name,10^MSE(i),10^mean_err(i),10^max_err(i));
end

% Fold error for LmrA-TAL14 Feed-Forward: MSE is 1.12, mean error is 1.54, max error is 4.39 
% Fold error for TAL21-LmrA Feed-Forward: MSE is 2.21, mean error is 2.98, max error is 23.66 
% Fold error for TAL21-TAL14 Feed-Forward: MSE is 1.07, mean error is 1.42, max error is 2.49 
% Total mean error: 1.9800

for i=subset,
    expt = feed_forwards{i};
    fprintf('Error for %s: Mean = %.2f, mean+2std = %.2f, mean-2std = %.2f, max = %.2f \n',expt.name,...
        10^mean_err(i),10^(mean_err(i)+2*std_err(i)),10^(mean_err(i)-2*std_err(i)),10^max_err(i));
end
for i=subset,
    fprintf('Max/min for %s = %.2f \n',expt.name,maxout(i)/minout(i));
end

% Error for LmrA-TAL14 Feed-Forward: Mean = 1.54, mean+2std = 2.64, mean-2std = 0.90, max = 4.39 
% Error for TAL21-LmrA Feed-Forward: Mean = 2.98, mean+2std = 14.77, mean-2std = 0.60, max = 23.66 
% Error for TAL21-TAL14 Feed-Forward: Mean = 1.42, mean+2std = 2.15, mean-2std = 0.94, max = 2.49 
% Max/min for TAL21-TAL14 Feed-Forward = 380.45 
% Max/min for TAL21-TAL14 Feed-Forward = 333.01 
% Max/min for TAL21-TAL14 Feed-Forward = 289.54 


n = size(Dox_TAL14.plasmids,1);
hues = (1:n)./n;
step = 1;

for i=subset,
    pred = ff_predictions{i};
    expt = feed_forwards{i};
    which = (pred.lower_extrapolations + pred.upper_extrapolations) <=9; % use predictions with less than 10% extrapolation
    
    h = figure('PaperPosition',[1 1 6 4]);
    for j=1:step:n,
        if isempty(find(~isnan(expt.output(j,:)), 1)), continue; end; % skip all-NaN rows
        subwhich= which(j,:);
        % Observed
        loglog(expt.input(j,subwhich),expt.output(j,subwhich),'+-','Color',hsv2rgb([hues(j) 1 0.9])); hold on;
        % Prediction
        loglog(expt.inducer.output(j,subwhich),pred.output(j,subwhich),'o','Color',hsv2rgb([hues(j) 1 0.9]));
    end
    %title(['Predictions for ' feed_forwards{i}.name]);
    xlabel('Input MEFL'); ylabel('Output MEFL');
    set(gca,'XScale','log'); set(gca,'YScale','log');
    xlim([1e4 1e8]); ylim([1e4 1e7]);
%     set(gca,'YTick',[1e5 1e6 1e7 1e8]);
    outputfig(h,['PM-' feed_forwards{i}.file],'plots');
end

for i=subset,
    pred = ff_predictions{i};
    expt = feed_forwards{i};
    which = (pred.lower_extrapolations + pred.upper_extrapolations) <=9; % use predictions with less than 10% extrapolation
    
    h = figure('PaperPosition',[1 1 6 4]);
    for j=1:step:n,
        if isempty(find(~isnan(expt.output(j,:)), 1)), continue; end; % skip all-NaN rows
        subwhich= which(j,:);
        % Observed
        loglog(expt.input(j,:),expt.output(j,:),'+-','Color',[0.5 0.5 0.5]); hold on;
        loglog(expt.input(j,subwhich),expt.output(j,subwhich),'+-','Color',hsv2rgb([hues(j) 1 0.9])); hold on;
        % Prediction
        loglog(expt.inducer.output(j,subwhich),pred.output(j,subwhich),'o','Color',hsv2rgb([hues(j) 1 0.9]));
        loglog(expt.inducer.output(j,~subwhich),pred.output(j,~subwhich),'d','Color',[0.5 0.5 0.5]);
    end
    %title(['Predictions for ' feed_forwards{i}.name]);
    xlabel('Input MEFL'); ylabel('Output MEFL');
    set(gca,'XScale','log'); set(gca,'YScale','log');
    xlim([3e3 1e8]); ylim([3e3 1e7]);
%     set(gca,'YTick',[1e5 1e6 1e7 1e8]);
    outputfig(h,['PM-' feed_forwards{i}.file '-Details'],'plots');
end


range = [1e3 1e7];
for i=subset,
    pred = ff_predictions{i};
    expt = feed_forwards{i};
    which = (pred.lower_extrapolations + pred.upper_extrapolations) <=9; % use predictions with less than 10% extrapolation

    h = figure('PaperPosition',[1 1 5 5]);
    plot(range,range,'k-'); hold on;
    [errs err_l err_u] = geo_error_bars(expt.output(which),expt.stddev(which));
    means = expt.output(which);
    plot(pred.output(which),means,'bs');
    line([pred.output(which) pred.output(which)]',[means-err_l means+err_u]','Color','b')
    set(gca,'XScale','log'); set(gca,'YScale','log');
    xlim(range); ylim(range);
    xlabel('Predicted MEFL'); ylabel('Experimental MEFL');
    title('Predicted vs. Experimental Means');
    outputfig(h,['Prediction_Scatter_' feed_forwards{i}.file],'plots');
end


% % These will be used when we have the real thing...
% 
% generic_induction = Dox_TAL14;
% 
% resbins = get_bin_centers(getBins(getAnalysisParameters(results{1}.PlusResults)));
% bintop = find(resbins==generic_induction.plasmids(1,1),1);
% binbot = find(resbins==generic_induction.plasmids(end,1),1);
% reswhich = bintop:binbot;
% offset = 10; % I think the MEFLs are being converted wonky...
% reswhich = reswhich + offset;
% 
% align_results = cell(6,1);
% align_results{4} = results{1}; % TAL14-TAL21
% align_results{1} = results{2}; % LmrA-TAL14
% align_results{3} = results{3}; % TAL14-LmrA
% 
