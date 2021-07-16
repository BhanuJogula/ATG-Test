create or replace package body customer is
--
-- Copyright (c) 2020 by Oracle Corporation. All Rights Reserved.
--
--

  procedure add_customer(pv_cust_name in varchar2,
                         pv_email_id in varchar2)
   is

   begin

      insert into customers(customer_id, customer_name, pv_email_id, start_date,last_updated_date)
        values(customers_s.nextval, pv_cust_name, pv_email_id, sysdate, sysdate);


   exceptions
      when others then
           raise_application_error(-10001, 'Not able to add the customer information');

   end;


  procedure update_customer_name(pv_cust_id in number 
                                 pv_cust_name in varchar2) is
    is


    begin

       update customers
       set customer_name = pv_cust_name,
           last_updated_date = sysdate
       where customer_id = pv_cust_id;

       exception
          when others then
              raise_application_error(-10002, 'Not able to update the customer name');  

    end;


 procedure update_customer_email(pv_cust_id in number 
                                 pv_cust_email in varchar2) is
    is


    begin

       update customers
       set email_id = pv_cust_email,
           last_updated_date = sysdate
       where customer_id = pv_cust_id;

       exception
          when others then
              raise_application_error(-10003, 'Not able to update the customer email');  

    end;


end;

/

show errors;

