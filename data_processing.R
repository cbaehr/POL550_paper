
aiddata <- read.csv("/Users/christianbaehr/Desktop/550 paper/data/AidDatas_Global_Chinese_Development_Finance_Dataset_Version_2_0/AidDatasGlobalChineseDevelopmentFinanceDataset_v2.0.csv",
                    stringsAsFactors = F)

names(aiddata)

drop_recipients <- c("Africa, regional", "America, regional", "Asia, regional", "Europe, regional", "Middle East, regional", "Multi-Region", "Oceania, regional")
aiddata <- aiddata[!(aiddata$Recipient %in% drop_recipients), ]

aiddata$Recipient <- tolower(aiddata$Recipient)
sort(unique(aiddata$Recipient))

aiddata$Recipient[aiddata$Recipient=="antigua and barbuda" ] <- "antigua"
aiddata$Recipient[aiddata$Recipient=="bahamas"  ] <- "bahamas, the"
aiddata$Recipient[aiddata$Recipient=="bosnia and herzegovina"  ] <- "bosnia-herzegovina"
aiddata$Recipient[aiddata$Recipient=="brunei darussalam"  ] <- "brunei"
aiddata$Recipient[aiddata$Recipient=="cabo verde"  ] <- "cape verde"
aiddata$Recipient[aiddata$Recipient=="democratic people's republic of korea"  ] <- "korea, south (rep.)"
aiddata$Recipient[aiddata$Recipient=="democratic republic of the congo"  ] <- "congo"
aiddata$Recipient[aiddata$Recipient=="egypt"  ] <- "egypt, arab rep."
aiddata$Recipient[aiddata$Recipient=="gambia"  ] <- "gambia, the"
aiddata$Recipient[aiddata$Recipient=="iran"  ] <- "iran, islamic rep."
aiddata$Recipient[aiddata$Recipient=="kyrgyz republic"  ] <- "kyrgyzstan"
aiddata$Recipient[aiddata$Recipient=="lao people's democratic republic"  ] <- "laos pdr"
aiddata$Recipient[aiddata$Recipient=="maldives"  ] <- "maldive islands"
aiddata$Recipient[aiddata$Recipient=="micronesia"  ] <- "micronesia, federated states of"
aiddata$Recipient[aiddata$Recipient=="north macedonia"  ] <- "macedonia"
aiddata$Recipient[aiddata$Recipient=="saint lucia"  ] <- "st. lucia"
aiddata$Recipient[aiddata$Recipient=="samoa"  ] <- "western samoa"
aiddata$Recipient[aiddata$Recipient=="viet nam"  ] <- "vietnam"
aiddata$Recipient[aiddata$Recipient=="yemen"  ] <- "republic of yemen"


aiddata$country_year <- paste(aiddata$Recipient, aiddata$Commitment.Year)

aiddata$Amount..Constant.USD2017.[is.na(aiddata$Amount..Constant.USD2017.)] <- 0
aiddata$project <- 1

aiddata_cy_all <- merge(aggregate(aiddata[, c("Amount..Constant.USD2017.")], by=list(aiddata$country_year), FUN=sum), 
                         aggregate(aiddata[, c("project")], by=list(aiddata$country_year), FUN=sum),
                         by="Group.1",
                         all = T)
names(aiddata_cy_all) <- c("country_year", "all_amount_usd2017", "all_nofloans")

aiddata_cy_oda <- merge(aggregate(aiddata[aiddata$Flow.Class=="ODA-like", c("Amount..Constant.USD2017.")], by=list(aiddata$country_year[aiddata$Flow.Class=="ODA-like"]), FUN=sum), 
                         aggregate(aiddata[aiddata$Flow.Class=="ODA-like", c("project")], by=list(aiddata$country_year[aiddata$Flow.Class=="ODA-like"]), FUN=sum),
                         by="Group.1",
                         all = T)
names(aiddata_cy_oda) <- c("country_year", "oda_amount_usd2017", "oda_nofloans")

aiddata_cy_oof <- merge(aggregate(aiddata[aiddata$Flow.Class=="OOF-like", c("Amount..Constant.USD2017.")], by=list(aiddata$country_year[aiddata$Flow.Class=="OOF-like"]), FUN=sum), 
                        aggregate(aiddata[aiddata$Flow.Class=="OOF-like", c("project")], by=list(aiddata$country_year[aiddata$Flow.Class=="OOF-like"]), FUN=sum),
                        by="Group.1",
                        all = T)
names(aiddata_cy_oof) <- c("country_year", "oof_amount_usd2017", "oof_nofloans")

aiddata_cy_vague <- merge(aggregate(aiddata[aiddata$Flow.Class=="Vague (Official Finance)", c("Amount..Constant.USD2017.")], by=list(aiddata$country_year[aiddata$Flow.Class=="Vague (Official Finance)"]), FUN=sum), 
                        aggregate(aiddata[aiddata$Flow.Class=="Vague (Official Finance)", c("project")], by=list(aiddata$country_year[aiddata$Flow.Class=="Vague (Official Finance)"]), FUN=sum),
                        by="Group.1",
                        all = T)
names(aiddata_cy_vague) <- c("country_year", "vague_amount_usd2017", "vague_nofloans")

aiddata_cy_merge <- merge(aiddata_cy_all, aiddata_cy_oda, by="country_year", all = T)
aiddata_cy_merge <- merge(aiddata_cy_merge, aiddata_cy_oof, by="country_year", all = T)
aiddata_cy_merge <- merge(aiddata_cy_merge, aiddata_cy_vague, by="country_year", all = T)

aiddata_cy_merge$any_loans <- 1

################################################################################

japan_data <- read.csv("/Users/christianbaehr/Desktop/550 paper/data/AidDataCore_ResearchRelease_Level1_v3/AidDataCoreDonorRecipientYear_ResearchRelease_Level1_v3.1.csv",
                       stringsAsFactors = F)

japan_data$year[japan_data$year==9999] <- NA

#japan_data <- japan_data[japan_data$donor=="Japan", ]
japan_data <- japan_data[japan_data$donor=="Asian Development Bank (ASDB)", ]

#japan_data$project <- 1

japan_data$recipient <- tolower(japan_data$recipient)

sort(unique(japan_data$recipient[!(japan_data$recipient %in% unsc$aclpname)]))

japan_data$recipient[japan_data$recipient=="antigua & barbuda"] <- "antigua"
japan_data$recipient[japan_data$recipient=="bahamas"] <- "bahamas, the"
japan_data$recipient[japan_data$recipient=="congo, republic of"] <- "congo"
japan_data$recipient[japan_data$recipient=="cote d`ivoire"] <- "cote d'ivoire"
japan_data$recipient[japan_data$recipient=="egypt"] <- "egypt, arab rep."
japan_data$recipient[japan_data$recipient=="gambia"] <- "gambia, the"
japan_data$recipient[japan_data$recipient=="iran"] <- "iran, islamic rep."
japan_data$recipient[japan_data$recipient=="korea"] <- "korea, south (rep.)"
japan_data$recipient[japan_data$recipient=="kyrgyz republic"] <- "kyrgyzstan"
japan_data$recipient[japan_data$recipient=="laos"] <- "laos pdr"
japan_data$recipient[japan_data$recipient=="macedonia, fyr"] <- "macedonia"
japan_data$recipient[japan_data$recipient=="maldives"] <- "maldive islands"
japan_data$recipient[japan_data$recipient=="sao tome & principe"] <- "sao tome and principe"
japan_data$recipient[japan_data$recipient=="st. kitts & nevis"] <- "st. kitts and nevis"
japan_data$recipient[japan_data$recipient=="syrian arab republic"] <- "syria"
japan_data$recipient[japan_data$recipient=="trinidad & tobago"] <- "trinidad and tobago"
japan_data$recipient[japan_data$recipient=="viet nam"] <- "vietnam"
japan_data$recipient[japan_data$recipient=="yemen"] <- "republic of yemen"

japan_data$country_year <- paste(japan_data$recipient, japan_data$year)

# japan_cy_all <- merge(aggregate(japan_data[, c("commitment_amount_usd_constant_sum")], by=list(japan_data$country_year), FUN=sum),
#                       aggregate(japan_data[, c("project")], by=list(japan_data$country_year), FUN=sum),
#                       by="Group.1",
#                       all = T)

names(japan_data)[names(japan_data)=="commitment_amount_usd_constant_sum"] <- "asdb_aidcommitments_constantusd"

################################################################################

library(readxl)
unsc <- read_xls("/Users/christianbaehr/Desktop/550 paper/data/UNSCdata.xls", sheet = 2)
unsc <- unsc[unsc$year>=2000 & unsc$year<=2017, ]
unsc <- unsc[unsc$code!=".", ]

unsc$aclpname <- tolower(unsc$aclpname)
sort(unique(unsc$aclpname))

unsc <- unsc[unsc$aclpname!="ethiopia", ]
unsc$aclpname[unsc$aclpname=="ethiopia2"] <- "ethiopia"
unsc <- unsc[!(unsc$aclpname %in% c("yugoslavia2", "zaire", "western samoa", "swaziland", "korea, north (dem. rep.)")), ]

#sort(unique((aiddata$Recipient[!(aiddata$Recipient %in% unsc$aclpname)])))
#sort(unique((unsc$aclpname[!(unsc$aclpname %in% aiddata$Recipient)])))

unsc$country_year <- paste(unsc$aclpname, unsc$year)

################################################################################

library(haven)
#vreeland_repdata <- read_dta("/Users/christianbaehr/Desktop/550 paper/data/Vreeland_&_Dreher_2014_Replication_Files/Chapter 6/USaid_UNSC_selectorate_data_replication.dta")
#vreeland_repdata <- vreeland_repdata[vreeland_repdata$worldbankcode!="", ]

vreeland_repdata <- read_dta("/Users/christianbaehr/Desktop/550 paper/data/Vreeland_&_Dreher_2014_Replication_Files/Chapter 5/Chapter 5.dta")
vreeland_repdata <- data.frame(vreeland_repdata)

vreeland_repdata$aclpname <- tolower(vreeland_repdata$aclpname)

#vreeland_repdata$name[vreeland_repdata$name=="antigua and barbuda"] <- "antigua"
#vreeland_repdata$name[vreeland_repdata$name=="bosnia and herzegovina"] <- "bosnia-herzegovina"
#vreeland_repdata$name[vreeland_repdata$name=="congo, rep."] <- "congo"
#vreeland_repdata$name[vreeland_repdata$name=="korea, rep."] <- "korea, south (rep.)"
#vreeland_repdata$name[vreeland_repdata$name=="lao pdr"] <- "laos pdr"
#vreeland_repdata$name[vreeland_repdata$name=="macedonia, fyr"] <- "macedonia"
#vreeland_repdata$name[vreeland_repdata$name=="maldives"] <- "maldive islands"
#vreeland_repdata$name[vreeland_repdata$name=="micronesia, fed. sts."] <- "micronesia, federated states of"
vreeland_repdata$aclpname[vreeland_repdata$aclpname=="ethiopia2"] <- "ethiopia"
#vreeland_repdata$aclpname[vreeland_repdata$aclpname=="russian federation"] <- "russia"
#vreeland_repdata$aclpname[vreeland_repdata$aclpname=="western samoa"] <- "western samoa"
#vreeland_repdata$name[vreeland_repdata$name=="st. vincent and the grenadines"] <- "st. vincent"
#vreeland_repdata$name[vreeland_repdata$name=="venezuela, rb"] <- "venezuela"
#vreeland_repdata$name[vreeland_repdata$name=="yemen, rep."] <- "republic of yemen"
#vreeland_repdata$name[vreeland_repdata$name=="kyrgyz republic"] <- "kyrgyzstan"

sort(unique(vreeland_repdata$aclpname[!(vreeland_repdata$aclpname %in% full_data$aclpname)]))

vreeland_repdata$country_year <- paste(vreeland_repdata$aclpname, vreeland_repdata$year)

keep_cols <- c("country_year", "pariah", "war", "rgdpl2_ln", "polity2new", "milit_aid_ln",
               grep("ydumREP", names(vreeland_repdata), value=T),
               grep("cotrendreg", names(vreeland_repdata), value=T),
               "egytrendREP")

vreeland_repdata <- vreeland_repdata[, keep_cols]



################################################################################

full_data <- merge(aiddata_cy_merge, unsc, by="country_year", all = T)
full_data <- merge(full_data, japan_data[, c("asdb_aidcommitments_constantusd", "country_year")], by="country_year", all.x = T)
full_data <- merge(full_data, vreeland_repdata, by="country_year", all.x = T)

aid_cols <- c("all_amount_usd2017",
              "all_nofloans", 
              "oda_amount_usd2017", 
              "oda_nofloans", 
              "oof_amount_usd2017", 
              "oof_nofloans", 
              "vague_amount_usd2017", 
              "vague_nofloans",
              "asdb_aidcommitments_constantusd")

full_data[, aid_cols] <- apply(full_data[, aid_cols], 2, function(x) ifelse(is.na(x), 0, x))
full_data$asdb_aidcommitments_constantusd[full_data$year>2013] <- "."

full_data$code[full_data$aclpname=="andorra"] <- "AND"
full_data$code[full_data$aclpname=="romania"] <- "ROU"

full_data <- full_data[!is.na(full_data$year), ]

full_data <- apply(full_data, 2, function(x) ifelse(is.na(x), ".", x))

write.csv(full_data, "/Users/christianbaehr/Desktop/550 paper/data/processeddata_NEW.csv", row.names = F)

################################################################################

library(sf)

gadm <- st_read("/Users/christianbaehr/Desktop/550 paper/data/gadm36_0/gadm36_0.shp",
                stringsAsFactors=F)

full_data <- data.frame(full_data)

unique(full_data$aclpname[!(full_data$code %in% gadm$GID_0)])

sort(unique(gadm$NAME_0))
gadm$GID_0[gadm$NAME_0=="Andorra"]
gadm$GID_0[gadm$NAME_0=="Romania"]

#library(reshape)
#full_data_wide <- reshape(full_data, idvar="aclpcode", timevar="year", v.names="all_amount_usd2017", direction="wide")

#full_data_wide <- aggregate(as.numeric(full_data$all_amount_usd2017), by=list(full_data$code), FUN = sum)
full_data_wide <- aggregate(as.numeric(full_data$unsc), by=list(full_data$code), FUN = sum)

gis_out <- merge(full_data_wide, gadm, by.x = "Group.1", by.y = "GID_0", all.y = T)

gis_out_sf <- st_as_sf(gis_out)

gis_out_sf$x <- ifelse(is.na(gis_out_sf$x), 0, gis_out_sf$x)

permanent <- c("USA", "FRA", "GBR", "RUS", "CHN")

gis_out_sf$permanent <- ifelse(gis_out_sf$Group.1 %in% permanent, 1, 0)

write_sf(gis_out_sf, "/Users/christianbaehr/Desktop/aid_figure/unsc_years.shp")

###

full_data_wide <- aggregate(as.numeric(full_data$all_amount_usd2017), by=list(full_data$code), FUN = sum)

gis_out <- merge(full_data_wide, gadm, by.x = "Group.1", by.y = "GID_0", all.y = T)

gis_out_sf <- st_as_sf(gis_out)

gis_out_sf$x <- ifelse(is.na(gis_out_sf$x), 0, gis_out_sf$x)

#permanent <- c("USA", "FRA", "GBR", "RUS", "CHN")

#gis_out_sf$permanent <- ifelse(gis_out_sf$Group.1 %in% permanent, 1, 0)

write_sf(gis_out_sf, "/Users/christianbaehr/Desktop/aid_figure/aid_distribution.shp")


