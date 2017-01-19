load('device_data_set');
load('circuits');
load('circuit_predictions');

n = size(Dox_TAL14.plasmids,1);
hues = (1:n)./n;
step = 3;

generic_induction = Dox_TAL14;

for i=1:numel(feed_forwards),
    h = figure('PaperPosition',[1 1 6 4]);
    for j=1:step:n
        loglog(generic_induction.output(j,:),ff_predictions{i}.output(j,:),'o','Color',hsv2rgb([hues(j) 1 0.9])); hold on;
    end
    title(['Predictions for ' feed_forwards{i}.name]);
    xlabel('Input MEFL'); ylabel('Output MEFL');
    set(gca,'XScale','log'); set(gca,'YScale','log');
    xlim([1e4 1e8]); ylim([1e5 1e8]);
    set(gca,'XTick',[1e4 1e5 1e6 1e7 1e8]);
    set(gca,'YTick',[1e5 1e6 1e7 1e8]);
    outputfig(h,['Predict-' feed_forwards{i}.file],'plots');
end

for i=1:numel(triple_cascades),
    h = figure('PaperPosition',[1 1 6 4]);
    for j=1:step:n
        loglog(generic_induction.output(j,:),tc_predictions{i}.output(j,:),'o','Color',hsv2rgb([hues(j) 1 0.9])); hold on;
    end
    title(['Predictions for ' triple_cascades{i}.name]);
    xlabel('Input MEFL'); ylabel('Output MEFL');
    set(gca,'XScale','log'); set(gca,'YScale','log');
    xlim([1e4 1e8]); ylim([1e5 1e8]);
    set(gca,'XTick',[1e4 1e5 1e6 1e7 1e8]);
    set(gca,'YTick',[1e5 1e6 1e7 1e8]);
    outputfig(h,['Predict-' triple_cascades{i}.file],'plots');
end

% Snapshot samplers of TAL14-TAL21:
c=4;
% grain = 46, so:
samples = [1 6 12 24 46];
for i=1:numel(samples)
    outset = squeeze(ff_predictions{c}.sequence(:,:,samples(i),3));
    h = figure('PaperPosition',[1 1 6 4]);
    for j=1:step:n
        loglog(generic_induction.output(j,:),outset(j,:),'o','Color',hsv2rgb([hues(j) 1 0.9])); hold on;
    end
    title(['Predictions for ' feed_forwards{c}.name]);
    xlabel('Input MEFL'); ylabel('Output MEFL');
    set(gca,'XScale','log'); set(gca,'YScale','log');
    xlim([1e4 1e9]); ylim([1e4 1e8]);
    set(gca,'XTick',[1e4 1e5 1e6 1e7 1e8 1e9]);
    set(gca,'YTick',[1e4 1e5 1e6 1e7 1e8]);
    outputfig(h,sprintf('Predict-%s-hour-%i',feed_forwards{c}.file,samples(i)),'plots');
end
