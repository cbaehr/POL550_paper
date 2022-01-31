

aiddata <- read.csv("/Users/christianbaehr/Desktop/550 paper/data/AidDatas_Global_Chinese_Development_Finance_Dataset_Version_2_0/AidDatasGlobalChineseDevelopmentFinanceDataset_v2.0.csv",
                    stringsAsFactors = F)

japan_data <- read.csv("/Users/christianbaehr/Desktop/550 paper/data/AidDataCore_ResearchRelease_Level1_v3/AidDataCoreDonorRecipientYear_ResearchRelease_Level1_v3.1.csv",
                       stringsAsFactors = F)

aiddata <- aiddata[!is.na(aiddata$Amount..Constant.USD2017.), ]
test <- aggregate(aiddata$Amount..Constant.USD2017., by=list(aiddata$Commitment.Year), FUN=sum)

test2 <- aggregate(japan_data$commitment_amount_usd_constant_sum[japan_data$donor=="United States"],
          by=list(japan_data$year[japan_data$donor=="United States"]),
          FUN=sum)

sort(table(japan_data$donor))

a <- merge(test, test2, by="Group.1")

plot(a$Group.1, a$x.x)

plot(a$Group.1, a$x.y)
