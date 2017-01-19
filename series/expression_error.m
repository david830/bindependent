function MSE = expression_error(division, shock, expression, trans_eff, samples)
% samples is a Nx2 vector with each row a sample and columns {time,value}
    [levels activities] = expression_model(division, shock, expression, trans_eff, 72, 0.1);
    indices = samples(:,1)*10;
    %levels(200:10:300)
    %samples(1:10,:)
    exp_err = max(0,log10(abs((samples(:,2)-levels(indices)'))));
    act_err = 1*(samples(:,3)-activities(indices)');
    MSE = (sum(exp_err.^2)+sum(act_err.^2)) / numel(exp_err);
    %fprintf('%.3d %.3d %.3d ; ',division,shock,expression);
    fprintf('.');
end
