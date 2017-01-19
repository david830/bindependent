settings = TASBESettings();
cd '1107controlT58/control1/';
NM = computeNoiseModel(CM,settings);
cd '../..';

colors = {{'r-','g-'},{'b-','g--'},{'b--','r--'}};
h = figure('PaperPosition',[1 1 6 4]);
for i=1:3
    for j=1:2
        which = NM.detailmeans{i}{j}>5e5 & NM.detailcounts{i}{j}>100;
        semilogx(NM.detailmeans{i}{j}(which),NM.detailstds{i}{j}(which),colors{i}{j}); hold on;
    end
end
legend('mKate from EBFP2','EYFP from EBFP2','EBFP2 from mKate','EYFP from mKate','EBFP2 from EYFP','mKate from EYFP');
xlabel('CFP MEFL');
ylabel('Geometric Std.Dev.');
title('Relative Noise Model');
outputfig(h,'summary-noise-model');
