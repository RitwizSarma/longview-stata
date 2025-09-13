program define longview,
    // syntax
    syntax varlist(min=1) [if] [in], ///
        Time(name) TREATvar(name) TREATDATEvar(name) ///
        Window(numlist min=2 max=2 integer) ///
        [Controls(varlist) ABSORB(string) VCE(string) TITLE(string) XLINES(numlist) SAVE(string)]

    // parse inputs
    local depvar : word 1 of `varlist'
    
    local pre  : word 1 of `window'
    local post : word 2 of `window'

	di "longview v0.2"
	
    tempvar rel_t
    quietly gen `rel_t' = `time' - `treatdatevar' `if' `in'

	preserve
    // create event-time dummies
	quietly {
		
	forvalues k = -`pre' / `post' {
			if `k' != -1 {
				local varname = cond(`k' < 0, "D_m" + string(abs(`k')), "D" + string(`k'))
				gen `varname' = (`rel_t' == `k')
				replace `varname' = `treatvar' * `varname'
				label variable `varname' "`k'"
			}
		}
	}	
	
    // regression
    local rhs "D*"
    if "`controls'" != "" local rhs "`rhs' `controls'"

    local opts ""
    if "`absorb'" != "" local opts "`opts' absorb(`absorb')"
    if "`vce'"    != "" local opts "`opts' vce(`vce')"

    quietly reghdfe `depvar' `rhs' `if' `in', `opts'

    // saving matrices to compute cumulative SEs and CIs using e(V)
//     matrix b = e(b)
//     matrix V = e(V)

    tempfile coeffs
    quietly parmest, label list(parm label estimate min* max* p) saving("`coeffs'", replace)

    // prep for plotting
	quietly {
		use "`coeffs'", clear
		destring label, replace force
		drop if missing(label)
		sort label

		// cumulative estimates
		gen cum_est = sum(estimate)
		gen cum_min = sum(min95)
		gen cum_max = sum(max95)
	}
	
//	attempt to get varvoc matrix fixed SEs
//     gen cum_se = .
//     local prevlist
//     local k = 0
//     quietly {
//         foreach d of local allcoefs {
//             if substr("`d'",1,1)=="D" {
//                 local ++k
//                 // compute var of cumulative up to this dummy
//                 local cur = "`prevlist' `d'"
//                 matrix Vsub = V[colnumb(V,`cur'), colnumb(V,`cur')]
//                 matrix ones = J(`: word count `cur'',1,1)
//                 scalar var_cum = ones' * Vsub * ones
//                 replace cum_se = sqrt(var_cum) in `k'
//                 local prevlist `cur'
//             }
//         }
//     }
//
//     gen cum_min = cum_est - 1.96*cum_se
//     gen cum_max = cum_est + 1.96*cum_se

	local xline_cmd "xline(0, lpattern(shortdash) lcolor(red))"
	if "`xlines'" != "" {
		local xline_cmd "xline(0, lpattern(shortdash) lcolor(red)) xline(`xlines', lpattern(shortdash) lcolor(red%30))"
	}

	
    // graph
    twoway (rarea cum_min cum_max label, color(gs14%40)) ///
           (line cum_min label, lcolor(gs8) lpattern(dash)) ///
           (line cum_max label, lcolor(gs8) lpattern(dash)) ///
           (line cum_est label, lcolor(blue)), ///
           yline(0, lpattern(dash) lcolor(black)) ///
           `xline_cmd' ///
           xtitle("Event Time") ///
           ytitle("Cumulative Treatment Effect") ///
           title("`title'") legend(off)

    if "`save'" != "" {
        graph export "`save'", replace
    }
	
	restore
end
