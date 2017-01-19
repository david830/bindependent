function [expression fraction_active] = expression_model(division,shock,production,trans_eff,duration,dt)

degradation = 0;
dilution = 1/division;
activation_period = division;

time = 0:dt:duration; % hours
production_mod = (0.5).^floor((time-shock)/division);

level = zeros(size(time));
for i = 2:numel(time)
    if time(i)<shock, continue; end;
    %if production_mod(i) < production_mod(i-1), mod_down = 0.5; else mod_down = 1; end;
    mod_down = 1; % That shouldn't have been there, since the dilution is already being modeled.
    level(i) = level(i-1)*(1-((dilution+degradation)*dt))*mod_down + production * production_mod(i) * dt;
end

expression = zeros(size(time));
offsets = 0:dt:activation_period;
for i = 1:numel(offsets),
    expression(i:end) = expression(i:end) + level(1:(end-i+1))/numel(offsets);
end

fraction_active = zeros(size(expression));
for i=1:numel(fraction_active)
    if time(i)<shock,
        fraction_active(i) = 0;
    else if time(i)>(shock+activation_period)
            fraction_active(i) = 1;
        else
            fraction_active(i) = (time(i)-shock)/activation_period;
        end
    end
end
fraction_active = fraction_active * trans_eff;
