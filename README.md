# PhylogeneticFileConversions
Scripts used to convert between phylogenetic file types

## phylip_to_nexus.R
This is an R script that can be run from the command line.  It will find all files
in a directory with the extension ".phylip" and make new files in the nexus format.
The resulting files are placed into a subdirectory of the data directory.
The conversion uses the <b>ape</b> library
and the commands read.dna(format="sequential) and write.nexus.data.

This program requires both R and ape to be installed on the computer.

To execute from the command line type the following:

    RScript phylip_to_nexus.R ../datadirectory

There are two additional parameters that can be used:
<table style="width:100%">
<tr><td>-l <i>RLibraryDirectory</i></td>
  <td>If RScript does not automatically find the directory where ape is installed, this parameter can be
  used to force R to look at an alternative directory.  Unfortunately, version incompatibility seems to be 
      a frequent source of errors.</td>
 <tr>
 <tr><td>-w</td>
  <td>
  This argument is used alone and allows the program to <b>empty</b> and overwrite the <i>nexus/</i> directory if it pre-exists.
  </td>
 </tr>
 <tr><td>-u</td>
  <td>
  This argument is used alone and directs the program to output lines with unix type line endings.
  </td>
 </tr>
</table>

An example of the command using the extra parameters:

    RScript phylip_to_nexus.R ../data/ -l "c:/Users/userName/Documents/R/win-library/3.2" -w -u


  
