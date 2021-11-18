
#install.packages("foreign")
library(foreign)

vreeland_repdata <- read.dta("/Users/christianbaehr/Desktop/550 paper/data/Vreeland_&_Dreher_2014_Replication_Files/Chapter 6/USaid_UNSC_selectorate_data_replication.dta")
#vreeland_repdata <- read.dta("/Users/christianbaehr/Desktop/550 paper/data/Vreeland_&_Dreher_2014_Replication_Files/Chapter 5/Chapter 5.dta")
vreeland_repdata <- vreeland_repdata[vreeland_repdata$worldbankcode!="", ]

#sort(unique(vreeland_repdata$worldbankcode))
#unique(dat$aclpname[which(!dat$recipients_iso3 %in% vreeland_repdata$worldbankcode)])

#names(dat)

################################################################################

aiddata <- read.csv("/Users/christianbaehr/Desktop/550 Paper/data/WorldBank_GeocodedResearchRelease_Level1_v1.4.2/data/level_1a.csv",
                    stringsAsFactors = F)

names(aiddata)

start <- as.Date(aiddata$start_actual_isodate)
end <- as.Date(aiddata$end_actual_isodate)

aiddata$project_time_days <- as.numeric(end-start)

aiddata$start_year <- substr(aiddata$start_actual_isodate, 1, 4)
aiddata$end_year <- substr(aiddata$end_actual_isodate, 1, 4)

#View(aiddata[1:1000,])
#unique(aiddata$recipients_iso3)

#test <- paste(aiddata$recipients_iso3, aiddata$recipients)
#cat(paste0(sort(unique(test)), "\n"))

aiddata <- aiddata[aiddata$recipients_iso3!="Unspecified", ]

aiddata <- aiddata[complete.cases(aiddata[, c("location_type_code", "total_commitments", "total_disbursements", "project_time_days")]), ]

aiddata_agg <- aggregate(aiddata[, c("location_type_code", "total_commitments", "total_disbursements", "project_time_days")], 
                         by=list(aiddata$recipients_iso3, aiddata$end_year, aiddata$recipients),
                         FUN = mean)

names(aiddata_agg)[c(1:3)] <- c("recipients_iso3", "end_year", "recipients")

aiddata_agg <- aiddata_agg[(!is.na(aiddata_agg$end_year) & aiddata_agg$end_year!="" & as.numeric(aiddata_agg$end_year)<=2021), ]

aiddata_agg <- aiddata_agg[aiddata_agg$recipients_iso3!="Unspecified", ]

aiddata_agg$recipients_iso3[aiddata_agg$recipients_iso3=="COD"] <- "COG"
aiddata_agg$recipients_iso3[aiddata_agg$recipients_iso3=="ROU"] <- "ROM"

names(aiddata_agg)[names(aiddata_agg)=="total_commitments"] <- "wb_total_commitments"
names(aiddata_agg)[names(aiddata_agg)=="total_disbursements"] <- "wb_total_disbursements"

###

# BUILD SECTORAL VARIABLES

# test <- sapply(aiddata$ad_sector_names, function(x) strsplit(x, split = "\\|"))
# 
# sort(unique(unlist(test)))
# 
# unique(aiddata$ad_sector_names)
# for(i in 1:nrow(aiddata_agg)) {
#   aiddata_agg$recipients_iso3
# }

#plot(aiddata_agg$end_year, aiddata_agg$total_disbursements)

################################################################################

china_data <- read.csv("/Users/christianbaehr/Desktop/550 paper/data/AidDatas_Global_Chinese_Development_Finance_Dataset_Version_2_0/AidDatasGlobalChineseDevelopmentFinanceDataset_v2.0.csv",
                       stringsAsFactors = F)

names(china_data)

#sort(unique(china_data$Recipient))
#sort(unique(unsc$aclpname))
#sort(unique(china_data$Recipient[!(china_data$Recipient %in% unsc$aclpname)]))

unique(china_data$Flow.Class)

china_data <- china_data[complete.cases(china_data[, c("Amount..Original.Currency.", "Amount..Constant.USD2017.", "Amount..Nominal.")]), ]

china_agg <- aggregate(china_data[, c("Amount..Original.Currency.", "Amount..Constant.USD2017.", "Amount..Nominal.")],
                       by=list(china_data$Recipient, china_data$Commitment.Year),
                       FUN = mean)

names(china_agg)
names(china_agg) <- c("country",
                      "year",
                      "chinese_finance_origcurrency",
                      "chinese_finance_usd2017",
                      "chinese_finance_nominal")

###

china_data_oda <- china_data[china_data$Flow.Class=="ODA-like", ]
china_agg_oda <- aggregate(china_data_oda[ , c("Amount..Original.Currency.", "Amount..Constant.USD2017.", "Amount..Nominal.")],
                       by=list(china_data_oda$Recipient, china_data_oda$Commitment.Year),
                       FUN = mean)
names(china_agg_oda) <- c("country",
                      "year",
                      "chinese_finance_origcurrency_oda",
                      "chinese_finance_usd2017_oda",
                      "chinese_finance_nominal_oda")

china_data_oof <- china_data[china_data$Flow.Class=="OOF-like", ]
china_agg_oof <- aggregate(china_data_oof[, c("Amount..Original.Currency.", "Amount..Constant.USD2017.", "Amount..Nominal.")],
                           by=list(china_data_oof$Recipient, china_data_oof$Commitment.Year),
                           FUN = mean)
names(china_agg_oof) <- c("country",
                          "year",
                          "chinese_finance_origcurrency_oof",
                          "chinese_finance_usd2017_oof",
                          "chinese_finance_nominal_oof")

china_data_vague <- china_data[china_data$Flow.Class=="Vague (Official Finance)", ]
china_agg_vague <- aggregate(china_data_vague[, c("Amount..Original.Currency.", "Amount..Constant.USD2017.", "Amount..Nominal.")],
                           by=list(china_data_vague$Recipient, china_data_vague$Commitment.Year),
                           FUN = mean)
names(china_agg_vague) <- c("country",
                          "year",
                          "chinese_finance_origcurrency_vague",
                          "chinese_finance_usd2017_vague",
                          "chinese_finance_nominal_vague")


################################################################################

library(readxl)
unsc <- read_xls("/Users/christianbaehr/Desktop/550 Paper/data/UNSCdata.xls", sheet = 2)
unsc <- data.frame(unsc)

#names(unsc)
#View(unsc[1:1000,])

#unsc$code[unsc$name=="Ethiopia"] <- "ETH"
#unsc$code[unsc$name=="Yemen"] <- "YEM"

unsc <- unsc[unsc$code!=".", ]

###

sum(aiddata_agg$recipients_iso3 %in% unsc$code)

sort(unique(aiddata_agg$recipients[!(aiddata_agg$recipients_iso3 %in% unsc$code)]))

unsc$merge_col <- paste(unsc$code, unsc$year)
aiddata_agg$merge_col <- paste(aiddata_agg$recipients_iso3, aiddata_agg$end_year)

dat <- merge(unsc, aiddata_agg, by="merge_col", all.x = T)

vreeland_repdata$merge_col <- paste(vreeland_repdata$worldbankcode, vreeland_repdata$year)
# vreeland replication data only contains 1996-2005 data
dat <- merge(dat, vreeland_repdata, by="merge_col", all.x = T)
dat$year <- dat$year.x
dat=dat[, !(names(dat) %in% c("year.y", "year.x"))]

###

# merge main dataset with Chinese finance

dat$merge_col2 <- paste(dat$aclpname, dat$year)
china_agg$merge_col2 <- paste(china_agg$country, china_agg$year)
china_agg_oda$merge_col2 <- paste(china_agg_oda$country, china_agg_oda$year)
china_agg_oof$merge_col2 <- paste(china_agg_oof$country, china_agg_oof$year)
china_agg_vague$merge_col2 <- paste(china_agg_vague$country, china_agg_vague$year)

dat2 <- merge(dat, china_agg, by="merge_col2", all = T)
dat2 <- merge(dat2, china_agg_oda, by="merge_col2", all = T)
dat2 <- merge(dat2, china_agg_oof, by="merge_col2", all = T)
dat2 <- merge(dat2, china_agg_vague, by="merge_col2", all = T)

################################################################################

# dat$unsc <- as.numeric(dat$unsc)
# 
# unsc_temp <- aggregate(x=dat[c("unsc")], by=list(dat$recipients_iso3), FUN = sum)
# unsc_temp$unsc <- (unsc_temp$unsc>0)*1
# dat$unsc_ever <- unlist(merge(dat, unsc_temp, by.x = "recipients_iso3", by.y = "Group.1")["unsc.y"])
# 
# rm(list = setdiff(ls(), "dat"))
# 
# library(stargazer)
# 
# hist(dat$project_time_days)
# hist(dat[dat$unsc==0, "project_time_days"])
# hist(dat[dat$unsc==1, "project_time_days"])
# 
# summary(dat[dat$unsc==0, "project_time_days"])
# summary(dat[dat$unsc==1, "project_time_days"])
# 
# hist(dat[dat$unsc==0 & dat$unsc_ever==1, "project_time_days"], xlim = c(0, 6000))
# hist(dat[dat$unsc==1 & dat$unsc_ever==1, "project_time_days"], xlim = c(0, 6000))
# 
# summary(dat[dat$unsc==0 & dat$unsc_ever==1, "project_time_days"])
# summary(dat[dat$unsc==1 & dat$unsc_ever==1, "project_time_days"])
# 
# summary(dat[, c("project_time_days", "unsc", "total_disbursements", "total_commitments")])
# 
# a=lm(project_time_days ~ unsc + total_disbursements + factor(year) + factor(recipients_iso3), data=dat)
# summary(a)
# 
# b=lm(project_time_days ~ unsc + total_commitments + factor(year) + factor(recipients_iso3), data=dat)
# summary(b)
# 
# ###
# 
# dat$total_commitments=as.numeric(dat$total_commitments)
# dat$total_disbursements=as.numeric(dat$total_disbursements)
# dat$unsc=as.numeric(dat$unsc)
# 
# stargazer(dat[, c("year", "unsc", "total_commitments", "total_disbursements")], 
#           type = "latex", omit.summary.stat = c("p25", "p75"))
# 
# 
# ################################################################################
# 
# a=lm(dat$total_disbursements ~ as.numeric(dat$unsc) + factor(dat$code) + factor(dat$year))
# summary(a)
# 
# plot(dat$year, dat$total_disbursements, xlab = "Year", ylab="Total Disbursements",
#      main = "World Bank disbursements over time")

################################################################################

summary(dat2$chinese_finance_usd2017)

plot(dat2$year.x, dat2$chinese_finance_usd2017)

lm(dat2$chinese_finance_usd2017 ~ dat2$unsc)
summary(lm(dat2$chinese_finance_usd2017 ~ dat2$unsc))

mod1 <- lm(chinese_finance_usd2017 ~ unsc, data = dat2)
mod2 <- lm(chinese_finance_usd2017 ~ unsc, data = dat2)

write.csv(dat2, "/Users/christianbaehr/Desktop/550 paper/data/processed_data.csv", row.names = F)

################################################################################

vreeland_repdata2 <- read.dta("/Users/christianbaehr/Desktop/550 paper/data/Vreeland_&_Dreher_2014_Replication_Files/Chapter 5/Chapter 5.dta")

vreeland_repdata2$merge_code3 <- paste(vreeland_repdata2$aclpcode, vreeland_repdata2$year)
dat2$merge_code3 <- paste(dat2$aclpcode, dat2$year.y)

dat3 <- merge(dat2, vreeland_repdata2, by="merge_code3", all.x = T)

write.csv(dat3, "/Users/christianbaehr/Desktop/550 paper/data/processed_data2.csv", row.names = F)

################################################################################

### NEW EFFORT

china_data <- read.csv("/Users/christianbaehr/Desktop/550 paper/data/AidDatas_Global_Chinese_Development_Finance_Dataset_Version_2_0/AidDatasGlobalChineseDevelopmentFinanceDataset_v2.0.csv",
                       stringsAsFactors = F)

names(china_data)

#sort(unique(china_data$Recipient))
#sort(unique(unsc$aclpname))
#sort(unique(china_data$Recipient[!(china_data$Recipient %in% unsc$aclpname)]))

unique(china_data$Flow.Class)

china_data <- china_data[complete.cases(china_data[, c("Amount..Original.Currency.", "Amount..Constant.USD2017.", "Amount..Nominal.")]), ]

china_agg <- aggregate(china_data[, c("Amount..Original.Currency.", "Amount..Constant.USD2017.", "Amount..Nominal.")],
                       by=list(china_data$Recipient, china_data$Commitment.Year),
                       FUN = mean)

names(china_agg)
names(china_agg) <- c("country",
                      "year",
                      "chinese_finance_origcurrency",
                      "chinese_finance_usd2017",
                      "chinese_finance_nominal")

###

china_data_oda <- china_data[china_data$Flow.Class=="ODA-like", ]
china_agg_oda <- aggregate(china_data_oda[ , c("Amount..Original.Currency.", "Amount..Constant.USD2017.", "Amount..Nominal.")],
                           by=list(china_data_oda$Recipient, china_data_oda$Commitment.Year),
                           FUN = mean)
names(china_agg_oda) <- c("country",
                          "year",
                          "chinese_finance_origcurrency_oda",
                          "chinese_finance_usd2017_oda",
                          "chinese_finance_nominal_oda")

china_data_oof <- china_data[china_data$Flow.Class=="OOF-like", ]
china_agg_oof <- aggregate(china_data_oof[, c("Amount..Original.Currency.", "Amount..Constant.USD2017.", "Amount..Nominal.")],
                           by=list(china_data_oof$Recipient, china_data_oof$Commitment.Year),
                           FUN = mean)
names(china_agg_oof) <- c("country",
                          "year",
                          "chinese_finance_origcurrency_oof",
                          "chinese_finance_usd2017_oof",
                          "chinese_finance_nominal_oof")

china_data_vague <- china_data[china_data$Flow.Class=="Vague (Official Finance)", ]
china_agg_vague <- aggregate(china_data_vague[, c("Amount..Original.Currency.", "Amount..Constant.USD2017.", "Amount..Nominal.")],
                             by=list(china_data_vague$Recipient, china_data_vague$Commitment.Year),
                             FUN = mean)
names(china_agg_vague) <- c("country",
                            "year",
                            "chinese_finance_origcurrency_vague",
                            "chinese_finance_usd2017_vague",
                            "chinese_finance_nominal_vague")


library(foreign)
vreeland_repdata2 <- read.dta("/Users/christianbaehr/Desktop/550 paper/data/Vreeland_&_Dreher_2014_Replication_Files/Chapter 5/Chapter 5.dta")

vreeland_repdata2$merge_code3 <- paste(tolower(vreeland_repdata2$aclpname), vreeland_repdata2$year)
china_agg$merge_code3 <- paste(tolower(china_agg$country), china_agg$year)
china_agg_oda$merge_code3 <- paste(tolower(china_agg_oda$country), china_agg_oda$year)
china_agg_oof$merge_code3 <- paste(tolower(china_agg_oof$country), china_agg_oof$year)
china_agg_vague$merge_code3 <- paste(tolower(china_agg_vague$country), china_agg_vague$year)



dat3 <- merge(china_agg, vreeland_repdata2, by="merge_code3", all.x = T)
dat3 <- merge(dat3, china_agg_oda, by="merge_code3", all.x = T)
dat3 <- merge(dat3, china_agg_oof, by="merge_code3", all.x = T)
dat3 <- merge(dat3, china_agg_vague, by="merge_code3", all.x = T)

library(readxl)
unsc <- read_xls("/Users/christianbaehr/Desktop/550 Paper/data/UNSCdata.xls", sheet = 2)
unsc <- data.frame(unsc)
unsc <- unsc[unsc$code!=".", ]

unsc$merge_code3 <- paste(tolower(unsc$aclpname), unsc$year)

names(unsc)[names(unsc)=="unsc"] <- "unsc_full"
unsc$unsc_full[is.na(unsc$unsc_full)] <- 0

dat3 <- merge(dat3, unsc[, c("unsc_full", "merge_code3")], all.x = T)

###

vdem <- read.csv("/Users/christianbaehr/Desktop/550 paper/data/Country_Year_V-Dem_Core_CSV_v11.1/V-Dem-CY-Core-v11.1.csv",
                 stringsAsFactors=F)

View(vdem[1:1000,])
View(dat3[1:1000, ])

vdem$merge_code3 <- paste(tolower(vdem$country_name), vdem$year)
vdem <- vdem[, c("merge_code3", "v2x_polyarchy")]


dat3 <- merge(dat3, vdem, by="merge_code3", all.x = T)

###

write.csv(dat3, "/Users/christianbaehr/Desktop/550 paper/data/processed_data2.csv", row.names = F)




