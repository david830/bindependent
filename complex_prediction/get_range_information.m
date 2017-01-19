% get range information:
% WARNING: this is a total kludge aimed specifically at getting error bar
% data for the prediction paper

load('circuits');
load('circuit_predictions');

% need to pull from sample_results
% get output channel, which is Yellow, which is #3
% sampleresults{1}{1}.Means(:,3)

mins = ones(6,2)*1e10;
maxes = zeros(6,2);

% subset of data that will be used
lowtrim = 19; hightrim = 39;

stem = 'circuit_data/';

for i=1:numel(feed_forwards),
    if isempty(feed_forwards{i}), continue; end;
    load([stem feed_forwards{i}.file '-Fine.mat']);
    which = (ff_predictions{i}.lower_extrapolations + ff_predictions{i}.upper_extrapolations) <=9; % use predictions with less than 10% extrapolation
    
    for j=1:2,
        for k=1:12 % number of Dox levels
            ref = j;
            if ref>numel(sampleresults{k}), continue; end;
            column = sampleresults{k}{ref}.Means(lowtrim:hightrim,1);
            sampleset = column(which(:,k));
            sampleset = sampleset(~isnan(sampleset));
            if(numel(sampleset))
                mins(i,j) = min(mins(i,j),min(sampleset));
                maxes(i,j) = max(maxes(i,j),max(sampleset));
            end
        end
    end
end

% maxes./mins
% 275.8455  168.6813  185.4520
% 84.5361   60.3977  119.9332
% 163.2772  220.9985  173.5080
% 334.8188  362.9392  135.1957
% 495.9328  480.8344  223.6482
% 369.1630  559.1191  285.3875

foldrange = mean(maxes./mins,2);
foldstd = 10.^std(log10(maxes./mins),0,2);

for i=1:numel(feed_forwards),
    if isempty(feed_forwards{i}), continue; end;
    fprintf('Max/min for %s: mean = %.2f, mean+2std = %.2f, mean-2std = %.2f \n',feed_forwards{i}.name,foldrange(i),...
        foldrange(i)*(foldstd(i)^2),foldrange(i)/(foldstd(i)^2));
end

% Max/min for LmrA-TAL14 Feed-Forward: mean = 383.15, mean+2std = 536.68, mean-2std = 273.55 
% Max/min for TAL21-LmrA Feed-Forward: mean = 333.13, mean+2std = 358.73, mean-2std = 309.35 
% Max/min for TAL21-TAL14 Feed-Forward: mean = 289.67, mean+2std = 315.49, mean-2std = 265.97 
