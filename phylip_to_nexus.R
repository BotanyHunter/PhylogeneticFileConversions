#  The following small script looks for all phylip files in a directory
#  and makes new files in the nexus format, placing them in a subdirectory named "nexus"
#
#  It uses ape's read/write functions.  ape must be installed on the machine
#
#  The first argument should be the directory name where the files reside
#  Additional arguments are:
#  -l path to R library.  This is useful if ape is not installed in R's default directory.
#  -w This argument allows the program to empty the nexus subdirectory of the data directory.


args <- commandArgs(TRUE)

# The first argument is the directory name.  Check that it exists
if( length(args) == 0 ){
  stop("Must provide name of directory with data as the first argument.")
}
directory = args[1]
if( !grepl("\\/$", directory )) directory = paste0(directory, "/")
if( !dir.exists(directory) ){
  stop(paste0("Directory,",directory," , not found.."))
} else {
  print(paste0("Using directory: ", directory))
}

libArgument = which(args=="-l")
if( length(libArgument)>0 ) {
  .libPaths(args[libArgument+1])
  print(paste0("Using R library directory: ", .libPaths()))
}

loadLibrary = tryCatch({
  library(ape)
  TRUE
}, warning = function(war) {
  print(paste("MY_WARNING:  ",war))
  return(TRUE)
}, error = function(e) {
  print("library ape not found.  If it is installed use -l argument to point to directory")
  return(FALSE)
})

if( loadLibrary == FALSE ) stop("library ape not installed. Execution cannot continue.")

# Get a list of files in the directory
extensionPattern = "\\.(phylip|phy)$"
filenamePattern = paste0(".*",extensionPattern)
myFiles = list.files(path=directory, pattern=filenamePattern)

if( length(myFiles) == 0 ){
  stop(paste0("No files found with extension", extensionPattern))
} else {
  paste0("Found ", length(myFiles), " files with extension ",extensionPattern,". Will attempt conversion to nexus")
}

#Create subdirectory to place nexus files.
targetDirectory = paste0(directory, "nexus/")
if( dir.exists(targetDirectory) ){
    overwriteArgument = which(args=="-w")
    if( length(overwriteArgument) > 0 ){
      #remove all files from directory
      res = file.remove(Sys.glob(paste0(targetDirectory,"*.*")))
    } else {
      stop(paste0("nexus subdirectory already exists in ",directory,". Set overwrite flag (-w) to overwrite"))
    }
} else {
  dir.create(targetDirectory)
}

#Loop through each file, read it in and write it out.
for( iF in 1:length(myFiles) ){
    print(paste0("Working on file ", iF," of ",length(myFiles),": ",myFiles[iF]))
    myData = read.dna(paste0(directory,myFiles[iF]), format="sequential")
    newFilename = paste0(targetDirectory, sub(extensionPattern, ".nex", myFiles[iF]))
    write.nexus.data(myData, newFilename)
}

#Check if user wants to force to UNIX type line feeds
libArgument = which(args=="-u")
if( length(libArgument)>0 ) {
    for( iF in 1:length(myFiles) ){
        newFilename = paste0(targetDirectory, sub(extensionPattern, ".nex", myFiles[iF]))
        print(paste0("Checking CRLF on file ", iF," of ",length(myFiles),": ",newFilename))
        input = file(newFilename, open = "r")
        output = file(paste0(newFilename,"x"), open="wb")
        while (length(oneLine <- readLines(input, n = 1, warn = FALSE)) > 0) {
            writeLines(oneLine, output, sep="\n")
        } 

        close(output)
        close(input)
        file.remove(newFilename)
        file.rename(paste0(newFilename,"x"), newFilename)
    }
}
  

print("Finished")



