{smcl}
{* *! version 0.2 12sep2025}{...}
{cmd:longview} — Plot cumulative treatment effects from an event study difference-in-differences setup.

{title:Syntax}

{p 8 15 2}
{cmd:longview} {it:depvar} {ifin}, 
{cmd:time(}{it:varname}{cmd:)} 
{cmd:treatvar(}{it:varname}{cmd:)} 
{cmd:treatdatevar(}{it:varname}{cmd:)} 
{cmd:window(}{it:# #}{cmd:)} 
[{cmd:controls(}{it:varlist}{cmd:)} 
{cmd:absorb(}{it:varname}{cmd:)} 
{cmd:vce(}{it:string}{cmd:)} 
{cmd:title(}{it:string}{cmd:)} 
{cmd:xlines(}{it:numlist}{cmd:)} 
{cmd:save(}{it:filename}{cmd:)}]

{title:Introduction}

{pstd}
{cmd:longview} estimates and plots the {it:cumulative treatment effect} over time in a Difference-in-Differences setting.
It constructs event-time dummies relative to each unit's treatment time and plots the cumulative sum of coefficients, including confidence intervals. 
This is especially useful when you are interested in the total accumulated effect of a treatment or intervention across a window of time.

{title:Description}

{pstd}
In many applications of Difference-in-Differences (DiD), researchers are not only interested 
in the dynamic {it:period-specific} effects of a treatment but also in its {it:total accumulated impact} over time. 
Standard event-study regressions estimate treatment effects relative to 
the time of adoption, producing a sequence of Average Treatment Effects on the Treated (ATTs) 
for each event time. While informative, these coefficients can be difficult to interpret in 
isolation, particularly when one is interested in the overall magnitude of an intervention.
{cmd:longview} builds on the event-study framework by summing ATT coefficients across 
periods to produce and plot the {it:cumulative treatment effect}. It is especially useful 
for policy questions where the long-run impact of an intervention is of central importance.

{pstd}
Recent econometric research has highlighted important limitations of two-way fixed effects 
(TWFE) estimators in staggered adoption designs, including biased and sometimes negative-weighted 
event-study coefficients when treatment effects are heterogeneous (see 
{browse "https://doi.org/10.1016/j.jeconom.2020.12.001":Callaway & Sant'Anna 2021}, 
{browse "https://doi.org/10.1093/qje/qjab020":Sun & Abraham 2021}, 
{browse "https://doi.org/10.1093/qje/qjac005":Borusyak, Jaravel & Spiess 2021}). 
Cumulative treatment plots help mitigate interpretability issues by shifting the focus away 
from noisy period-specific dynamics to the aggregate path of treatment effects. Although they 
do not resolve identification problems on their own, they often provide a more robust and 
policy-relevant view of treatment impact. An upcoming version of this package will use ATTGTs (a 
la Callaway & Sant'Anna, 2021) for calculating event-study coefficients.

{pstd}
In short, {cmd:longview} is meant as a complement to the usual event-study graphs: it 
shows how treatment effects build up over time and their long-run dynamics. Plotting also  helps
visualize the {it:cumulative} pre-treatment effects, which can be an additional useful check on 
the parallel trends assumption.

{pstd}
{it:Disclaimer:} This package is provided as-is. The author takes no responsibility for the 
theoretical validity of the resulting graphs, which should be interpreted with appropriate 
caution and in light of current econometric research.

{title:Arguments}

{phang}
{opt time(varname)}  
The running time variable (e.g., calendar year, quarter, etc.).

{phang}
{opt treatvar(varname)}  
A binary indicator equal to 1 for treated units and 0 for control units.

{phang}
{opt treatdatevar(varname)}  
Variable indicating the period in which each unit was first treated.

{phang}
{opt window(# #)}  
Two integers specifying the pre- and post-treatment window of event time to include (e.g., {bf:{-5 5}} for a 5-year window before and after treatment).

{title:Additional Options}

{phang}
{opt controls(varlist)}  
Additional control variables to include in the regression.

{phang}
{opt absorb(varname)}  
Absorb (i.e., fixed effects) variable(s), passed to {cmd:reghdfe}.

{phang}
{opt vce(string)}  
Specify the VCE type (e.g., {cmd:robust}, {cmd:cluster panelid}, etc.) for standard errors.

{phang}
{opt title(string)}  
Title for the output graph.

{phang}
{opt xlines(numlist)}  
Additional vertical reference lines on the plot (e.g., for policy dates or external events).

{phang}
{opt save(filename)}  
Exports the graph to a file (e.g., {cmd:mygraph.png}).

{title:Remarks}

{pstd}
This command uses {cmd:reghdfe} to estimate the regression model with event-time dummies and optional fixed effects. It excludes the -1 relative time dummy as the omitted category (standard in event studies). Cumulative effects and confidence intervals are computed and plotted over time.

{pstd}
Note: Confidence intervals are currently computed by summing the lower and upper bounds of the 95% confidence interval for each coefficient. A more precise method using the variance-covariance matrix is under development.

{title:Examples}

{dlgtab:Basic usage}

{cmd:. longview outcome, time(year) treatvar(D) treatdatevar(treat_year) window(-5 5)}

{dlgtab:With controls and fixed effects}

{cmd:. longview y, time(t) treatvar(D) treatdatevar(treat_t) window(-4 6) controls(x1 x2) absorb(unitid) vce(cluster unitid#t)}

{dlgtab:Save the graph and add x-axis lines}

{cmd:. longview y, time(t) treatvar(D) treatdatevar(treat_t) window(-5 5) xlines(-3 3) title("Cumulative Effects") save(cumeffect.png)}

{title:Author}

{pstd}
{bf:Author}: Ritwiz Sarma, {browse "https://www.cafral.org.in": CAFRAL, Reserve Bank of India}. More info at the {browse "www.ritwizsarma.github.io": author's website}.

{title:Version}

{pstd}
Version 0.2

{title:Dependencies}

{pstd}
Requires:
  
- {cmd:reghdfe} (for estimation)

- {cmd:parmest} (for extracting coefficient tables)

{title:Also see}

{psee}
Related Stata commands:  
{help xtevent}, {help reghdfe}, {help parmest}

{pstd}
Note: Named {it:longview} for its focus on the long-run perspective (and after a Green Day song I enjoy).
