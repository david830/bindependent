% Return (1)expression seperated by CFP bin, (2)CFP bin matrix, and stdv
% matrix
function [expression,CFP,stddev] = get_channel_results(results,result_type)

switch result_type
    case 'input'
        expression = results.Means{1,2};
        stddev = results.StdOfMeans{1,2};
    case 'output'
        expression = results.Means{3,2};
        stddev = results.StdOfMeans{3,2};
    otherwise
        error('The result type was not found');
end

CFP = results.Means{3,2};
        

end