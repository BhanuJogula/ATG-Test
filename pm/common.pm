package Common;

use strict;
use Getopt::Long;
use DBI qw( :sql_types ); 
use Time::HiRes qw( gettimeofday tv_interval );
use IO::File;
use IO::Handle;
use Time::localtime;

use Exporter;
use vars qw($gDBH $log_fh $VERSION @ISA @EXPORT );
@ISA = ('Exporter');
$VERSION = '1.0';

@EXPORT = qw($gDBH  $log_fh &ErrorExit &CloseDBConnection &Init);



sub get_datetime {
  my $tm = localtime;
  my ($year, $month, $day) =
              ( $tm->year + 1900, ( $tm->mon ) + 1, $tm->mday );
  my ( $hour, $min, $sec ) = ( $tm->hour, $tm->min, $tm->sec );
  my $current_datetime =
  sprintf( "%4s%02s%02s%02s%02s%02s",
                     $year, $month, $day, $hour, $min, $sec);
  return $current_datetime;
}


# 
# function to create a log handle   
#
sub CreateLogHandle{
    # Parse the Log location env variable to get DB credentials   
    my $envLogLoc = $ENV{"LOG_LOCATION"};
    if (! defined $envLogLoc) {
        die ("ERROR: The environment variable LOG_LOCATION is not defined.. Cannot create any log file");
    }

    if (-r $envLogLoc)
    {
       my $timestamp = get_datetime();
       my $logfile_name = $envLogLoc."/email_notifications_".$timestamp.".log";
       $log_fh = new FileHandle("> $logfile_name"); 
    }
    else
    {
       die("ERROR: The log directory location mentioned doesn't exist \n");
    }
  
}

#
# function to connect to the database 
# 
sub ConnectToDB {

    # Parse the DATABASE env variable to get DB credentials   
    my $envDatabase = $ENV{"DATABASE"};
    if (! defined $envDatabase) {
        die ("ERROR: The environment variable DATABASE is not defined.. Cannot connect to Database");
    }
    my ($DBUser, $DBPass, $SID) = split (/\/|\@/,$envDatabase);
    if (! (defined $DBUser && defined $DBPass && defined $SID )) {
        die ('ERROR: The environment variable DATABASE is not properly defined in DBUser/DBPass@DBSID form'); 
    }

    $log_fh->print("Connect to database [$SID] using [$DBUser]");
    $gDBH = DBI->connect( "dbi:Oracle:".$SID, $DBUser, $DBPass ) 
            || die ( "ERROR: Unable to connect to databse [$DBI::errstr] ");
    $log_fh->print("Successfully Connected to Database");


  
    # Set the database connection parameters  
    $gDBH->{AutoCommit}    = 0;
    $gDBH->{RaiseError}    = 0; 
}

#
# Closing the database connection
#
sub CloseDBConnection
{
    my($func,$file,$line) = caller;
    $log_fh->print("$func,$file,$line -- join("", @_) \n"); 
    $gDBH->commit();
    $gDBH->disconnect if defined($gDBH); 
}

#
# Closing the database connection
#
sub ErrorExit
{
    my($func,$file,$line) = caller;
    $log_fh->print("$func,$file,$line -- join("", @_)\n"); 
    $gDBH->rollback();
    $gDBH->disconnect if defined($gDBH); 
    exit(1);
}

sub Init
{
   &CreateLogHandle();    
   &ConnectToDB;
}

1;
