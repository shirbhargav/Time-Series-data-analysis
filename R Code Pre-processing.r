df = read.csv('Beach_Water_Quality_-_Automated_Sensors.csv')
//Extracting data only for ohio beach
df_ohio = df[df$Beach.Name == 'Ohio Street Beach']

//removing unnecessary columns
drops <- c("Beach.Name","Measurement.Timestamp.Label",'Measurement.ID')
df_ohio = df_ohio[ , !(names(df_ohio) %in% drops)]

//conversion of string to date-time format for timestams
df_ohio$Measurement.Timestamp <- AsDateTime(df_ohio$Measurement.Timestamp)

//sorting data based on time stamps
df_ohio = df_ohio[order(df_ohio$Measurement.Timestamp),]

//checking for missing values
sum(is.na(df_ohio$Transducer.Depth)) = 11890
df_ohio$Transducer.Depth <- NULL


//removing outliers from wave height and wave period by replacing with values from earlier day

df_ohio$Wave.Height[df_ohio$Wave.Height == -99999.992] <- NA NAdf_ohio$Wave.Period[df_ohio$Wave.Period == -1e+05] <- NA

test = df_ohio[is.na(df_ohio$Wave.Height) > 0,]

for (row in 1:nrow(test)) {
df_ohio[test[row,'index'],'Wave.Period'] <- df_ohio[test[row,'index']-24,'Wave.Period']
df_ohio[test[row,'index'],'Wave.Height'] <- df_ohio[test[row,'index']-24,'Wave.Height']
}



//exporting pre-processed dataset

Write.csv(‘ohio_beach_nm.csv’,rownames=FALSE)

