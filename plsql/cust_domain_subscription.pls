create or replace package cust_domain_subscription is 

  procedure add_cust_subscription(pn_cust_id in number,
                                  pn_prod_id in number,
                                  pn_domain_id in number,
                                  pn_duraion in number);


  procedure delete_cust_subscription(pn_cust_id in number,
                                      pn_prod_id in number,
                                      pn_domain_id in number);

end;

/

show errors;
