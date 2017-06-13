library(rvest)
list = jsonlite::fromJSON("https://raw.githubusercontent.com/Lchiffon/cosx.org/aloglia/index.json")
# URL = sub("cosx.org","cos.name",list$url)
URL = list$url
outputList = list()
for(i in 1:length(URL)){
  print(URL[i])
  content = try(readLines(URL[i], encoding = 'UTF-8'))
  writeLines(content, "tmp.html", useBytes = T)
  tmpImgURL = read_html("tmp.html", encoding='UTF-8') %>% html_nodes("img") %>% html_attr('src') %>% 
    grep("cos.name",.,value = T)
  outputList = append(outputList, list(str = tmpImgURL))
}

downloadURL = do.call(c, outputList) %>% unique %>% grep("https://cos.name/",.,value = T)
fileNames = downloadURL %>% gsub("https://cos.name/","./",.)
dirNames = sapply(fileNames, function(x){
  out = strsplit(x,"/")[[1]]
  n = length(out)
  return(paste0(out[-n], collapse = "/"))
})

# setwd("D:/git/uploads/")


for(i in 1: length(downloadURL)){
  print(downloadURL[i])
  if(!dir.exists(dirNames[i]))
    dir.create(dirNames[i],recursive = T)
  download.file(downloadURL[i],fileNames[i],"curl")
}
# 
# 
# Warning messages:
#   1: In dir.create(dirNames[i], recursive = T) :
#   cannot create dir 'https:\', reason 'Invalid argument'
# 2: running command 'curl  "https://web.archive.org/web/20120602095612/https://cos.name/wp-content/uploads/2011/04/%E6%A8%A1%E6%8B%9Flars.png"  -o "https://web.archive.org/web/20120602095612/./wp-content/uploads/2011/04/%E6%A8%A1%E6%8B%9Flars.png"' had status 23 
# 3: In download.file(downloadURL[i], fileNames[i], "curl") :
# 下载退出状态不是零
# 4: In dir.create(dirNames[i], recursive = T) :
# cannot create dir 'https:\', reason 'Invalid argument'
# 5: running command 'curl  "https://web.archive.org/web/20110521125938/https://cos.name/wp-content/uploads/2011/05/%E5%BB%BA%E6%A8%A1%E7%AD%94%E8%BE%A9-021-fixed.jpg"  -o "https://web.archive.org/web/20110521125938/./wp-content/uploads/2011/05/%E5%BB%BA%E6%A8%A1%E7%AD%94%E8%BE%A9-021-fixed.jpg"' had status 23 
# 6: In download.file(downloadURL[i], fileNames[i], "curl") :
# 下载退出状态不是零
save(list, downloadURL, file = "local.Rdata")
