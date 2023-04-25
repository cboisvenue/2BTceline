
# 2BT project
# interpretation of results from April 18th from Tyler Rudolph
filename <- file.choose()
ABoVE_LCfreq <- readRDS(filename)

## looking at global trends at the ecozone level, slopes by age classes
lClasses <- unique(ABoVE_LCfreq$`Boreal Cordillera`$ecozone)
forestLC <- lClasses[grep("Forest", lClasses, ignore.case = TRUE, )]
woodland <- lClasses[grep("wood", lClasses, ignore.case = TRUE, )]

## our targetted ecozones are the first and the last three
# ls(ABoVE_LCfreq)
# [1] "Boreal Cordillera"  "Boreal Plain"       "Boreal Shield"
# [4] "Hudson Plain"       "Montane Cordillera" "Pacific Maritime"
# [7] "Prairie"            "Southern Arctic"    "Taiga Cordillera"
# [10] "Taiga Plain"        "Taiga Shield"

## plot the freq of foresLC and woodland by ecozone through the time series
## trying forestLC
library(data.table)
allEcoTable <- rbindlist(ABoVE_LCfreq, idcol = "zone")
## renaming b/c LC was names ecozone in the original table
setnames(allEcoTable,
         names(allEcoTable),
         new = c("ecozone", "layer", "year", "value", "landClass", "count" ))

# allEcoTable[landClass %in% forestLC,]
# allEcoTable[ecozone == Boreal Cordillera, landClass %in% forestLC,]

library(ggplot2)
## plot forestLC freq
## calculate the sum of all forestLC by ecozone and year

plotData1 <- allEcoTable[landClass %in% forestLC, .(forest = sum(count)), by = c("ecozone", "year")]
plotData1 <- plotData1[ecozone != "Southern Arctic",]
eco.forest <-
  ggplot(plotData1,
         aes(x = year, y = forest))
eco.forest +  geom_line(aes(group = ecozone, color = ecozone), linewidth = 1.5)

plotData2 <- allEcoTable[landClass %in% woodland, .(woodland = sum(count)), by = c("ecozone", "year")]
plotData2 <- plotData2[ecozone != "Southern Arctic",]
eco.woodland <-
  ggplot(plotData2,
         aes(x = year, y = woodland))
eco.woodland +  geom_line(aes(group = ecozone, color = ecozone), linewidth = 1.5)

## calculate the % of forested, the % of woodland
totPixEcoYear <- allEcoTable[,.(totalPix = sum(count)),
            by = c("ecozone", "year")]
keyCols <- c("ecozone", "year")
setkeyv(totPixEcoYear, keyCols)
setkeyv(plotData1, keyCols)
pctForested <- merge.data.table(plotData1, totPixEcoYear)
pctForested[, .(ecozone, year, pctFor = ((forest/totalPix)*100))]
setkeyv(plotData2, keyCols)
pctAllWood <- merge.data.table(plotData2, pctForested)
pctAllWood[, .(ecozone, year, pctWood = (((forest+woodland)/totalPix)*100))]

# plot percent forested over time by ecozones
plotPctWood <-
  ggplot(pctAllWood[, .(ecozone, year, pctWood = (((forest+woodland)/totalPix)*100))],
         aes(x = year, y = pctWood))
plotPctWood + geom_line(aes(group = ecozone, color = ecozone), linewidth = 1.5)
plotPctFor <- ggplot(pctForested[, .(ecozone, year, pctFor = ((forest/totalPix)*100))],
                     aes(x = year, y = pctFor))
plotPctFor + geom_line(aes(group = ecozone, color = ecozone), linewidth = 1.5)
