# M-SDT: MATLAB Codes for Dengue Transmission, Forecasting, and Intervention Analysis

This repository contains the MATLAB codes used for the analyses presented in the paper:

"M-SDT: A modelling framework for dengue transmission, forecasting, and intervention strategies in Ahmedabad Municipal Corporation"

Authors:
Sourav Roy, Rajendra Gadhavi, Bhavin Solanki, Chirag Shah, Raj C. Sharma, and Indrajit Ghosh

arXiv:
https://arxiv.org/abs/2605.17975

The repository contains the complete computational workflow for:

1. Parameter fitting of the SEAIR–mosquito model
2. Bootstrap-based parameter estimation and forecasting
3. Global sensitivity analysis
4. Fogging intervention simulations
5. Residual spraying intervention simulations
6. Long-term daily and yearly dengue time-series generation


======================================================================
1. MODEL OVERVIEW
======================================================================

The code implements a coupled human–mosquito SEAIR-type dengue transmission model.

The human population is divided into:

    S  - Susceptible humans
    E  - Exposed humans
    I  - Symptomatic infectious humans
    A  - Asymptomatic infectious humans
    R  - Recovered humans

The mosquito population is divided into:

    Ms - Susceptible mosquitoes
    Mi - Infectious mosquitoes

The model incorporates dengue transmission between humans and mosquitoes, demographic processes, progression through infection states, and intervention-dependent mosquito mortality.

The model is used for:

    - historical model fitting,
    - uncertainty quantification,
    - future dengue forecasting,
    - sensitivity analysis,
    - and evaluation of vector-control interventions.


======================================================================
2. REPOSITORY STRUCTURE
======================================================================

The repository is organized into six main folders.

    Equilibrium fitting_SEIAR/
        Initial parameter sampling and fitting

    runme_SEAIR_bootstrap_AMC/
        Bootstrap-based parameter estimation and forecasting

    Sensitivity_analysis_dengue/
        Global sensitivity analysis using LHS and PRCC

    Intervention fogging final/
        Dengue forecasts with and without fogging intervention

    Intervention spraying/
        Dengue forecasts with and without residual spraying intervention

    timeseries/
        Generation of daily and yearly model time series


======================================================================
3. SOFTWARE REQUIREMENTS
======================================================================

The codes were developed and tested in MATLAB.

Recommended MATLAB version:
    MATLAB R2022b or a compatible recent MATLAB release.

Depending on the folder being executed, the following MATLAB toolboxes/functions may be required:

    - MATLAB ODE solvers
    - Optimization Toolbox
    - Statistics and Machine Learning Toolbox
    - Parallel Computing Toolbox

Important MATLAB functions used in the repository include:

    ode15s
    lsqcurvefit
    parfor
    nbinrnd
    ksdensity
    prctile
    quantile

If a MATLAB function is unavailable, check that the corresponding toolbox is
installed and licensed.


======================================================================
4. OVERALL COMPUTATIONAL WORKFLOW
======================================================================

The computational workflow of the repository follows the chronology of
the dengue model calibration, historical simulation, parameter fitting,
and future intervention forecasting.

The main workflow is:

    Equilibrium fitting
            |
            v
    Selection/fixing of b0
            |
            v
    Long-term daily time-series simulation
    (1961–2020)
            |
            v
    Multi-year calibration/bootstrap fitting
    (2021–2024)
            |
            v
    Bootstrap parameter distributions
            |
            +--------------------------+
            |                          |
            v                          v
       Fogging intervention      Residual spraying
       (2021–2024)               (2021–2024)
            |                          |
            +------------+-------------+
                         |
                         v
                 Future forecasting
                    (2026–2028)
                         |
                         v
              Intervention comparison
              and reduction analysis


The sensitivity analysis is a separate analysis branch based on
Latin Hypercube Sampling and PRCC and does not constitute a sequential
step between the calibration and intervention analyses.




======================================================================
5. FOLDER 1: Equilibrium fitting_SEIAR
======================================================================

Purpose
-------

This folder performs an initial parameter sampling and fitting procedure for
the SEAIR–mosquito model.

The fitting procedure searches over the model parameters:

    b0
    p
    m

using Latin Hypercube Sampling (LHS).

The sampled parameter combinations are evaluated against the observed
2020 dengue case count.

The observed number of reported dengue cases used in this fitting procedure
is:

    2020 observed cases = 432


Main files
----------

runme.m
    Main script for the initial parameter search and fitting.

LHS_Call.m
    Generates Latin Hypercube samples for the parameter combinations.

SEAIR_ode.m
    Defines the differential equations of the SEAIR–mosquito model.

SEAIR_sol.m
    Solves the model using MATLAB's ode15s solver and calculates the
    corresponding reported dengue cases.

SEAIR_ss.m
    Calculates the squared error between model-predicted and observed
    dengue cases.

params_SEAIR.m
    Defines model parameters and parameter settings.

plot_figures.m
    Loads the fitting results and generates a comparison between model
    predictions and observed dengue cases.


How to run
----------

1. Open MATLAB.
2. Set the current directory to:

       Equilibrium fitting_SEIAR

3. Run:

       runme.m

4. After completion, the script generates:

       sampling_result_SEAIR_fit.mat

5. To visualize the fitted result, run:

       plot_figures.m


Main output
-----------

sampling_result_SEAIR_fit.mat

This file contains the parameter samples and corresponding fitting errors.

The best-fitting parameter combination is identified from the sampled
parameter sets.

plot_figures.m produces a bar plot comparing:

    Model-predicted 2020 dengue cases
    Observed 2020 dengue cases


Important note
--------------

This folder is intended as an initial parameter screening/fitting procedure.
The more extensive uncertainty analysis and bootstrap estimation are
performed in:

    runme_SEAIR_bootstrap_AMC


======================================================================
6. FOLDER 2: runme_SEAIR_bootstrap_AMC
======================================================================

Purpose
-------

This folder performs bootstrap-based parameter estimation and uncertainty
quantification for the SEAIR–mosquito dengue model.

It is used to obtain distributions of fitted model parameters and simulated
dengue trajectories.

The workflow also provides the parameter estimates required by the
forecasting and intervention analyses.


IMPORTANT
---------

This folder contains two bootstrap scripts:

    runme_SEAIR_bootstrap_model.m
    runme_SEAIR_bootstrap.m

They represent two bootstrap workflows implemented in the checked code.

The primary model-fitting workflow is:

    runme_SEAIR_bootstrap_model.m

The alternative bootstrap workflow is:

    runme_SEAIR_bootstrap.m


A. Primary bootstrap workflow
----------------------------

Run:

    runme_SEAIR_bootstrap_model.m

This script:

    - uses the observed dengue data for model fitting,
    - generates bootstrap realizations,
    - fits model parameters using bounded nonlinear least squares,
    - simulates the corresponding model trajectories,
    - and stores the fitted parameter and trajectory information.

The primary workflow uses 250 bootstrap realizations.


Main output:

    SEAIR_bootstrap_results.mat

This MAT file contains quantities including:

    Phat
    curves
    z_hat
    mu_model

The fitted parameter information in this file is subsequently used by the
forecasting and intervention folders.


B. Alternative bootstrap workflow
---------------------------------

Run:

    runme_SEAIR_bootstrap.m

This script implements an alternative bootstrap fitting procedure using
negative-binomial sampling.

This workflow uses 500 bootstrap realizations and is based on the
2021–2024 observed data implemented in the script.


WARNING
-------

Both bootstrap scripts save their results using the same filename:

    SEAIR_bootstrap_results.mat

Therefore, running one script after the other will overwrite the previous
file.

If results from both workflows are required, rename or move the MAT file
after running each workflow.


Other files
-----------

SEAIR_SSE.m
    Calculates the sum of squared error used during fitting.

SEAIR_ode.m
    Defines the SEAIR–mosquito model equations.

forecast_SEAIR.m
    Supports model forecasting.

plims.m
    Computes parameter/forecast limits used in plotting.

plot_fit_SEAIR.m
    Plots bootstrap model fits together with observed data.

plot_parameter_histograms.m
    Plots bootstrap distributions of fitted parameters.

plotSEAIR_annual.m
    Generates annual dengue model plots.

violin_plot.m
    Generates violin plots for forecast distributions.

params_SEAIR.m
    Defines model parameters.


Recommended execution
---------------------

Run:

    runme_SEAIR_bootstrap_model.m

After completion, use:

    plot_fit_SEAIR.m

    plot_parameter_histograms.m

to inspect the bootstrap model fits and parameter distributions.


======================================================================
7. FOLDER 3: Sensitivity_analysis_dengue
======================================================================

Purpose
-------

This folder performs global sensitivity analysis of the dengue transmission
model.

The analysis uses:

    Latin Hypercube Sampling (LHS)
    Partial Rank Correlation Coefficients (PRCC)

Seven model parameters are varied:

    b0
    beta_HM
    beta_MH
    p
    m
    theta
    mu_M


Main workflow
-------------

Step 1:
    Run:

        Model_LHS.m

This generates 1000 parameter combinations using Latin Hypercube Sampling.

The resulting parameter matrix is saved as:

    Model_LHS_DenV.mat


Step 2:
    Run:

        main_sen_ana_denv.m

This script:

    - loads the LHS samples,
    - simulates the dengue model for the sampled parameter sets,
    - evaluates the forecast response for 2026–2030,
    - calculates PRCC values,
    - calculates the corresponding significance information,
    - and generates the sensitivity plots.


Main output
-----------

The main results are saved as:

    sen_results.mat

The MAT file contains quantities including:

    prcc_area
    sign_area
    LHSmatrix
    PRCC_var
    I_total


The sensitivity analysis uses the total number of dengue cases over the
forecast period 2026–2030 as the response variable.


Other files
-----------

LHS_Call.m
    Generates LHS samples.

Model_LHS.m
    Creates the parameter sampling matrix.

main_sen_ana_denv.m
    Main sensitivity-analysis script.

PRCC.m
    Calculates Partial Rank Correlation Coefficients.

monotonicity.m
    Checks monotonic relationships used in the PRCC analysis.

variable_monotonicity.m
    Supports the monotonicity assessment.

quartile.m
    Auxiliary statistical function.

ltqnorm.m
    Auxiliary numerical function.

SEAIR_ode.m
    Defines the dengue model.

params_SEAIR.m
    Defines model parameters.

plotSEAIR_annual.m
    Produces annual model plots.

subplot_fig_files.m
    Supports generation of figure panels.


======================================================================
8. FOLDER 4: Intervention fogging final
======================================================================

Purpose
-------

This folder evaluates the effect of fogging as a vector-control intervention.

The analysis compares:

    1. Dengue forecasts without fogging
    2. Dengue forecasts with fogging

The comparison is performed for:

    2026
    2027
    2028


Input
-----

This folder requires:

    SEAIR_bootstrap_results.mat

This file is generated in:

    runme_SEAIR_bootstrap_AMC

Copy the required bootstrap result file into the fogging folder before
running the forecast scripts.


Fogging implementation
----------------------

The fogging intervention is implemented through:

    fogging_factor.m

The function defines a time-dependent additional mosquito mortality effect.

In the checked code:

    start_day = 151
    end_day   = 272
    events_per_season = 17

The intervention effect is active during the specified seasonal period.

The intervention contribution is incorporated into the mosquito mortality
terms in:

    SEAIR_ode_prevention.m


Main files
----------

forecast_SEAIR_no_intervention.m
    Generates 2026–2028 forecasts without fogging.

forecast_SEAIR_with_intervention.m
    Generates 2026–2028 forecasts with fogging.

fogging_factor.m
    Defines the time-dependent fogging intervention factor.

SEAIR_ode_prevention.m
    Defines the model equations including the fogging effect.

No_intervention_SEAIR.m
    Simulates the model without intervention.

With_intervention_SEAIR.m
    Simulates the model with intervention.

plot_fogging_function.m
    Plots the temporal fogging intervention function.

plotting_violin.m
    Compares forecast distributions with and without intervention.

box_plot_reduction.m
    Generates boxplots of the relative reduction in dengue cases.

reduction_analysis.m
    Calculates and displays the reduction in dengue cases.

params_SEAIR.m
    Defines model parameters.


Recommended execution order
---------------------------

1. Make sure:

       SEAIR_bootstrap_results.mat

   is available in this folder.

2. Run:

       forecast_SEAIR_no_intervention.m

3. Run:

       forecast_SEAIR_with_intervention.m

4. Run:

       plotting_violin.m

5. Run:

       box_plot_reduction.m

6. Run:

       reduction_analysis.m

7. To visualize the intervention function, run:

       plot_fogging_function.m


Generated forecast files
------------------------

The no-intervention forecast is saved as:

    forecast_cases_2026_2028_without_intervention.mat

The intervention forecast is saved as:

    forecast_cases_2026_2028_with_intervention.mat

These two files are subsequently used for comparison and reduction analysis.


======================================================================
9. FOLDER 5: Intervention spraying
======================================================================

Purpose
-------

This folder evaluates the effect of residual spraying as a vector-control
intervention.

The analysis compares dengue forecasts:

    without residual spraying

versus

    with residual spraying

for the forecast years:

    2026
    2027
    2028


Input
-----

This folder requires:

    SEAIR_bootstrap_results.mat

generated by the bootstrap analysis in:

    runme_SEAIR_bootstrap_AMC


Residual spraying implementation
--------------------------------

The intervention is defined in:

    spraying.m

The active implementation in the checked code uses a time-dependent
quadratic decay function.

The relevant settings are:

    start_day = 151
    end_day   = 333
    f0        = 0.25

During the active spraying period, the intervention factor is:

    f = f0 * (1 - (tau/duration)^2)

where tau represents the elapsed time since the beginning of the
intervention period.

Thus, the intervention effect is strongest at the beginning of the
active period and decreases gradually with time until it reaches zero
at the end of the specified period.

The function is evaluated periodically using the day of the year.

Therefore, the current implementation represents a time-dependent
residual spraying effect rather than a single instantaneous mosquito
kill at the time of application.


Main files
----------

spraying.m
    Defines the residual spraying intervention function.

forecast_SEAIR_no_intervention.m
    Generates 2026–2028 forecasts without spraying.

forecast_SEAIR_with_intervention.m
    Generates 2026–2028 forecasts with spraying.

SEAIR_ode_prevention.m
    Incorporates the spraying effect into mosquito mortality.

No_intervention_SEAIR.m
    Simulates the model without intervention.

With_intervention_SEAIR.m
    Simulates the model with intervention.

plot_spraying_function.m
    Plots the time-dependent spraying function.

plotting_violin.m
    Compares forecast distributions with and without spraying.

box_plot_reduction.m
    Generates boxplots of the relative reduction in dengue cases.

reduction_analysis.m
    Calculates and displays the reduction in dengue cases.

params_SEAIR.m
    Defines model parameters.


Recommended execution order
---------------------------

1. Place:

       SEAIR_bootstrap_results.mat

   in this folder.

2. Run:

       forecast_SEAIR_no_intervention.m

3. Run:

       forecast_SEAIR_with_intervention.m

4. Run:

       plotting_violin.m

5. Run:

       box_plot_reduction.m

6. Run:

       reduction_analysis.m

7. To visualize the spraying function, run:

       plot_spraying_function.m


Generated forecast files
------------------------

The no-intervention forecast is saved as:

    forecast_cases_2026_2028_without_intervention.mat

The spraying-intervention forecast is saved as:

    forecast_cases_2026_2028_with_intervention.mat

These files are used by the subsequent comparison and reduction scripts.


======================================================================
10. FOLDER 6: timeseries
======================================================================

Purpose
-------

This folder generates long-term daily and yearly dengue model time series.

The model is simulated from:

    1961 to 2020

using a daily time step.


Main files
----------

dengue_daywise.m
    Main script for generating the daily and yearly model output.

dengue_rhs.m
    Defines the right-hand side of the dengue transmission model.


Numerical method
----------------

The script uses a fixed-step Dormand–Prince RK45 formulation with:

    dt = 1 day

The model tracks:

    S
    E
    I
    A
    R
    Ms
    Mi

and calculates the daily reported dengue incidence from the model.


How to run
----------

Open MATLAB and set the current directory to:

    timeseries

Then run:

    dengue_daywise.m


Main output files
-----------------

The script generates:

    dengue_AMC_daily_1961_2020.csv

This file contains the daily model output.

It also generates:

    dengue_AMC_yearly_1961_2020.csv

This file contains the yearly aggregated model output.


The script also displays plots of:

    - model compartments
    - daily reported dengue cases


======================================================================
11. INPUT AND OUTPUT DEPENDENCIES
======================================================================

The main dependency between folders is the bootstrap result file.

The workflow is:

    runme_SEAIR_bootstrap_AMC
                |
                | produces
                v
    SEAIR_bootstrap_results.mat
                |
        -------------------------
        |                       |
        v                       v
Intervention fogging      Intervention spraying
        |                       |
        v                       v
forecast without/with     forecast without/with
intervention              intervention
        |                       |
        v                       v
violin/box/reduction      violin/box/reduction
analysis                  analysis


The sensitivity analysis is a separate workflow based on its own LHS
sampling procedure.

The timeseries folder is also an independent workflow for generating
long-term daily and yearly model trajectories.


======================================================================
12. QUICK REPRODUCTION GUIDE
======================================================================

For a user who wants to reproduce the main analyses, the following
commands/scripts should be executed.

A. Initial fitting
------------------

Folder:

    Equilibrium fitting_SEIAR

Run:

    runme.m

Then:

    plot_figures.m


B. Bootstrap fitting
--------------------

Folder:

    runme_SEAIR_bootstrap_AMC

Run:

    runme_SEAIR_bootstrap_model.m

Then, if required:

    plot_fit_SEAIR.m
    plot_parameter_histograms.m


C. Sensitivity analysis
-----------------------

Folder:

    Sensitivity_analysis_dengue

Run:

    Model_LHS.m

Then:

    main_sen_ana_denv.m


D. Fogging intervention
-----------------------

Folder:

    Intervention fogging final

First ensure:

    SEAIR_bootstrap_results.mat

is present.

Then run:

    forecast_SEAIR_no_intervention.m
    forecast_SEAIR_with_intervention.m
    plotting_violin.m
    box_plot_reduction.m
    reduction_analysis.m

Optional:

    plot_fogging_function.m


E. Residual spraying intervention
---------------------------------

Folder:

    Intervention spraying

First ensure:

    SEAIR_bootstrap_results.mat

is present.

Then run:

    forecast_SEAIR_no_intervention.m
    forecast_SEAIR_with_intervention.m
    plotting_violin.m
    box_plot_reduction.m
    reduction_analysis.m

Optional:

    plot_spraying_function.m


F. Long-term time series
------------------------

Folder:

    timeseries

Run:

    dengue_daywise.m


======================================================================
13. SUMMARY OF MAIN OUTPUTS
======================================================================

Folder:
    Equilibrium fitting_SEIAR

Main output:
    sampling_result_SEAIR_fit.mat

Purpose:
    Initial parameter sampling and fitting.


Folder:
    runme_SEAIR_bootstrap_AMC

Main output:
    SEAIR_bootstrap_results.mat

Purpose:
    Bootstrap parameter estimates and simulated trajectories.


Folder:
    Sensitivity_analysis_dengue

Main outputs:
    Model_LHS_DenV.mat
    sen_results.mat

Purpose:
    LHS parameter sampling and PRCC sensitivity analysis.


Folder:
    Intervention fogging final

Main outputs:
    forecast_cases_2026_2028_without_intervention.mat
    forecast_cases_2026_2028_with_intervention.mat

Purpose:
    Comparison of dengue forecasts with and without fogging.


Folder:
    Intervention spraying

Main outputs:
    forecast_cases_2026_2028_without_intervention.mat
    forecast_cases_2026_2028_with_intervention.mat

Purpose:
    Comparison of dengue forecasts with and without residual spraying.


Folder:
    timeseries

Main outputs:
    dengue_AMC_daily_1961_2020.csv
    dengue_AMC_yearly_1961_2020.csv

Purpose:
    Daily and yearly long-term dengue model trajectories.


======================================================================
14. IMPORTANT REPRODUCIBILITY NOTES
======================================================================

1. Run MATLAB scripts from their respective folders.

2. The intervention folders depend on:

       SEAIR_bootstrap_results.mat

   generated by the bootstrap folder.

3. The bootstrap scripts:

       runme_SEAIR_bootstrap_model.m
       runme_SEAIR_bootstrap.m

   both save results using the filename:

       SEAIR_bootstrap_results.mat

   Running both sequentially will overwrite the previous result unless
   the MAT file is renamed or moved.

4. The intervention forecast scripts generate MAT files that are then
   used by the violin plots, boxplots, and reduction-analysis scripts.

5. Several analyses use random sampling and/or bootstrap resampling.
   Therefore, exact reproduction of individual bootstrap samples may
   require setting and preserving the MATLAB random-number-generator
   state.

6. The number of samples/realizations is defined directly in the scripts.
   Users should not change these values if they wish to reproduce the
   computational settings used in the checked version of the code.

7. The scripts should be run using the parameter settings provided in
   the repository unless a new experiment is intended.

8. Some scripts generate figures directly in MATLAB without saving the
   figure to a separate file. Figures can be exported manually from
   MATLAB if required.


======================================================================
15. INTERVENTION INTERPRETATION
======================================================================

Fogging
-------

The fogging intervention is implemented as an additional mosquito
mortality contribution through:

    fogging_factor.m

The factor is active during a prescribed seasonal period and is added
to the mosquito mortality terms in the prevention model.


Residual spraying
-----------------

The residual spraying intervention is implemented through:

    spraying.m

In the current checked implementation, the spraying effect is
time-dependent and decreases quadratically during the active period.

It is therefore not represented as a single instantaneous reduction
in mosquito abundance. Instead, the model applies an additional
time-dependent mortality effect during the specified residual-effect
period.


======================================================================
16. FILE NAMING CONVENTION
======================================================================

Files beginning with:

    SEAIR_*
        Core SEAIR–mosquito model, parameter functions, fitting or
        forecasting routines.

Files beginning with:

    forecast_*
        Generate future dengue forecasts.

Files beginning with:

    plot*
        Generate figures and visualization outputs.

Files beginning with:

    runme*
        Main execution scripts for a particular analysis.

Files beginning with:

    main*
        Main analysis scripts.

Files beginning with:

    params*
        Parameter definitions.

Files beginning with:

    *intervention* / prevention-related files
        Intervention-specific model implementations.

Files beginning with:

    reduction*
        Calculate intervention-associated changes in predicted cases.


======================================================================
17. PAPER
======================================================================

The codes accompany the following manuscript:

M-SDT: A modelling framework for dengue transmission, forecasting, and
intervention strategies in Ahmedabad Municipal Corporation

Authors:
Sourav Roy, Rajendra Gadhavi, Bhavin Solanki, Chirag Shah,
Raj C. Sharma, and Indrajit Ghosh

arXiv:
https://arxiv.org/abs/2605.17975


======================================================================
18. CONTACT
======================================================================

For questions regarding the model, implementation, or reproduction of
the results, please refer to the corresponding authors of the manuscript.


======================================================================
END OF README
======================================================================