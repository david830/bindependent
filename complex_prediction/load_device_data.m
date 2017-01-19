%%%
% Load curves identically to how they are loaded in the 2-input prediction

% get relative IFP levels
load('../controls/expression_calibration_2/ExpressionCalibration');

src_length = 9;

ref_id = 1;
o_ref_id = 1;
% Load Transfer curves
%%%%%%% LmrA %%%%%%%%
load('../devices/LmrA/LmrA-Fine.mat');
[raw_LmrA Dox_LmrA] = device_to_bulk_model(results,true);
LmrA = raw_LmrA;
LmrA.input = LmrA.input/(relative_IFP(1)/relative_IFP(ref_id));
LmrA.plasmids = LmrA.plasmids*(relative_CFP(1)/relative_CFP(ref_id));

LmrA.low_poly = 2*ones(1,21); LmrA.high_poly = LmrA.low_poly;
LmrA.low_src = src_length*ones(1,21);  LmrA.high_src = LmrA.low_src;

% Correcting for day/day differences in transfer curve:
% - 2x LmrA/TAL14 zero-Dox OFP ratio
% - 5x TAL14/LmrA zero-Dox IFP ratio
% Linear combination gives expected 0.4x depression of expected effective output
% This modification is not passed on to cascades, because their output is 
% modified by a repressor that always starts out constitutively expressed, just
% like the leaky Dox.
LmrA.output = LmrA.output*0.41;

LmrA_2 = LmrA;
LmrA_2.input = LmrA_2.input*3;

%%%%%%% TAL14 %%%%%%%%
load('../devices/TAL14/TAL14-Fine.mat');
[raw_TAL14 Dox_TAL14] = device_to_bulk_model(results,true);
TAL14 = raw_TAL14;
TAL14.input = TAL14.input/(relative_IFP(2)/relative_IFP(ref_id));
TAL14.plasmids = TAL14.plasmids*(relative_CFP(2)/relative_CFP(ref_id));

TAL14.low_poly = 2*ones(1,21); TAL14.high_poly = TAL14.low_poly;
TAL14.low_src = src_length*ones(1,21);  TAL14.high_src = TAL14.low_src;

TAL14.output = TAL14.output*0.93;

TAL14_2 = TAL14;
TAL14_2.input = TAL14_2.input*3;

%%%%%%% TAL21 %%%%%%%%
load('../devices/TAL21/TAL21-Fine.mat');
[raw_TAL21 Dox_TAL21] = device_to_bulk_model(results,true);
TAL21 = raw_TAL21;
TAL21.input = TAL21.input/(relative_IFP(3)/relative_IFP(ref_id));
TAL21.plasmids = TAL21.plasmids*(relative_CFP(3)/relative_CFP(ref_id));

TAL21.low_poly = 2*ones(1,21); TAL21.high_poly = TAL21.low_poly;
TAL21.low_src = src_length*ones(1,21);  TAL21.high_src = TAL21.low_src;

TAL21_2 = TAL21;
TAL21_2.input = TAL21_2.input*3;

save('device_data_set.mat', ...
    'raw_LmrA','LmrA','LmrA_2','Dox_LmrA',...
    'raw_TAL14','TAL14','TAL14_2','Dox_TAL14',...
    'raw_TAL21','TAL21','TAL21_2','Dox_TAL21');
