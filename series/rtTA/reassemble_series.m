cd('/Users/junminwang/Documents/academics/belta/EQUIP_code/series/rtTA');
load('rtTA-series-Fine.mat');

% input = cell();
% output = cell();
% constitutive = cell();

series = cell(2, 1);
for k = 1:2,
    series{k, 1}.Means = cell(3, 2);
end

for k = 1:2,
    for m = 1:3,
        series{k,1}.Means{m, 2} = zeros(60, 16);
    end;
end;

for k = 1:2,  % number of series
    for j = 1:60,  % cfp levels
        for i = 1:16,  % time points
            for m = 1:3,  % type of params: ifp, cfp, ofp, altogether 3
                series{k, 1}.Means{m, 2}(j, i) = sampleresults{i, 1}{1, k}.Means(j, m);
            end;
        end;
    end;
end;

        