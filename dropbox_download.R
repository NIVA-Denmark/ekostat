


# ------------------------- dropbox download function -------------------------------------



drop_auth <- function(new_user = FALSE,
                      key = "bvlvwy4kybn6xnf",
                      secret = "2u84bzckl88ewj9",
                      cache = TRUE,
                      rdstoken = NA) {
  
  # check if token file exists & use it
  if (new_user == FALSE &  !is.na(rdstoken)) {
    
    # read token or error
    if (file.exists(rdstoken)) {
      .dstate$token <- readRDS(rdstoken)
    } else {
      stop("token file not found")
    }
    
    # authenticate normally
  } else {
    
    # remove any cached token if new user
    if (new_user && file.exists(".httr-oauth")) {
      message("Removing old credentials...")
      file.remove(".httr-oauth")
    }
    
    # set dropbox oauth2 endpoints
    dropbox <- httr::oauth_endpoint(
      authorize = "https://www.dropbox.com/oauth2/authorize",
      access = "https://api.dropbox.com/oauth2/token"
    )
    
    # registered dropbox app's key & secret
    dropbox_app <- httr::oauth_app("dropbox", key, secret)
    
    # get the token
    dropbox_token <- httr::oauth2.0_token(dropbox, dropbox_app, cache = cache)
    
    # make sure we got a token
    if (!inherits(dropbox_token, "Token2.0")) {
      stop("something went wrong, try again")
    }
    
    # cache token in rdrop2 namespace
    .dstate$token <- dropbox_token
  }
}


#Create an OAuth application

db_app <- oauth_app(appname="dropbox",key="bvlvwy4kybn6xnf",secret="2u84bzckl88ewj9")

#Describe the OAuth endpoint

# Set request = NULL for OAuth2
# authorize is the url to send to send client for authorization
# access is the url used to exchange token
db_endpoint <- oauth_endpoint(request = NULL, 
                              authorize = 'https://www.dropbox.com/1/oauth2/authorize',
                              access = 'https://api.dropboxapi.com/1/oauth2/token')

#Generate an OAuth 2.0 token

# set cache = TRUE to cache token
db_token <- oauth2.0_token(endpoint = db_endpoint, app = db_app, cache = FALSE)
# will open your browser for authorization


token<-dropbox_token(,)

dropbox_token<-function(appkey,appsecret,cache=F){
  # set dropbox oauth2 endpoints
  dropbox <- httr::oauth_endpoint(
    authorize = "https://www.dropbox.com/oauth2/authorize",
    access = "https://api.dropbox.com/oauth2/token"
  )
  
  # registered dropbox app's key & secret
  dropbox_app <- httr::oauth_app("dropbox", appkey, appsecret)
  
  # get the token
  dropbox_token <- httr::oauth2.0_token(dropbox, dropbox_app, cache = cache)
  
  # make sure we got a token
  if (!inherits(dropbox_token, "Token2.0")) {
    stop("Error!")
  }
  
  return(dropbox_token)
}


dropbox_download<-function(dropboxfolder,localfolder,file,dropboxtoken,overwrite=T){
  url <- "https://content.dropboxapi.com/2/files/download"
  dropboxaccesstoken<-"tQnFerDRU8cAAAAAAACU58qVkRTr2EYdK_MsttFEYQ1kcOz0yc8ZMkhm1vMxOfim"
  path<-paste0(dropboxfolder,file)
  
  req <- httr::POST(
    url = url,
  #httr::config(token = dtoken)
  httr::add_headers("Authorization" = paste0("Bearer ",dropboxaccesstoken),
                    "Dropbox-API-Arg" = jsonlite::toJSON(
                      list(
                        path = path),
                      auto_unbox = TRUE
                      )),
  if (interactive()) httr::progress(),
  httr::write_disk(paste0(localfolder,file), overwrite)
  )

}

filelist<-c("LakeBenthicInvertebrates.csv",
            "LakeFish.csv",
            "LakeMacrophytes.csv",
            "LakePhytobenthos.csv",
            "LakePhytoplankton.csv",
            "LakeWQ.csv",
            "RiverBenthicInvertebrates.csv",
            "RiverFish.csv",
            "RiverPhytobenthos.csv",
            "RiverWQ.csv",
            "SE_WB.csv",
            "SE_County.csv",
            "SE_Municipality.csv"
            )

folderdropbox<-"/WATERS_tools/tables_for_waters_tool/Data tables for shiny/"
folderlocal <- "./data/dropbox/"

for(file in filelist){
  cat(paste0("downloading ",file,"\n"))
  rc <- dropbox_download(folderdropbox,folderlocal,file,dropboxtoken="")
  
}
#file<-filelist[1]

filelist<-c("DB_tables for data input to shinyapp.xlsx",
            "Structured tables for shinyapp and R.xlsx")
folderdropbox<-"/WATERS_tools/tables_for_waters_tool/"
folderlocal <- "./data/"

for(file in filelist){
  cat(paste0("downloading ",file,"\n"))
  rc <- dropbox_download(folderdropbox,folderlocal,file,dropboxtoken="")
}

