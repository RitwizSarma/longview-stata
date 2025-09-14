# longview

**longview** is a Stata package for plotting **cumulative treatment effects** from event-study / Difference-in-Differences designs.  
It helps researchers move beyond period-by-period event-study coefficients and visualize the **total impact** of a treatment as it unfolds over time.


## Motivation

Event-study regressions are widely used to study the dynamics of treatment effects. However, they produce a sequence of coefficients that can be difficult to interpret, especially under staggered adoption. **longview** provides a simple way to track the *cumulative path of treatment effects*, highlighting whether they ramp up, stabilize, or decay.

This approach is particularly useful when the research question focuses on long-run consequences of a policy or intervention. It also offers an additional check on **parallel trends**, since pre-treatment coefficients should sum close to zero.

---

## Installation

You can install the package directly from GitHub:

```stata
net install longview, from("https://raw.githubusercontent.com/ritwizsarma/longview-stata/main/")
```

---

## Syntax

```stata
longview depvar [if] [in], time(varname) treatvar(varname) treatdatevar(varname) window(# #) ///
    [controls(varlist) absorb(varlist) vce(string) title(string) xlines(numlist) save(filename)]
```

## Examples

```stata
* Basic usage
longview outcome, time(year) treatvar(D) treatdatevar(treat_year) window(-5 5)

* With controls and fixed effects
longview y, time(t) treatvar(D) treatdatevar(treat_t) window(-4 6) ///
    controls(x1 x2) absorb(unitid) vce(cluster unitid)
```

## Dependencies

- `reghdfe` (for estimation)
- `parmest` (for extracting coefficient tables)

## Author

**Ritwiz Sarma**, Centre for Advanced Financial Research and Learning (CAFRAL), Reserve Bank of India

*The name `longview` reflects the package’s focus on long-run treatment effects — and also happens to be a Green Day song I enjoy.*
