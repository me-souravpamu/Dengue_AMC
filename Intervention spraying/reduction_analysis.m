clear; clc;

load forecast_cases_2026_2028_without_intervention.mat
load forecast_cases_2026_2028_with_intervention.mat

years = [2026 2027 2028];

mean_no = mean(cases_no_intervention');
mean_with = mean(cases_with_intervention');

reduction = 100*(mean_no - mean_with)./mean_no;

disp('Mean cases WITHOUT intervention:')
disp(mean_no)

disp('Mean cases WITH intervention:')
disp(mean_with)

disp('Percentage reduction:')
disp(reduction)
