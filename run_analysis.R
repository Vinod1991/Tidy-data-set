
library(data.table)
library(lubridate)
library(reshape2)

f<-fread("./data/UCI HAR Dataset/features.txt")
names<-f$V2[grepl("mean",f$V2)|grepl("std",f$V2)]
row_nos<-f$V1[grepl("mean",f$V2)|grepl("std",f$V2)]


rx<-fread("./data/UCI HAR Dataset/test/X_test.txt",select = row_nos)
sx<-fread("./data/UCI HAR Dataset/train/X_train.txt",select = row_nos)
rs<-fread("./data/UCI HAR Dataset/test/subject_test.txt",col.names = "Subject_test")
ss<-fread("./data/UCI HAR Dataset/train/subject_train.txt",col.names = "Subject_test")
ry<-fread("./data/UCI HAR Dataset/test/y_test.txt",col.names = "Y_test")
sy<-fread("./data/UCI HAR Dataset/train/y_train.txt",col.names = "Y_test")

names(rx)<-names
names(sx)<-names

rm<-cbind(rs,ry,rx)
sm<-cbind(ss,sy,sx)

m<-merge(rm,sm,all=TRUE,by=c("Subject_test","Y_test",names))

m2<-melt.data.table(m,id.vars = c("Subject_test","Y_test"),measure.vars = names)

new_m2<-dcast(m2,Subject_test+Y_test~variable,mean)
print(new_m2)
