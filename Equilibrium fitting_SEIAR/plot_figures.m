load sampling_result_SEAIR_fit.mat

[~,idx] = min(K);
param = J(idx,:);

model_2020 = SEAIR_sol(param);

fprintf('\nModel reported cases in 2020 = %.2f\n',model_2020);
fprintf('Observed cases = 432\n');

bar([model_2020 432])
set(gca,'XTickLabel',{'Model','Observed'})
ylabel('Reported dengue patients (2020)')
