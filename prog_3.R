# ./UCI HAR Dataset/
# -> 1 Дані для об’єданння (функція cbind) з папки test
# містяться у файлах: subject_test.txt, y_test.txt, X_test.txt.

subject_data <- read.table("./UCI HAR Dataset/test/subject_test.txt")
y_data <- read.table("./UCI HAR Dataset/test/y_test.txt")
X_data <- read.table("./UCI HAR Dataset/test/X_test.txt")

combined_data <- cbind(subject_data, y_data, X_data)

# print(combined_data)

# -> 2 Дані для об”єданння (функція cbind) з папки train
# містяться у файлах: subject_train.txt, y_train.txt, X_train.txt,

subject_train_data <- read.table("./UCI HAR Dataset/train/subject_train.txt")
y_train_data <- read.table("./UCI HAR Dataset/train/y_train.txt")
X_train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")

combined_train_data <- cbind(subject_train_data, y_train_data, X_train_data)

# head(combined_train_data)

# -> 3 Об”єднати два фрейми даних з пунктів 1 і 2 функцією rbind.

combined_data_final <- rbind(combined_data, combined_train_data)

# head(combined_data_final)

# -> 4 Іменувати дані з файлів subject_*.txt і X_*.txt назвами
# "subject_train" та "test_labels" відповідно.
# Для усіх наступних стовпців імена
# одержати з файлу “./UCI HAR Dataset/features.txt”

features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, stringsAsFactors = FALSE)
colnames(features) <- c("feature_id", "feature_name")

colnames(subject_train_data) <- c("subject_train")
colnames(y_data) <- c("test_labels")

combined_data <- cbind(subject_train_data, y_data, X_data)
colnames(combined_data)[-c(1, 2)] <- features$feature_name

head(combined_data)

# -> 5 Виконати заміну символів в назвах стовпців наступними командами:
gsub("-", "_", names(all))
gsub("\\(\\)", "", names(all))

all - це фрейм даних
colnames(all) <- gsub("-", "_", colnames(all))
colnames(all) <- gsub("\\(\\)", "", colnames(all))

# -> 6 Із завантаженого фрейму даних одержати тільки дані з
# математичним очікуванням і середньоквадратичним відхиленням:
i<-grep("mean",names(all))
j<-grep("std",names(all))
all<-all[,sort(c(1,2,i,j))]

i <- grep("mean", names(all))
j <- grep("std", names(all))

selected_columns <- all[, sort(c(1, 2, i, j))]

head(selected_columns)

# -> 7  Вміст стовпця test_labels замінити на назви відповідних
# активностей відповідно до файлу
# “./UCI HAR Dataset/activity_labels.txt” (функція sub() )

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE,
    col.names = c("activity_id", "activity_name")
)

all$test_labels <- sub("([0-9]+)", function(match) {
    activity_labels$activity_name[as.numeric(match)]
}, all$test_labels)

head(all)

# -> 8 Створення незалежного набору даних зсереднім значенням по # кожній змінній за кожним видом діяльності
# i по кожному предмету (функція aggregate ). Приклад застосування # для одного стовпця:
# result<-aggregate( all[,3] ~ test_labels+subject_train, data = 
# all, FUN= "mean" )

variables_to_aggregate <- names(all)[3:ncol(all)] 

result <- aggregate(all[, variables_to_aggregate] ~ test_labels + subject_train, data = all, FUN = "mean")
