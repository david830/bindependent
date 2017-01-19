function prediction = predict_feedforward(induction, circuit, grain, verbosity)
if(nargin<4), verbosity = 1; end;

include_induction = 1; % Dox induction of R1 treated as pre-established if 0

% Modify I/O to reflect time-slice responses
% input ranges are not changed; output is divided by grain size
mod_inducer = circuit.inducer;
mod_inducer.output = circuit.inducer.output/grain;
mod_repressor1a = circuit.repressor1a;
mod_repressor1a.output = circuit.repressor1a.output/grain;
mod_repressor1b = circuit.repressor1b;
mod_repressor1b.output = circuit.repressor1b.output/grain;
mod_repressor2 = circuit.repressor2;
mod_repressor2.output = circuit.repressor2.output/grain;

% Project in time slices
if include_induction==2
    stage1 = zeros(size(induction.output));
else if include_induction==1
        stage1 = zeros(size(induction.output));
    else
        stage1 = induction.output; % assume induction is already at steady-state before others start
    end
end

safe_range = ones(size(induction.output));
lower_extrapolations = zeros(size(induction.output));
upper_extrapolations = zeros(size(induction.output));
max_lower_extrapolation = zeros(size(induction.output));
max_upper_extrapolation = zeros(size(induction.output));
stage2 = zeros(size(induction.output));
output = zeros(size(induction.output));

% We expect 2 cell divisions over the productive time
% This means that if we were producing constitutively, the final would be: 1/4 T1 + 1/2 T2 + 1 T3
% So, far example, producing at an initial rate of 100, we'd have: 100*1/4 + 50*1/2 + 25*1 = 75 as the final value
% (1-x)^grain = 1/4 ==> grain*log(1-x) = log(4) ==> log(1-x) = log(4)/grain ==> (1-x) = 4^(1/grain)
divisions = 2.4; % estimated to 1.2; previously 3
decay = ((2^divisions)^(1/grain))-1;
gal4_factor = ones(1,grain);
%first_div = floor(grain/divisions);
%gal4_factor(1:first_div) = ((1:first_div)/first_div);
production_mod = 1./(2.^floor((1:grain)/grain*divisions)) .* gal4_factor; % dilution aspect * Gal4 aspect

amp = 1/(sum(production_mod(grain - (1:grain) +1).*((1-decay).^(0:(grain-1))))/grain); % linear amplification to match

%amp=1; decay=0; production_mod=ones(1,grain);

if(verbosity), fprintf('Projecting'); end;
sequence = zeros([size(stage1) grain 3]);
for i=1:grain,
    if(verbosity), fprintf('.'); end;
    
    if include_induction==2
        [inc1 extra1 inter1 lo_ex_dist1 hi_ex_dist1] = project(induction.input,induction.plasmids,mod_inducer,i==1);
        inc1 = inc1*induction.multiplier;
    else if include_induction==1
        inc1 = induction.output/grain;
        end
        inter1 = 1; extra1 = 0; lo_ex_dist1 = 0; hi_ex_dist1 = 0;
    end
    if include_induction, stage1 = stage1*(1-decay) + inc1*amp*production_mod(i); end
    
    [inc2 extra2 inter2 lo_ex_dist2 hi_ex_dist2] = project(stage1,induction.plasmids,mod_repressor1a,i==1);
    stage2 = stage2*(1-decay) + inc2*amp*production_mod(i);

    % Feedforward has its final output hit by production from both stage1 and stage2
    [inc3 extra3 inter3 lo_ex_dist3 hi_ex_dist3] = project(stage1+stage2,induction.plasmids,mod_repressor2,i==1);
    output = output*(1-decay) + inc3*amp*production_mod(i);

    safe_range = safe_range & inter1 & inter2 & inter3;
    lower_extrapolations = lower_extrapolations + (extra1<0) + (extra2<0) + (extra3<0);
    upper_extrapolations = upper_extrapolations + (extra1>0) + (extra2>0) + (extra3>0);
    
    max_lower_extrapolation = max(max_lower_extrapolation,max(lo_ex_dist1,max(lo_ex_dist2,lo_ex_dist3)));
    max_upper_extrapolation = max(max_upper_extrapolation,max(hi_ex_dist1,max(hi_ex_dist2,hi_ex_dist3)));
    
    sequence(:,:,i,1) = stage1;
    sequence(:,:,i,2) = stage2;
    sequence(:,:,i,3) = output;
end
if(verbosity), fprintf('\n'); end;


prediction.output = output;
prediction.safe_range = safe_range;
prediction.stage1 = stage1;
prediction.stage2 = stage2;
prediction.sequence = sequence;
prediction.lower_extrapolations = lower_extrapolations;
prediction.upper_extrapolations = upper_extrapolations;
prediction.max_lower_extrapolation = max_lower_extrapolation;
prediction.max_upper_extrapolation = max_upper_extrapolation;
