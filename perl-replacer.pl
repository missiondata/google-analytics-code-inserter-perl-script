#!/use/bin/perl -w
use strict;
use warnings;

# Instructions etc
# This is a short script to go through a directory of files and insert Google Analytics code
# It is set up to even take care of files with s p a c e s in the names!
# If you run it twice, it will not duplicate the GA code, as it checks if there is already code before the </head>
# Run this script using the following command line:
# find . -name "*.html" -print0 | xargs -0 perl perl-replacer.pl
# Easily make replacements in that command to look for different file extensions or insert the FULL path to the perl-replacer.pl script on your file system
# the -print0 and xargs -0 allow this script to work with files with s p a c e s in the names, see man find or man xargs for details
# This scripts github project can be found at 




#Google Analytics Javascript to insert into the page;
#Replace UA-XXXXXXX-XX and example.com with YOUR GA Site Code and Domain, or replace the whole block with what you copy from google.
my $gascript = <<ENDOFGA;
  <script type="text/javascript">
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-XXXXXXX-XX']);
    _gaq.push(['_setDomainName', 'example.com']);
    _gaq.push(['_trackPageview']);
    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
  </script>
</head>
ENDOFGA

#Lets keep track of how many insertions we do;
my $i = 0;

#Iterate through all of the files that are passed in from find . -name as command line options;
#We COULD use <> here, but there is really no reason not to make it readable;
for my $file (@ARGV) {
  #Print the file name so we can see something is happening;
  #Comment this out to make the program run faster, printing to the screen always slows us down!;
  print "$file\n";
  #Copy the file to a file with a .gabak extension in case we mess something up.
  #We can remove all of these files with the following command:
  #find . -name "*.gabak" -print0 | xargs -0 rm -f
  system("cp \"$file\" \"$file.gabak\"");
  #Open the file and read data
  #Die with grace if it fails
  open (INFILE, "<$file") or die "Can't open $file: $!\n";
  #Assigne the lines of the file to the @lines variable;
  my @lines = <INFILE>;
  #You had better close that file correctly!
  close INFILE;
  
  #Open same file for writing
  open (OUTFILE, ">$file") or die "Can't open $file: $!\n";
  #Variable to either do the replacement if true, or not if false;
  my $doreplacement = 1;
  #Walk through lines, putting into $_, and substitute 2nd away
  for ( @lines ) {
    #If we already have Google Analytics code installed before the </head> then don't insert the code and just re-write the rest of the file;
    if ($_ =~ m/_gaq/) {
      $doreplacement = 0;
    }
    #If we don't have existing Google Analytics code, go ahead and replace the </head> with our code (that includes another </head>)
    if($doreplacement == 1) {
      #If we do a replacement, increment our counter;
      if (s/<\/head>/$gascript/) {
       $i++;
      }
    }
    #Write our lines into the new file;
    print OUTFILE;
  }
  
  #Make sure to close the file!
  close OUTFILE;
}
#Print out a bit of finisher code saying how many replacements we did;
print "Finished with $i replacement(s)\n";

