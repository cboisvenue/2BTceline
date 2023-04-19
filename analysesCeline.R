
# 2BT project
# interpretation of results from April 18th from Tyler Rudolph
filename <- file.choose()
ABoVE_LCfreq <- readRDS(filename)

## looking at global trends at the ecozone level, slopes by age classes
lClasses <- unique(ABoVE_LCfreq$`Boreal Cordillera`$ecozone)
forestLC <- lClasses[grep("Forest", lClasses, ignore.case = TRUE, )]
woodland <- lClasses[grep("wood", lClasses, ignore.case = TRUE, )]

## our targetted ecozones are the first and the last three
ls(ABoVE_LCfreq)
[1] "Boreal Cordillera"  "Boreal Plain"       "Boreal Shield"     
[4] "Hudson Plain"       "Montane Cordillera" "Pacific Maritime"  
[7] "Prairie"            "Southern Arctic"    "Taiga Cordillera"  
[10] "Taiga Plain"        "Taiga Shield"  