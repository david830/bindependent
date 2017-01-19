load('device_data_set');

ff_src = ...
    {{'LmrA','TAL14',  Dox_LmrA,  LmrA,  TAL14, TAL14, [19 36]}, ...
     {},...%{'LmrA','TAL21',  Dox_LmrA,  LmrA,  TAL21, TAL21}, ...
     {},...%{'TAL14','LmrA',  Dox_TAL14, TAL14, LmrA,  LmrA}, ...
     {},...%{'TAL14','TAL21', Dox_TAL14, TAL14, TAL21, TAL21}, ...
     {'TAL21','LmrA',  Dox_TAL21, TAL21, LmrA,  LmrA, [19 36]}, ...
     {'TAL21','TAL14', Dox_TAL21, TAL21, TAL14, TAL14, [19 39]}};

stem = 'circuit_data/';

feed_forwards = cell(numel(ff_src),1);
for i=1:numel(ff_src)
    if isempty(ff_src{i}), continue; end;
    feed_forwards{i}.name = sprintf('%s-%s Feed-Forward',ff_src{i}{1},ff_src{i}{2});
    feed_forwards{i}.file = sprintf('FF-%s-%s',ff_src{i}{1},ff_src{i}{2});
    feed_forwards{i}.inducer = ff_src{i}{3};
    feed_forwards{i}.repressor1a = ff_src{i}{4};
    feed_forwards{i}.repressor1b = ff_src{i}{5};
    feed_forwards{i}.repressor2 = ff_src{i}{6};
    
    % Now load the available data:
    load([stem feed_forwards{i}.file '-Fine.mat']);
    plot_bin_histogram(results,sprintf('%s-%s',ff_src{i}{1},ff_src{i}{2}),ff_src{i}{7});
    
    [raw_FF Dox_FF] = modern_device_to_bulk_model(results,true,ff_src{i}{7});
    feed_forwards{i}.input = raw_FF.input;
    feed_forwards{i}.output = raw_FF.output;
    feed_forwards{i}.plasmids = raw_FF.plasmids;
    feed_forwards{i}.bincounts = raw_FF.bincounts;
    feed_forwards{i}.inducer = Dox_FF;
    feed_forwards{i}.stddev = raw_FF.stddev;

    %TAL21.input = TAL21.input/(relative_IFP(3)/relative_IFP(ref_id));
    %feed_forwards{i}.plasmids = TAL21.plasmids*(relative_CFP(3)/relative_CFP(ref_id));

end

save('circuits.mat','feed_forwards');

% tc_src = ...
%     {{'LmrA', 'TAL14','TAL21',  Dox_LmrA,  LmrA,  TAL14_2, TAL21_2}, ...
%      {'LmrA', 'TAL21','TAL14',  Dox_LmrA,  LmrA,  TAL21_2, TAL14_2}, ...
%      {'TAL14','LmrA', 'TAL21',  Dox_TAL14, TAL14, LmrA_2,  TAL21_2}, ...
%      {'TAL14','TAL21','LmrA',   Dox_TAL14, TAL14, TAL21_2, LmrA_2}, ...
%      {'TAL21','LmrA', 'TAL14',  Dox_TAL21, TAL21, LmrA_2,  TAL14_2}, ...
%      {'TAL21','TAL14','LmrA',   Dox_TAL21, TAL21, TAL14_2, LmrA_2}};
% 
% triple_cascades = cell(numel(tc_src),1);
% for i=1:numel(ff_src)
%     triple_cascades{i}.name = sprintf('%s-%s-%s Cascade',tc_src{i}{1},tc_src{i}{2},tc_src{i}{3});
%     triple_cascades{i}.file = sprintf('TC-%s-%s',tc_src{i}{1},tc_src{i}{2},tc_src{i}{3});
%     triple_cascades{i}.inducer = tc_src{i}{4};
%     triple_cascades{i}.repressor1 = tc_src{i}{5};
%     triple_cascades{i}.repressor2 = tc_src{i}{6};
%     triple_cascades{i}.repressor3 = tc_src{i}{7};
% end
%
% save('circuits.mat','feed_forwards','triple_cascades');
