# convert data 2019-09-06 so that it fits
# name gets replaces by ID
# We need topics, advisers and student preferences
if (FALSE){ # correct previous data frame
  these_students<- read.csv("./data_2019_09_06/tmp.csv", sep=",", 
                stringsAsFactors = FALSE)
  df<- read.csv("./data_2019_09_02/preferences.csv", sep=",", 
                stringsAsFactors = FALSE)
  df<- df[! df$Studentnr  %in% c(2002339, 2011116), ]
  write.csv(df, "./data_2019_09_06/prefs.csv",  
            row.names = FALSE)
}

# again -------------------------------------------
# edited advisers manually
advisers <- read.csv("./data_2019_09_06/advisers.csv", sep=";", 
                     stringsAsFactors = FALSE)

# copied teachers tab in xls to csv
df<- read.csv("./data_2019_09_06/teachers.csv", sep=",", 
              stringsAsFactors = FALSE)

# This is really a topics table
# nr;ID;scr_lang;wg_lang;docent;full_text
topics <- data.frame(nr=1:9,
                     ID= substr(df$Topic, 1, 21), 
                     scr_lang=  c("EN", "NL", "")[
                       match(df$Language, c("English", "Dutch", "Both"))],
                     wg_lang=c("EN", "EN", rep("",6), "EN"), 
                     docent= df$Teacher_ID-100,
                     full_text= df$Topic, 
                     track= c("D", "F", "")[
                       match(df$Program, c("Developmental", "Forensic", "Both"))],
                     
                     stringsAsFactors = FALSE
)

## --------- student preferences 

df<- read.csv("./data_2019_09_06/prefs.csv", sep=",", 
              stringsAsFactors = FALSE)
topics2 <- as.data.frame(matrix(0, nrow=nrow(df), ncol=9))
names(topics2) <- paste0("topic_", 1:9)
d1<- unique(df$Thesis_write_language)
d1<- d1[order(d1)]; d1T <- c("NL", "EN", "VN", "VE")
d2<- unique(paste0(df$Dutch_wg, df$Englis_wg))
d2T<- c("", "NL", "EN")
d3<- unique(df$Track); d3T <- c("FE", "DN", "FN", "DE")
student_preferences <- data.frame(
  nr= 1:nrow(df), 
  ID= df$Studentnr,
  topics2, 
  scr_lang=  d1T[match(df$Thesis_write_language, d1)],
  wg_lang = d2T[match(paste0(df$Dutch_wg, df$Englis_wg), d2)],
  track= d3T[match(df$Track, d3)],
  stringsAsFactors = FALSE
)

for ( i in 1:nrow(df)) {
  indx= as.integer(substring(df[i, 2:10],1,1))
  student_preferences[i, 2+indx] <- (9:1)
}

# ------ trying to make the rules consistent
# ------ "english tracks are only allowed to write in english analysis"
change1 <- student_preferences$nr[student_preferences$wg_lang != "EN" &
                         student_preferences$track %in% c("FE", "DE")]
student_preferences$wg_lang[change1] <- "EN"

# # ------- "only-lamguage for wg and scr cannot conflict"
change2 <- student_preferences$nr[student_preferences$scr_lang == "EN" &
                                    student_preferences$wg_lang == "NL"]
change3 <- student_preferences$nr[student_preferences$scr_lang == "NL" &
                                    student_preferences$wg_lang == "EN"]
change4 <- student_preferences$nr[student_preferences$scr_lang == "VN" &
                                    student_preferences$wg_lang == "EN"]
student_preferences$wg_lang[change4] <- ""
change5 <- student_preferences$nr[student_preferences$scr_lang == "VE" &
                                    student_preferences$wg_lang == "NL"]
student_preferences$wg_lang[change5] <- ""
# student 2009735 cant do number 9
changes6 <- student_preferences$nr[student_preferences$ID == 2009735]
student_preferences$topic_9[changes6] <- -100
# ------ Remove language from track code
student_preferences$track<- substring(student_preferences$track, 1, 1)
