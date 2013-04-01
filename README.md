Instructions etc
 This is a short script to go through a directory of files and insert Google Analytics code
 It is set up to even take care of files with s p a c e s in the names!
 If you run it twice, it will not duplicate the GA code, as it checks if there is already code before the </head>
 Run this script using the following command line:
 find . -name "*.html" -print0 | xargs -0 perl perl-replacer.pl
 Easily make replacements in that command to look for different file extensions or insert the FULL path to the perl-replacer.pl script on your file system
 the -print0 and xargs -0 allow this script to work with files with s p a c e s in the names, see man find or man xargs for details
 This scripts github project can be found at https://github.com/missiondata/google-analytics-code-inserter-perl-script
 
 This script could very easily be used for other types of mass replacements where the thing to be replaced is a single word or line, and the replacement
 is multiple lines of text.  
 
