function SSE = SEAIR_SSE(param,years_obs,cases_obs)

cases_model = plotSEAIR_annual(param,years_obs);

SSE = sum((cases_model(end-3:end) - cases_obs).^2);
