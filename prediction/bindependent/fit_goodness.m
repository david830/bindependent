function [MSE mean_err max_err std_err err_in err_out] = fit_goodness(measured_in, measured_out, model_in, model_out)

%%%%% input does not matter in our implementation, because fit_goodness([], measured_out, [], model_out)

% Find the mean-squared error of the differences between measured and
% model levels, assuming a geometric model of error.
%
% MSE is the mean-square geometric error
% MSE is the mean geometric error
% MSE is the max-fold error
% err_in and err_out are the log10 ratio error between each point

which_in = ~isnan(measured_in) & ~isnan(model_in);
which_out = ~isnan(measured_out) & ~isnan(model_out);

log_err_in = abs(log10(measured_in(which_in)./model_in(which_in)));
log_err_out = abs(log10(measured_out(which_out)./model_out(which_out)));

sum_sqr_err = sum(sum([log_err_in.^2 log_err_out.^2]));
MSE = sum_sqr_err / (numel(log_err_in) + numel(log_err_out));

%mean_err = sum([log_err_in log_err_out]) / (numel(log_err_in) + numel(log_err_out));
errset = reshape([log_err_in log_err_out],1,[]);
mean_err = mean(errset);
std_err = std(errset);

max_err = max([log_err_in log_err_out]);

% Translate to output units
% MSE will not be translated
err_in = log_err_in;
err_out = log_err_out;

end
