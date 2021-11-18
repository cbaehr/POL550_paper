
import delimited "/Users/christianbaehr/Desktop/550 paper/data/processed_data.csv", clear



twoway bar chinese_finance_usd2017 unscy



replace chinese_finance_usd2017 = "." if chinese_finance_usd2017=="NA"
destring chinese_finance_usd2017, replace

gen temp=1

reghdfe chinese_finance_usd2017 unsc, cluster(recipients_iso3 year) absorb(temp)
est sto m1

reghdfe chinese_finance_usd2017 unsc, cluster(recipients_iso3 year) absorb(year)
est sto m2

reghdfe chinese_finance_usd2017 unsc, cluster(recipients_iso3 year) absorb(year recipients_iso3)
est sto m3

reghdfe chinese_finance_usd2017 unsc war, cluster(recipients_iso3 year) absorb(year recipients_iso3)

********************************************************************************

global results "/Users/christianbaehr/Desktop/550 paper/results"

import delimited "/Users/christianbaehr/Desktop/550 paper/data/processed_data2.csv", clear

gen temp=1

*replace chinese_finance_usd2017="." if chinese_finance_usd2017=="NA"
*destring chinese_finance_usd2017, replace

gen log_chinese_finance_usd2017 = log(chinese_finance_usd2017)

*replace unsc = "0" if unsc=="NA"
*destring unsc, replace
drop unsc
gen unsc=unsc_full
replace unsc = "0" if unsc=="NA"
destring unsc, replace

rename countryx recipients_iso3
drop year
gen year = yearx

*drop if year=="NA"
*destring year, replace


replace polity2new="." if polity2new=="NA"
destring polity2new, replace

replace chinese_finance_usd2017_oof="." if chinese_finance_usd2017_oof=="NA"
destring chinese_finance_usd2017_oof, replace

replace chinese_finance_usd2017_oda="." if chinese_finance_usd2017_oda=="NA"
destring chinese_finance_usd2017_oda, replace

replace chinese_finance_usd2017_vague="." if chinese_finance_usd2017_vague=="NA"
destring chinese_finance_usd2017_vague, replace

gen log_chinese_finance_usd2017_oda = log(chinese_finance_usd2017_oda)
gen log_chinese_finance_usd2017_oof = log(chinese_finance_usd2017_oof)
gen log_ch_finance_usd2017_vague = log(chinese_finance_usd2017_vague)

replace milit_aid_ln="." if milit_aid_ln=="NA"
destring milit_aid_ln, replace

replace rgdpl2_ln="." if rgdpl2_ln=="NA"
destring rgdpl2_ln, replace

replace war="." if war=="NA"
destring war, replace

replace pariah="." if pariah=="NA"
destring pariah, replace

replace egytrendrep="." if egytrendrep=="NA"
destring egytrendrep, replace

local varbases = "ydumrep1 ydumrep2 ydumrep3 ydumrep4 ydumrep5 ydumrep6 ydumrep7 ydumrep8 ydumrep9 ydumrep10 ydumrep11 ydumrep12 ydumrep13 ydumrep14 ydumrep15 ydumrep16 ydumrep17 ydumrep18 ydumrep19 ydumrep20 ydumrep21 ydumrep22 ydumrep23 ydumrep24 ydumrep25 ydumrep26 ydumrep27 ydumrep28 ydumrep29 ydumrep30 ydumrep31 ydumrep32 ydumrep33 ydumrep34 ydumrep35 ydumrep36 ydumrep37 ydumrep38 ydumrep39 ydumrep40 ydumrep41 ydumrep42 ydumrep43 ydumrep44 ydumrep45 ydumrep46 ydumrep47 ydumrep48 ydumrep49 ydumrep50 ydumrep51 ydumrep52 ydumrep53 ydumrep54 ydumrep55 ydumrep56 ydumrep57 ydumrep58 ydumrep59 ydumrep60 ydumrep61"

foreach b of local varbases {
	replace `b'="." if `b'=="NA"
	destring `b', replace
    *summ pref_`b'_suff
}

local varbases2 = "cotrendregrepeca cotrendregrep_sqeca cotrendregrep_cueca cotrendregrep_queca cotrendregrepeap cotrendregrep_sqeap cotrendregrep_cueap cotrendregrep_queap cotrendregrepssa cotrendregrep_sqssa cotrendregrep_cussa cotrendregrep_qussa cotrendregreplac cotrendregrep_sqlac cotrendregrep_culac cotrendregrep_qulac cotrendregrepoth cotrendregrep_sqoth cotrendregrep_cuoth cotrendregrep_quoth"

foreach b of local varbases2 {
	replace `b'="." if `b'=="NA"
	destring `b', replace
    *summ pref_`b'_suff
}

su chinese_finance_usd2017_oof chinese_finance_usd2017_oda

label variable log_chinese_finance_usd2017 "log(All Flows)"
label variable log_chinese_finance_usd2017_oda "log(ODA Flows)"
label variable log_chinese_finance_usd2017_oof "log(OOF Flows)"
label variable log_ch_finance_usd2017_vague "log(Vague Flows)"
label variable unsc "UNSC Membership"
label variable pariah "Pariah state"
label variable war "War"
label variable rgdpl2_ln "ln (GDP per cap., PPP)"
label variable polity2new "Political Regime"
label variable milit_aid_ln "US Mil. Assistce (const. 2011 dol.)"

replace v2x_polyarchy="." if v2x_polyarchy=="NA"
destring v2x_polyarchy, replace
su v2x_polyarchy



***

preserve
collapse (mean) chinese_finance_usd2017 chinese_finance_usd2017_oda chinese_finance_usd2017_oof chinese_finance_usd2017_vague, by(year)
bysort year: su year
twoway (line chinese_finance_usd2017_oda year) (line chinese_finance_usd2017_oof year) (line chinese_finance_usd2017_vague year) if !missing(chinese_finance_usd2017), legend(label(1 "ODA Flows") label(2 "OOF Flows") label(3 "Vague Flows")) title("Chinese Official Finance, 2000-2017")
graph export "$results/chinaaid_timeseries.png"
restore

preserve
collapse (mean) chinese_finance_usd2017 chinese_finance_usd2017_oda chinese_finance_usd2017_oof chinese_finance_usd2017_vague, by(unsc) 
graph bar chinese_finance_usd2017, over(unsc) ytitle("All flows") b1title("UNSC Member") name(g1)
graph bar chinese_finance_usd2017_oda, over(unsc) ytitle("ODA flows") b1title("UNSC Member") name(g2)
graph bar chinese_finance_usd2017_oof, over(unsc) ytitle("OOF flows") b1title("UNSC Member") name(g3)
graph bar chinese_finance_usd2017_vague, over(unsc) ytitle("Vague flows") b1title("UNSC Member") name(g4)
restore

graph combine g1 g2 g3 g4, title("Chinese Official Finance by UNSC Membership, 2000-17")
graph export "$results/chinaaid_barplot.png"


preserve
keep year log_chinese_finance_usd2017 log_chinese_finance_usd2017_oda log_chinese_finance_usd2017_oof log_ch_finance_usd2017_vague unsc pariah war rgdpl2_ln polity2new milit_aid_ln
outreg2 using "$results/summary_statistics_550paper.doc", replace tex sum(log)
rm "$results/summary_statistics_550paper.txt"
restore


***

reghdfe log_chinese_finance_usd2017 unsc, cluster(recipients_iso3 year) absorb(temp)
est sto c1
outreg2 using "$results/mainmodels_550.doc", replace noni nocons tex label addtext("Year FEs", N, "Country FEs", N, "Regional Quartics", N) 

reghdfe log_chinese_finance_usd2017 unsc, cluster(recipients_iso3 year) absorb(year)
est sto c2
outreg2 using "$results/mainmodels_550.doc", append noni nocons tex label addtext("Year FEs", Y, "Country FEs", N, "Regional Quartics", N) 


reghdfe log_chinese_finance_usd2017 unsc, cluster(recipients_iso3 year) absorb(recipients_iso3 year)
est sto c3
outreg2 using "$results/mainmodels_550.doc", append noni nocons tex label addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", N) 


reghdfe log_chinese_finance_usd2017 unsc pariah war rgdpl2_ln polity2new milit_aid_ln , cluster(recipients_iso3 year) absorb(recipients_iso3 year)
est sto c4
outreg2 using "$results/mainmodels_550.doc", append noni nocons tex label addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", N)

reghdfe log_chinese_finance_usd2017 unsc pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep, cluster(recipients_iso3 year) absorb(recipients_iso3 year)
est sto c5
outreg2 using "$results/mainmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", Y) 


***

reghdfe log_chinese_finance_usd2017_oda unsc, cluster(recipients_iso3 year) absorb(temp)
est sto d1
outreg2 using "$results/odamodels_550.doc", replace noni nocons tex label addtext("Year FEs", N, "Country FEs", N, "Regional Quartics", N) 


reghdfe log_chinese_finance_usd2017_oda unsc, cluster(recipients_iso3 year) absorb(year)
est sto d2
outreg2 using "$results/odamodels_550.doc", append noni nocons tex label addtext("Year FEs", Y, "Country FEs", N, "Regional Quartics", N) 


reghdfe log_chinese_finance_usd2017_oda unsc, cluster(recipients_iso3 year) absorb(recipients_iso3 year)
est sto d3
outreg2 using "$results/odamodels_550.doc", append noni nocons tex label addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", N) 


reghdfe log_chinese_finance_usd2017_oda unsc pariah war rgdpl2_ln polity2new milit_aid_ln , cluster(recipients_iso3 year) absorb(recipients_iso3 year)
est sto d4
outreg2 using "$results/odamodels_550.doc", append noni nocons tex label addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", N) 


reghdfe log_chinese_finance_usd2017_oda unsc pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep, cluster(recipients_iso3 year) absorb(recipients_iso3 year)
est sto d5
outreg2 using "$results/odamodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", Y) 


***


reghdfe log_chinese_finance_usd2017_oof unsc, cluster(recipients_iso3 year) absorb(temp)
est sto e1
outreg2 using "$results/oofmodels_550.doc", replace noni nocons tex label addtext("Year FEs", N, "Country FEs", N, "Regional Quartics", N) 


reghdfe log_chinese_finance_usd2017_oof unsc, cluster(recipients_iso3 year) absorb(year)
est sto e2
outreg2 using "$results/oofmodels_550.doc", append noni nocons tex label addtext("Year FEs", Y, "Country FEs", N, "Regional Quartics", N) 


reghdfe log_chinese_finance_usd2017_oof unsc, cluster(recipients_iso3 year) absorb(recipients_iso3 year)
est sto e3
outreg2 using "$results/oofmodels_550.doc", append noni nocons tex label addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", N) 


reghdfe log_chinese_finance_usd2017_oof unsc pariah war rgdpl2_ln polity2new milit_aid_ln , cluster(recipients_iso3 year) absorb(recipients_iso3 year)
est sto e4
outreg2 using "$results/oofmodels_550.doc", append noni nocons tex label addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", N) 


reghdfe log_chinese_finance_usd2017_oof unsc pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep, cluster(recipients_iso3 year) absorb(recipients_iso3 year)
est sto e5
outreg2 using "$results/oofmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", Y) 

***


reghdfe log_ch_finance_usd2017_vague unsc, cluster(recipients_iso3 year) absorb(temp)
est sto e1
outreg2 using "$results/vaguemodels_550.doc", replace noni nocons tex label addtext("Year FEs", N, "Country FEs", N, "Regional Quartics", N) 


reghdfe log_ch_finance_usd2017_vague unsc, cluster(recipients_iso3 year) absorb(year)
est sto e2
outreg2 using "$results/vaguemodels_550.doc", append noni nocons tex label addtext("Year FEs", Y, "Country FEs", N, "Regional Quartics", N) 

reghdfe log_ch_finance_usd2017_vague unsc, cluster(recipients_iso3 year) absorb(recipients_iso3 year)
est sto e3
outreg2 using "$results/vaguemodels_550.doc", append noni nocons tex label addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", N) 


reghdfe log_ch_finance_usd2017_vague unsc pariah war rgdpl2_ln polity2new milit_aid_ln , cluster(recipients_iso3 year) absorb(recipients_iso3 year)
est sto e4
outreg2 using "$results/vaguemodels_550.doc", append noni nocons tex label addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", N) 


reghdfe log_ch_finance_usd2017_vague unsc pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep, cluster(recipients_iso3 year) absorb(recipients_iso3 year)
est sto e5
outreg2 using "$results/vaguemodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", Y) 

***

xtile v2x_polyarchy_q = v2x_polyarchy, nq(5)

reghdfe log_ch_finance_usd2017 ibn.v2x_polyarchy_q#c.unsc, cluster(recipients_iso3 year) absorb(recipients_iso3 year)
est sto f1

coefplot f1, keep(*.v2x_polyarchy_q#c.unsc) vertical yline(0) graphregion(color(white)) bgcolor(white) xtitle("Level of democracy") ytitle("Effect on Chinese aid") title("Treatment effect by level of democracy") 
*saving("$results/baseline_ndvi", replace)


reghdfe ndvi_mean ibn.q_baseline_hansen#c.completed_road, absorb(year id) cluster(project_id year)
est sto h6

coefplot h6, keep(*.q_baseline_hansen#c.completed_road) vertical yline(0) rename(1.q_baseline_hansen#c.completed_road=1st 2.q_baseline_hansen#c.completed_road=2nd 3.q_baseline_hansen#c.completed_road=3rd 4.q_baseline_hansen#c.completed_road=4th 5.q_baseline_hansen#c.completed_road=5th) graphregion(color(white)) bgcolor(white) xtitle("Baseline tree cover quintile (Hansen)") ytitle("Effect on NDVI") title("NDVI TE by baseline tree cover") saving("$results/baseline_ndvi", replace)





















