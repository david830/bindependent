time = [17 24 38 50 66 71 91 117 135];

count = [880000 907500 1430000 3052500 4235000 5280000 6737500 6875000 8745000; ...
  1402500 632500 1650000 2117500 3520000 2282500 7452500 6380000 2420000];

meanlog = mean(log2(count));
P = polyfit(time,meanlog,1);

division_time = 1/P(1)
divisions = (72-7-division_time/2)/division_time
% 41.3 hours --> 1.07 divisions

Pe = polyfit(time(1:6),meanlog(1:6),1);
early_division_time = 1/Pe(1)
early_divisions = (72-7-early_division_time/2)/early_division_time
% 24.6 hours --> 2.13 divisions


