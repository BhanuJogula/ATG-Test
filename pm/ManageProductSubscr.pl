use ICDCommon;
use strict;  

my $self;

&parse_args(); 

&Init();  

&Process_request();

#
# Processing the request
#
sub Process_request
{ 
  if ($self->{action} eq "VIEW") 
  {
      &View_subscriptions(); 
  }
  elsif ($self->{action} eq "REMOVE")
  {
     &Remove_subscriptions();
  }
  else
  {
     &Add_subscriptions();
  }
}

sub Add_subscriptions
{
  my $sth = $gDBH->prepare("begin add_cust_subscription(:in1,:in2,:in3,:in4); end;");
  $sth->bind_param("in1",$self->{customer_id});
  $sth->bind_param("in2",$self->{product_id});
  $sth->bind_param("in3",$self->{domain_id});
  $sth->bind_param("in3",$self->{duration});
  $sth->execute(); 

  $log_fh->print("Added the subscription details for $self->{customer_id} , $self->{product_id}".
                 " $self->{domain_id} and $self->{duration} \n");
}

sub Remove_subscriptions
{
  my $sth = $gDBH->prepare("begin remove_cust_subscription(:in1,:in2,:in3); end;");
  $sth->bind_param("in1",$self->{customer_id});
  $sth->bind_param("in2",$self->{product_id});
  $sth->bind_param("in3",$self->{domain_id}); 
  $sth->execute(); 

  $log_fh->print("Added the subscription details for $self->{customer_id} , $self->{product_id}".
                 " and $self->{domain_id}\n");
}

sub View_subscriptions
{
   my ($customer_id,$product_name,$domain_name,$email_date);
   
   my $subSql = qq{
                        select distinct cds.customer_id, pr.product_name, d.domain_name, cdn.email_date
                        from CUST_DOMAIN_NOTIFICATIONS cdn, cust_domain_subscriptions cds, products pr,   
                             domains d   
                        where cdn.email_date >= sysdate 
                        and   cds. cust_sub_id = cdn.cust_sub_id
                        and   pr.product_id = cds.product_id
                        and   d.domain_id = cds.domain_id   
                        ORDER BY email_date 
                   };

    my $sth = $gDBH->prepare($subSql)
        || die( "unable to prepare the sql for [$subSql] error [$DBI::errstr]");

    $sth->bind_columns(\$customer_id,\$product_name,\$domain_name,\$email_date);

    $sth->execute()
        || die( "unable to execute the sql for [$subSql] error [$DBI::errstr]");

    # Fetching the records and storing it in a hash
    while ($sth->fetch())
    {
         $log_fh->print("$customer_id\t$product_name\t$domain_name\t$email_date");
    }
    $sth -> finish();

    # Checking are there any records in the hash or not
    if ($rec_count == 0)
    {
        die( "No records found in the table CUST_DOMAIN_NOTIFICATIONS \n");
    }
    else
    {
       $log_fh->print("Collected all the EMAIL schedules : \n");
    }

}


 
sub usage {
  print STDOUT <<ENDOFUSAGE
  Usage  : perl ManageProductSubscr.pl  -action=add/remove/view -customerId=<customer Id> -prodId=<product_id> -domainId=<domain_id> -duration=<duration>

ENDOFUSAGE
}

sub parse_args {
  my $ra_argv     = $_[0];
  my $prop_value  = '';
  my ($customer_id, $prod_id, $domain_id, $duration);

  for ( my $i=0 ; $i<scalar(@$ra_argv) ; $i++ ) {
      my $arg = $$ra_argv[$i];
      if ($arg =~ /^-h(elp)?/) {
          usage();
          exit(0);
      } elsif ($arg =~ /^-action/) {
          $i++;
          $prop_value   = $$ra_argv[$i];
          $prop_value =~ s/^\s+|\s+$//g;
          if ((! defined $prop_value || $prop_value eq "") ||
             (uc($prop_value) ne "ADD" && uc($prop_value) ne "REMOVE" 
              && uc($prop_value) ne "VIEW")
          {
              print "ERROR: action parameter is mandatory in order to process the information \n";
              exit(0);
          }
          $self->{action} = uc($prop_value);
      } elsif ($arg =~ /^-customerId/) {
          $i++;
          $prop_value   = $$ra_argv[$i];
          $prop_value =~ s/^\s+|\s+$//g;
          $customer_id = $prop_value; 
      } elsif ($arg =~ /^-prodId/) {
          $i++;
          $prop_value   = $$ra_argv[$i];
          $prop_value =~ s/^\s+|\s+$//g;
           
          $prod_id = $prop_value;
      } elsif ($arg =~ /^-domainId/) {
          $i++;
          $prop_value   = $$ra_argv[$i];
          $prop_value =~ s/^\s+|\s+$//g;
           
          $domain_id = $prop_value;
      } elsif ($arg =~ /^-duration/) {
          $i++;
          $prop_value   = $$ra_argv[$i];
          $prop_value =~ s/^\s+|\s+$//g;
           
          $duration = $prop_value;
      }
  }
  
  if ($self->{action} eq "VIEW") 
  {
     return;
  }

  if ($self->{action} eq "REMOVE")
  {
     if ((! defined $customer_id) || (! defined $prod_id) || (! defined $domain_id))
     {
        print "ERROR: Customer, product and Domain information is mandatory to ".
              " delete the subscription \n";
        exit(0);
     }

     $self->{customer_id} = $customer_id;
     $self->{product_id} = $prod_id;
     $self->{domain_id} = $domain_id;
  }
  else
  {
      if ((! defined $customer_id) || (! defined $prod_id) || (! defined $domain_id) ||
          (! defined $duration))
      {
        print "ERROR: Customer, product and Domain and duration information is mandatory to ".
              " add the subscription \n";
        exit(0);
      }
      $self->{customer_id} = $customer_id;
      $self->{product_id} = $prod_id;
      $self->{domain_id} = $domain_id;
      $self->{duration} = $duration; 
  }
}