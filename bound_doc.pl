#
# bound_doc.pl
# Created 04/07/99 by Jim Sedlacek x58759
# Note: Need to keep ^M on end of each line
#

#HEADER
use Win32::Process;
use lib "s:\\perl\\rwlib\\";
require "regedit.pl";

# Check for Netscape Temp Directory (may not be same as %TEMP% environment variable)
@environment = &RegisterGetValues("HKEY_CURRENT_USER/Software/Netscape/Netscape Navigator/Main","Temp Directory");
$tempdir=$environment[2];

# If Netscape Temp Directory registry not set, get %TEMP% environment variable
if ($tempdir eq "") {
   $tempdir=$ENV{TEMP};
}

# Check for WinZip execution directory
@environment = &RegisterGetValues("HKEY_CLASSES_ROOT/WinZip/shell/open/command","Default");
$winzipdir=$environment[2];
$num = index($winzipdir,"winzip32.exe ");
if ($num > -1) {
   $num = $num + 12;
   $winzip = substr($winzipdir,0,$num);
} else {
   $winzip = $winzipdir;
}

# Now, process the downloaded files
chdir ($tempdir) || die "Can not cd to $tempdir";
unlink ("getsht.tar");
rename ("getsht.pdm","getsht.tar") || print "Can not rename getsht.pdm\n";
$dosdir = $tempdir;
$dosdir =~ tr/\\/\\\\/;
system ("$winzip -min -e -o $dosdir\\getsht.tar $dosdir\\ ");
system ("s:\\perl\\bin\\perl.exe runit.pl");
exit(0);
