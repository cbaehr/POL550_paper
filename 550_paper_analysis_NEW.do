
import delimited "/Users/christianbaehr/Desktop/550 paper/data/processeddata_NEW.csv", clear

su

twoway bar all_amount_usd2017 unsc

*replace any_loans = "0" if any_loans=="NA"
*destring any_loans, replace

gen temp=1

*reghdfe all_amount_usd2017 unsc, absorb(temp) cluster(code)
reghdfe all_amount_usd2017 unsc, absorb(temp)
reghdfe all_amount_usd2017 unsc, absorb(year)
reghdfe all_amount_usd2017 unsc, absorb(year code)
reghdfe all_amount_usd2017 unsc pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep, absorb(year code)


reghdfe all_amount_usd2017 c.unsc##c.asdb_aidcommitments_constantusd, absorb(year code)
reghdfe all_amount_usd2017 c.unsc##c.asdb_aidcommitments_constantusd, cluster(year code) absorb(year code)

reghdfe all_amount_usd2017 c.unsc##c.asdb_aidcommitments_constantusd pariah war rgdpl2_ln polity2new milit_aid_ln ydumrep* cotrendregrep* egytrendrep, absorb(year code)


xtile japanaid_q = japanaidcommitments_constantusd, nq(4)

egen any_japan_aid = sum()

reghdfe all_amount_usd2017 ibn.japanaid_q##c.unsc, absorb(temp)



reghdfe all_amount_usd2017 unsc if any_loans==1, absorb(year code)




