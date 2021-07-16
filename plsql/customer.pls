create or replace package customer is

  procedure add_customer(pv_cust_name in varchar2,
                         pv_email_id in varchar2);


  procedure update_customer_email(pv_cust_id in number 
                                 pv_cust_email in varchar2) ;


  procedure update_customer_name(pv_cust_id in number 
                                 pv_cust_name in varchar2);

end;

/

show errors;
