# convert data 2019-0-02 so that it fits
# name gets replaces by ID
# We need topics, advisers and student preferences

df<- read.csv("./data_2019_09_02/teachers.csv", sep=",", 
              stringsAsFactors = FALSE)

# edited advisers manually

advisers <- read.csv("./data_2019_09_02/advisers.csv", sep=";", 
                     stringsAsFactors = FALSE)

#nr;ID;scr_lang;wg_lang;docent;full_text
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

df<- read.csv("./data_2019_09_02/preferences.csv", sep=",", 
              stringsAsFactors = FALSE)
topics2 <- as.data.frame(matrix(0, nrow=nrow(df), ncol=9))
names(topics2) <- paste0("topic_", 1:9)
d1<- unique(df$Thesis_write_language)
d1<- d1[order(d1)]; d1T <- c("NL", "EN", "VN", "VE")
d2<- unique(paste0(df$Dutch_wg, df$Englis_wg))
d2T<- c("", "NL", "EN")
d3<- unique(df$Track); d3T <- c("F", "D", "F", "D")
student_preferences <- data.frame(
  nr= 1:nrow(df), 
  ID= df$Studentnr,
  topics2, 
  scr_lang=  d1T[match(df$Thesis_write_language, d1)],
  wg_lang = d2T[match(paste0(df$Dutch_wg, df$Englis_wg), d2)],
  track= d3T[match(df$Track, d3)],
  stringsAsFactors = FALSE
)

# finally the preferences. Turn the table inside out
df[25, "Choice8"]<- 4
df[30, "Choice9"]<- 8
for ( i in 1:nrow(df)) {
  indx= as.integer(substring(df[i, 2:10],1,1))
  student_preferences[i, 2+indx] <- (9:1)
}