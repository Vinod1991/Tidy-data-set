
library(data.table)
library(lubridate)
library(reshape2)

#fread is used for faster compilation, f indicates data table of values of features.txt
f<-fread("./data/UCI HAR Dataset/features.txt")

names<-f$V2[grepl("mean",f$V2)|grepl("std",f$V2)] #gives the words having mean or std in their formation  
row_nos<-f$V1[grepl("mean",f$V2)|grepl("std",f$V2)] #gives the different row no's for the above found words


rx<-fread("./data/UCI HAR Dataset/test/X_test.txt",select = row_nos)   #reads the selected columns from X_test.txt 
sx<-fread("./data/UCI HAR Dataset/train/X_train.txt",select = row_nos)  #reads the selected columns from X_train.txt

#reads the selected columns from subject_test.txt and provides the column name as Subject 
rs<-fread("./data/UCI HAR Dataset/test/subject_test.txt",col.names = "Subject")  

#reads the selected columns from subject_train.txt and provides the column name as Subject
ss<-fread("./data/UCI HAR Dataset/train/subject_train.txt",col.names = "Subject")  

ry<-fread("./data/UCI HAR Dataset/test/y_test.txt",col.names = "Activity")  #reads the selected columns from Y_test.txt 
sy<-fread("./data/UCI HAR Dataset/train/y_train.txt",col.names = "Activity")  #reads the selected columns from Y_train.txt

names(rx)<-names  #Provides names for columns in rx with one's we found in names in the start
names(sx)<-names  #Provides names for columns in sx with one's we found in names in the start

##Binds all rx and sx respectively with their Subject and Y values 
rm<-cbind(rs,ry,rx)
sm<-cbind(ss,sy,sx)

#merges both the data tables such that no repetations are seen or na values are listed in the resultant data table
m<-merge(rm,sm,all=TRUE,by=c("Subject","Activity",names)) 

#helps to bring all the values into a narrow data table having four columns that is - Subject,Activity,variable and values 
m2<-melt.data.table(m,id.vars = c("Subject","Activity"),measure.vars = names)

# Provides the mean value for the given different values,different columns and different activities 
new_m2<-dcast(m2,Subject+Activity~variable,mean) 

print(new_m2) #prints the desired data table
