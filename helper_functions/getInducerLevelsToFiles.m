% This function returns a vector of inducer levels.
% Required Input: (1) results struct containing the experimental data
function [inducer_levels] = getInducerLevelsToFiles(results_struct,column)

if nargin < 2
    column = 1;
end

inducer_levels = [results_struct.InducerLevelsToFiles{:,column}];


end