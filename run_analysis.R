library(plyr)

test_X<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
test_Y<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
train_X<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
train_y<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")

subject<-rbind(subject_test,subject_train)
X<-rbind(test_X,train_X)
Y<-rbind(test_Y,train_y)

features<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
meanStd<-grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X<-X[,meanStd]

names(X)<-features[meanStd,2]
names(X)<-gsub("\\(|\\)","",names(X))
names(X)<-tolower(names(X))
activities<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
activities[,2]<-tolower(as.character(activities[,2]))
activities[,2]<-gsub("_","",activities[,2])
Y[,1]<-activities[Y[,1],2]

names(Y)<-"activity"
names(subject)<-"subject"
data<-cbind(subject,Y,X)

write.table(data,"./finalData.txt",row.names=FALSE)

N1<-length(unique(subject)[,1])
N2<-length(activities[,1])
N3<-length(names(data))

data2<-data[1:(N1*N2),]

S<-unique(subject)[,1]

row = 1
for (i in 1:N1) {
        for (j in 1:N2) {
                data2[row,1] = S[i]
                data2[row,2] = activities[j, 2]
                temp <- data[data$subject==i & data$activity==activities[j,2],]
                data2[row,3:N3] <- colMeans(temp[,3:N3])
                row=row+1
        }
}

write.table(data2,"finalData2.txt")
