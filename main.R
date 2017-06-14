library(rvest)
library(stringr)
# list = jsonlite::fromJSON("https://raw.githubusercontent.com/Lchiffon/cosx.org/aloglia/index.json")
# # URL = sub("cosx.org","cos.name",list$url)
# URL = list$url
# outputList = list()
# for(i in 1:length(URL)){
#   print(URL[i])
#   content = try(readLines(URL[i], encoding = 'UTF-8'))
#   writeLines(content, "tmp.html", useBytes = T)
#   tmpImgURL = read_html("tmp.html", encoding='UTF-8') %>% html_nodes("img") %>% html_attr('src') %>% 
#     grep("cos.name",.,value = T)
#   outputList = append(outputList, list(str = tmpImgURL))
# }
# 
# downloadURL = do.call(c, outputList) %>% unique %>% grep("https://cos.name/",.,value = T)
# fileNames = downloadURL %>% gsub("https://cos.name/","./",.)
# dirNames = sapply(fileNames, function(x){
#   out = strsplit(x,"/")[[1]]
#   n = length(out)
#   return(paste0(out[-n], collapse = "/"))
# })
# 
# # setwd("D:/git/uploads/")
# 
# link(".log")
# for(i in 1: length(downloadURL)){
#   print(downloadURL[i])
#   if(!dir.exists(dirNames[i]))
#     dir.create(dirNames[i],recursive = T)
#   download.file(downloadURL[i],fileNames[i],"curl")
# }
# link("")
# # 
# # 
# # Warning messages:
# #   1: In dir.create(dirNames[i], recursive = T) :
# #   cannot create dir 'https:\', reason 'Invalid argument'
# # 2: running command 'curl  "https://web.archive.org/web/20120602095612/https://cos.name/wp-content/uploads/2011/04/%E6%A8%A1%E6%8B%9Flars.png"  -o "https://web.archive.org/web/20120602095612/./wp-content/uploads/2011/04/%E6%A8%A1%E6%8B%9Flars.png"' had status 23 
# # 3: In download.file(downloadURL[i], fileNames[i], "curl") :
# # 下载退出状态不是零
# # 4: In dir.create(dirNames[i], recursive = T) :
# # cannot create dir 'https:\', reason 'Invalid argument'
# # 5: running command 'curl  "https://web.archive.org/web/20110521125938/https://cos.name/wp-content/uploads/2011/05/%E5%BB%BA%E6%A8%A1%E7%AD%94%E8%BE%A9-021-fixed.jpg"  -o "https://web.archive.org/web/20110521125938/./wp-content/uploads/2011/05/%E5%BB%BA%E6%A8%A1%E7%AD%94%E8%BE%A9-021-fixed.jpg"' had status 23 
# # 6: In download.file(downloadURL[i], fileNames[i], "curl") :
# # 下载退出状态不是零
# save(list, downloadURL, file = "local.Rdata")

setwd("../cosx.org/content/")
files = dir(recursive = T, full.names = T)

outList = list()
# outList2 = list()
for(file in files){
  print(file)
  tmpstr = readLines(file, encoding = 'UTF-8') %>% paste0(collapse='\n')
  tmp = str_extract_all(tmpstr,
                        "(?<=\\()https://cos.name/wp-content(\\w|\\+|%|@|（|）|—|\\_|\\-|\\.|/)+(?=(\\)| \"))")
  # tmp2 = str_extract_all(tmpstr,
  #                       "(?<=\\()https://cos.name/wp")
  # outList = append(outList, list(
  #                  data.frame(str=tmp[[1]],
  #                                file = rep(file,length(tmp[[1]])))
  #                  ))
  # outList2 = append(outList2, list( data.frame(str=tmp2[[1]],
  #                                       file = rep(file,length(tmp2[[1]])))))
  outList = append(outList, list(str=tmp[[1]]))
  # newstr = str_replace_all()
}

setwd("../../uploads")
# library(dplyr)
# downloadURL2 = do.call(rbind, outList) %>% group_by(file) %>% summarise(n=n())
# downloadURL3 = do.call(rbind, outList2) %>% group_by(file) %>% summarise(n=n())
# downloadURL2 %>% left_join(downloadURL3, 'file') %>% filter(n.x!=n.y) %>% View
downloadURL = do.call(c, outList) 

fileNames = downloadURL %>% gsub("https://cos.name/wp-content/uploads/","./",.) %>% 
  sapply(URLdecode) %>% iconv('UTF-8','UTF-8')
dirNames = sapply(fileNames, function(x){
  out = strsplit(x,"/")[[1]]
  n = length(out)
  return(paste0(out[-n], collapse = "/"))
})

# setwd("D:/git/uploads/")

sink("missing.log")
for(i in 1: length(downloadURL)){
  # print(downloadURL[i])
  if(!dir.exists(dirNames[i]))
    dir.create(dirNames[i],recursive = T)
  if(!file.exists(fileNames[i])){
    tryCatch({
      download.file(URLencode(downloadURL[i]), fileNames[i], "wininet", mode="wb")
    }, warning = function(e){
      if(grepl("404", e$message)){
        cat(paste0(downloadURL[i],",",fileNames[i],",404 warning\n"))
      } else {
        cat(paste0(downloadURL[i],",",fileNames[i],",other warning\n"))
      }
    }, error = function(e){
      cat(paste0(downloadURL[i],",",fileNames[i],",error\n"))
    }
    )
  }
}

