function plot_bin_histogram(results,name,binrange)

if nargin<3
    minbin=19; maxbin=39;
else
    minbin=binrange(1); maxbin=binrange(2);
end

bins = getBins(getAnalysisParameters(results));
n_bins = get_n_bins(bins);
hues(1:(minbin-1)) = 0;
n_colored = (maxbin-minbin+1);
hues(minbin:maxbin) = (1:n_colored)./n_colored;
hues((maxbin+1):65) = 0;%(1:25)./25;

bin_edges = get_bin_edges(bins);

%%% Bin count plots:
% Counts by CFP level:
maxcount = 1e1;
h = figure('PaperPosition',[1 1 5 3.66]);
for i=1:50
    bin_counts = getBinCounts(results);
    count = mean(bin_counts(i,:));
    active = getFractionActive(results);
    if i>=minbin && i<=maxbin,
        color = hsv2rgb([hues(i) 1 0.9]);
    else
        color = [0 0 0];
    end
    area([bin_edges(i) bin_edges(i+1)],[0 count; 0 count],'FaceColor',color); hold on;
    maxcount = max(maxcount,count);
end
xlabel('CFP MEFL'); ylabel('Count');
set(gca,'XScale','Log');
ylim([0 1.1*maxcount]);
xlim([1e4,1e9])
title([name ' distribution']);
outputfig(h,sprintf('%s-BinHistogram',name),'plots');
