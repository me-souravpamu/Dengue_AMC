function ss = SEAIR_ss(param)

model_2020 = SEAIR_sol(param);
observed_2020 = 432;

ss = (model_2020 - observed_2020)^2;
