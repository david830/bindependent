% Begin by loading all of the experimental data
%load_experimental_data;
load('device_data_set');
load('circuits');

% Set prediction parameters
grain = 46; % 46 hours total

% Note: device inducer will need to be replaced by the experimental induction of each circuit

% Make base predictions:
fprintf('Predicting Feed-Forward Circuits\n');
ff_predictions = cell(numel(feed_forwards),1);
for i=1:numel(feed_forwards),
    if isempty(feed_forwards{i}), continue; end;
    ff_predictions{i} = predict_feedforward(feed_forwards{i}.inducer, feed_forwards{i},grain);
end

save('circuit_predictions.mat','ff_predictions','grain');

%tc is Triple Cascades
% fprintf('Predicting Triple-Cascade Circuits\n');
% tc_predictions = cell(numel(triple_cascades),1);
% for i=1:numel(triple_cascades),
%     tc_predictions{i} = predict_triple_cascade(triple_cascades{i}.inducer, triple_cascades{i},grain);
% end
% 
% save('circuit_predictions.mat','ff_predictions','tc_predictions','grain');
