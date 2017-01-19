load 'Constitutive/ControlSeries.mat';
Const_mean = consensus_mean_activity;
Const_std = consensus_std_activity;
Const_2std = 10.^(2*log10(Const_std));

rtimes = times;

load 'rtTA/rtTA-series-Fine.mat';
rtTA_mean = mean_active_expression;
rtTA_std = std_active_expression';
rtTA_2std = 10.^(2*log10(rtTA_std));

load 'Gal4/Gal4-series-Fine.mat';
Gal4_mean = mean_active_expression;
Gal4_std = std_active_expression';
Gal4_2std = 10.^(2*log10(Gal4_std));

h = figure('PaperPosition',[1 1 5 3.66]);
plot(times,Const_mean,'k*-'); hold on;
plot(rtimes,rtTA_mean,'b*-');
plot(rtimes,Gal4_mean,'r*-');
plot(times,Const_mean.*Const_2std,'k:'); plot(times,Const_mean./Const_2std,'k:');
plot(rtimes,rtTA_mean.*rtTA_2std,'b:'); plot(rtimes,rtTA_mean./rtTA_2std,'b:');
plot(rtimes,Gal4_mean.*Gal4_2std,'r:'); plot(rtimes,Gal4_mean./Gal4_2std,'r:');
xlabel('Time (hours)');  ylabel('MEFL');
xlim([0 75]);
title('Active population mean MEFL vs time');
legend('Location','SouthEast','Constitutive','rtTA','Gal4','\pm 2 std.dev.');
outputfig(h,'series-population-mean');
set(gca,'YScale','log');
ylim([1e5 4e7]);
outputfig(h,'series-population-mean-log');

% Note: geomean vs. arithmetic mean makes no significant difference here
Const_norm = mean(Const_mean(10:15));
rtTA_norm = mean(rtTA_mean(11:16));
Gal4_norm = mean(Gal4_mean(11:16));

h = figure('PaperPosition',[1 1 5 3.66]);
plot(times,Const_mean/Const_norm,'k*-'); hold on;
plot(rtimes,rtTA_mean/rtTA_norm,'b*-');
plot(rtimes,Gal4_mean/Gal4_norm,'r*-');
plot(times,Const_mean/Const_norm.*Const_2std,'k:'); plot(times,Const_mean/Const_norm./Const_2std,'k:');
plot(rtimes,rtTA_mean/rtTA_norm.*rtTA_2std,'b:'); plot(rtimes,rtTA_mean/rtTA_norm./rtTA_2std,'b:');
plot(rtimes,Gal4_mean/Gal4_norm.*Gal4_2std,'r:'); plot(rtimes,Gal4_mean/Gal4_norm./Gal4_2std,'r:');
xlabel('Time (hours)');  ylabel('Normalized Expression');
xlim([0 75]);
title('Active population mean MEFL vs time');
legend('Location','SouthEast','Constitutive','rtTA','Gal4','\pm 2 std.dev.');
outputfig(h,'series-population-mean-norm');
set(gca,'YScale','log');
ylim([1e-2,4e0]);
outputfig(h,'series-population-mean-log-norm');
