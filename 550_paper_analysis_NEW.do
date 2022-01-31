
* cd "/Users/christianbaehr/Desktop/550 paper/results"

global results "/Users/christianbaehr/Desktop/550 paper/results"


import delimited "/Users/christianbaehr/Desktop/550 paper/data/processeddata_NEW.csv", clear

egen any_loans2 = sum(all_amount_usd2017), by(aclpname)
gen any_loans3 = (any_loans2>0)

gen africa = (aclpname=="angola" | aclpname=="benin" | aclpname=="botswana" | aclpname=="burkina faso" | aclpname=="burundi" | aclpname=="cameroon" | aclpname=="cape verde" | aclpname=="central african republic" | aclpname=="chad" | aclpname=="comoros" | aclpname=="congo" | aclpname=="cote d'ivoire" | aclpname=="djibouti" | aclpname=="egypt, arab rep." | aclpname=="equatorial guinea" | aclpname=="eritrea" | aclpname=="ethiopia" | aclpname=="gabon" | aclpname=="gambia, the" | aclpname=="ghana" | aclpname=="guinea" | aclpname=="guinea-bissau" | aclpname=="kenya" | aclpname=="lesotho" | aclpname=="liberia" | aclpname=="libya" | aclpname=="madagascar" | aclpname=="malawi" | aclpname=="mali" | aclpname=="mauritania" | aclpname=="mauritius" | aclpname=="morocco" | aclpname=="mozambique" | aclpname=="namibia" | aclpname=="niger" | aclpname=="nigeria" | aclpname=="republic of yemen" | aclpname=="rwanda" | aclpname=="sao tome and principe" | aclpname=="senegal" | aclpname=="seychelles" | aclpname=="sierra leone" | aclpname=="somalia" | aclpname=="south africa" | aclpname=="sudan" | aclpname=="tanzania" | aclpname=="togo" | aclpname=="uganda" | aclpname=="zambia" | aclpname=="zimbabwe")

replace asdb_aidcommitments_constantusd = . if year>2013

*replace any_loans = "0" if any_loans=="NA"
*destring any_loans, replace

* keep if all_amount_usd2017 > 10000000000
* drop if all_amount_usd2017 > 10000000000
* drop if asdb_aidcommitments_constantusd > 1000000

replace all_amount_usd2017 = 1 if all_amount_usd2017==0
replace oda_amount_usd2017 = 1 if oda_amount_usd2017==0
replace oof_amount_usd2017 = 1 if oof_amount_usd2017==0
replace vague_amount_usd2017 = 1 if vague_amount_usd2017==0

gen log_all_amount_usd2017 = log(all_amount_usd2017)
gen log_oda_amount_usd2017 = log(oda_amount_usd2017)
gen log_oof_amount_usd2017 = log(oof_amount_usd2017)
gen log_vague_amount_usd2017 = log(vague_amount_usd2017)

gen temp=1

********************************************************************************


*su chinese_finance_usd2017_oof chinese_finance_usd2017_oda

label variable log_all_amount_usd2017 "log(All Flows)"
label variable log_oda_amount_usd2017 "log(ODA Flows)"
label variable log_oof_amount_usd2017 "log(OOF Flows)"
label variable log_vague_amount_usd2017 "log(Vague Flows)"
label variable unsc "UNSC Membership"
label variable pariah "Pariah state"
label variable war "War"
label variable rgdpl2_ln "ln (GDP per cap., PPP)"
label variable polity2new "Political Regime"
label variable milit_aid_ln "US Mil. Assistce (const. 2011 dol.)"


preserve
keep year log_all_amount_usd2017 log_oda_amount_usd2017 log_oof_amount_usd2017 log_vague_amount_usd2017 unsc pariah war rgdpl2_ln polity2new milit_aid_ln
outreg2 using "$results/summary_statistics_550paper.doc", replace tex sum(log)
rm "$results/summary_statistics_550paper.txt"
restore


twoway bar all_amount_usd2017 unsc

*egen annual_all_amount_usd2017 = mean(all_amount_usd2017), by(year)
egen annual_oda_amount_usd2017 = mean(oda_amount_usd2017), by(year)
egen annual_oof_amount_usd2017 = mean(oof_amount_usd2017), by(year)
egen annual_vague_amount_usd2017 = mean(vague_amount_usd2017), by(year)

preserve
keep if aclpname=="venezuela"
sort year
twoway (scatter annual_oda_amount_usd2017 year, mcolor(red%30)) (scatter annual_oof_amount_usd2017 year, mcolor(green%30)) (scatter annual_vague_amount_usd2017 year, mcolor(blue%30)), legend(order(1 "ODA-like Aid" 2 "OOF-like" 3 "Vague") rows(1)) xlabel(2000(5)2017) bgcolor(white) graphregion(color(white)) xtitle(Year) ytitle(Aid Amount)
restore



egen annual_vcf_treecover_mean = mean(vcf_treecover_mean), by(year)
egen annual_vcf_nontreeveg_mean = mean(vcf_nontreeveg_mean), by(year)
egen annual_vcf_nonveg_mean = mean(vcf_nonveg_mean), by(year)

* sort dataset by year for time-series graph
sort year

* time series graph of VCF outcomes
twoway (line annual_vcf_treecover_mean year) (line annual_vcf_nontreeveg_mean year) (line annual_vcf_nonveg_mean year), graphregion(color(white))
graph export "$results/timeseries_VCFoutcomes.png", replace


********************************************************************************

*reghdfe all_amount_usd2017 unsc, absorb(temp) cluster(code)
reghdfe all_amount_usd2017 unsc, absorb(temp)
reghdfe all_amount_usd2017 unsc, absorb(year)
reghdfe all_amount_usd2017 unsc, absorb(year code)
reghdfe all_amount_usd2017 unsc pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep, absorb(year code)

reghdfe log_all_amount_usd2017 unsc, absorb(temp)
reghdfe log_all_amount_usd2017 unsc, absorb(year)
reghdfe log_all_amount_usd2017 unsc, absorb(year code)
reghdfe log_all_amount_usd2017 unsc pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep, absorb(year code)

reghdfe log_oda_amount_usd2017 unsc, absorb(temp)
outreg2 using "$results/mainmodels_550.doc", replace noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", N, "Country FEs", N, "Regional Quartics", N)
reghdfe log_oda_amount_usd2017 unsc, absorb(year)
outreg2 using "$results/mainmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", N, "Regional Quartics", N)
reghdfe log_oda_amount_usd2017 unsc, absorb(year code)
outreg2 using "$results/mainmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", N)
reghdfe log_oda_amount_usd2017 unsc cotrendregrep* egytrendrep, absorb(year code)
outreg2 using "$results/mainmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", Y)
reghdfe log_oda_amount_usd2017 unsc pariah war rgdpl2_ln polity2new milit_aid_ln cotrendregrep* egytrendrep, absorb(year code)
outreg2 using "$results/mainmodels_550.doc", append noni nocons tex label drop(cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", Y)

reghdfe log_all_amount_usd2017 unsc, absorb(temp)
outreg2 using "$results/allmodels_550.doc", replace noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", N, "Country FEs", N, "Regional Quartics", N)
reghdfe log_all_amount_usd2017 unsc, absorb(year)
outreg2 using "$results/allmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", N, "Regional Quartics", N)
reghdfe log_all_amount_usd2017 unsc, absorb(year code)
outreg2 using "$results/allmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", N)

reghdfe log_all_amount_usd2017 unsc cotrendregrep* egytrendrep, absorb(year code)

reghdfe log_all_amount_usd2017 unsc pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep, absorb(year code)
outreg2 using "$results/allmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", Y)

***


reghdfe log_oof_amount_usd2017 unsc, absorb(temp)
outreg2 using "$results/mainmodels_550.doc", replace noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", N, "Country FEs", N, "Regional Quartics", N)
reghdfe log_oda_amount_usd2017 unsc, absorb(year)
outreg2 using "$results/mainmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", N, "Regional Quartics", N)
reghdfe log_oda_amount_usd2017 unsc, absorb(year code)
outreg2 using "$results/mainmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", N)
reghdfe log_oda_amount_usd2017 unsc cotrendregrep* egytrendrep, absorb(year code)
outreg2 using "$results/mainmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", Y)
reghdfe log_oof_amount_usd2017 unsc pariah war rgdpl2_ln polity2new milit_aid_ln cotrendregrep* egytrendrep, absorb(year code)
outreg2 using "$results/mainmodels_550.doc", append noni nocons tex label drop(cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", Y)




***

gen log_asdb = log(asdb_aidcommitments_constantusd + 1)
replace log_asdb = . if missing(asdb_aidcommitments_constantusd)

*Heterogeneity
reghdfe log_oda_amount_usd2017 unsc pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep, absorb(year code)
outreg2 using "$results/hetmodels_550.doc", replace noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", Y)

reghdfe log_oda_amount_usd2017 unsc pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep if africa, absorb(year code)
outreg2 using "$results/hetmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", Y)

reghdfe oda_nofloans unsc pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep, absorb(year code)
outreg2 using "$results/hetmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", Y)

reghdfe log_oda_amount_usd2017 c.unsc##c.log_asdb pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep, absorb(year code)
outreg2 using "$results/hetmodels_550.doc", append noni nocons tex label drop(ydumrep* cotrendregrep* egytrendrep) addtext("Year FEs", Y, "Country FEs", Y, "Regional Quartics", Y)


***



reghdfe log_all_amount_usd2017 unsc if africa, absorb(year)
reghdfe log_oda_amount_usd2017 unsc if africa, absorb(year)

reghdfe log_oof_amount_usd2017 unsc if africa, absorb(year)
reghdfe log_oof_amount_usd2017 unsc rgdpl2_ln polity2new if africa & year<=2013 & any_loans3, absorb(year)
reghdfe log_oof_amount_usd2017 unsc rgdpl2_ln polity2new if africa & year<=2013, absorb(year)


reghdfe all_amount_usd2017 c.unsc##c.asdb_aidcommitments_constantusd, absorb(year code)
*reghdfe all_amount_usd2017 c.unsc##c.asdb_aidcommitments_constantusd, cluster(year code) absorb(year code)
*reghdfe all_nofloans c.unsc##c.asdb_aidcommitments_constantusd if any_loans3==1, cluster(year code) absorb(year code)
reghdfe all_amount_usd2017 c.unsc##c.asdb_aidcommitments_constantusd, absorb(year code)

reghdfe all_amount_usd2017 unsc if africa, absorb(year code)
reghdfe all_amount_usd2017 unsc if !africa, absorb(year code)



xtile japanaid_q = asdb_aidcommitments_constantusd, nq(5)



reghdfe all_amount_usd2017 c.unsc##c.asdb_aidcommitments_constantusd pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep, absorb(year code)


xtile japanaid_q = japanaidcommitments_constantusd, nq(4)

egen any_japan_aid = sum()

reghdfe all_amount_usd2017 ibn.japanaid_q##c.unsc, absorb(temp)



reghdfe all_amount_usd2017 unsc if any_loans==1, absorb(year code)











