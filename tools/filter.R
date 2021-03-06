#!/usr/bin/env Rscript

# tools to filter specific column

#get arguments from galaxy xlm command
args = commandArgs(trailingOnly=TRUE)
#args = c("tools/test-data/irisPlus.tabular", "garder", "6", "superieuresOuEgalesA", "laColonne", "1")

# import package
library(data.table, quietly = TRUE) # for data import
library(stringr, quietly = TRUE) # to work with string
library(dplyr, quietly = TRUE, warn.conflicts = FALSE)


# parameters translated
# add numeric / not numeric
negateMatching = args[2]
filterParameter = args[3]
filterType = args[4]
wholeLine = args[5]
columnsNumber = as.numeric(args[6])

#filterParameter = "é"
#print(filterParameter)

# import input file (tabular or csv)
input = data.frame(fread(args[1], encoding = "UTF-8"))




#select lines
if (wholeLine == "laColonne"){
  if (negateMatching == "garder"){
    if(filterType == "egaleA"){
      result <- dplyr::filter(input, str_detect(input[ ,columnsNumber], filterParameter))
    } else if (filterType == "exactementEgaleA"){
      result <- dplyr::filter(input, input[ ,columnsNumber] == filterParameter)
    } else if (filterType == "superieuresOuEgalesA"){
      result <- dplyr::filter(input, input[ ,columnsNumber] >= filterParameter)
    } else if (filterType == "inferieuresOuEgalesA"){
      result <- dplyr::filter(input, input[ ,columnsNumber] <= filterParameter)
    }
  } else {
    if(filterType == "egaleA"){
      result <- dplyr::filter(input, !str_detect(input[ ,columnsNumber], filterParameter))
    } else if (filterType == "exactementEgaleA"){
      result <- dplyr::filter(input, !input[ ,columnsNumber] == filterParameter)
    } else if (filterType == "superieuresOuEgalesA"){
      result <- dplyr::filter(input, !input[ ,columnsNumber] >= filterParameter)
    } else if (filterType == "inferieuresOuEgalesA"){
      result <- dplyr::filter(input, !input[ ,columnsNumber] <= filterParameter)
    }
  }
} else {
  if (negateMatching == "garder"){
    result <- dplyr::filter_all(input, any_vars(str_detect(., filterParameter)))
  } else {
    result <- input[apply(input, 1, function (x) !any(str_detect(x, filterParameter))), ]
  }
}
#write file
fwrite(result, "output-filter.csv", sep =",")
