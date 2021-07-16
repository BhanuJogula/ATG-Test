create or replace package body cust_domain_subscription is 

  procedure add_cust_subscription(pn_cust_id in number,
                                  pn_prod_id in number,
                                  pn_domain_id in number,
                                  pn_duraion in number)
  is
     ln_subscr_exists number;

    begin

      ln_subscr_exists := 0;

      select count(1)
      into ln_subscr_exists
      from cust_domain_subscriptions
      where product_id = pn_prod_id
      and customer_id = pn_cust_id
      and domain_id = pn_domain_id
      and end_date > sysdate;

      if (ln_subscr_exists == 1) then
         raise_application_error(-10009, 'Subscription already exists for the domain, prod & customer'); 
      end if;

      begin

        insert into CUST_DOMAIN_SUBSCRIPTION_HISTORY(cust_domain_hist_id,customer_id, product_id, domain_id, 
                                 start_date, end_date, duration)
         select subscription_hist_s.nextval, customer_id, product_id, domain_id, start_date, end_date,duration
           from cust_domain_subscriptions
         where product_id = pn_prod_id
          and customer_id = pn_cust_id
          and domain_id = pn_domain_id
          and end_date = sysdate;

         delete_cust_subscription(customer_id, product_id,domain_id);
      exception
         when others then
            null;
      end;

      insert into cust_domain_subscriptions(cust_sub_id, customer_id, product_id, domain_id, start_date,
                                             end_date, duration)
         values (subscription_s.nextval, pn_cust_id, pn_product_id, pn_domain_id, sysdate, 
                 sysdate+pn_duration, pn_duration);

       insert_notfications(customer_id, product_id, domain_id);


    exceptions
      when others then
           raise_application_error(-10010, 'Not able to add the customer subscription information');

   end;
 
   procedure insert_notfications(pn_cust_id in number,
                                 pn_prod_id in number,
                                 pn_domain_id in number)
    is

    begin 

        insert into CUST_DOMAIN_NOTIFICATIONS(cust_notification_id, cust_sub_id, email_date)
        select cust_notifications_s.nextval, cds.cust_sub_id,
          decode(nt.notification_type, 'ACTIVATION', cds.start_date + cds.duration, cds.end_date - cds.duration)
        from PRODUCT_NOTIFICATIONS pn, notifications nt, cust_domain_subscriptions cds
        where pn.product_id = pn_prod_id
        and nt.notification_id = pn.notification_id
        and cds.product_id = pn.product_id
        and cds.customer_id = pn_cust_id
        and cds.domain_id = pn_domain_id;


    exceptions
      when others then
           raise_application_error(-10012, 'Not able to add the customer notification information');

    end;

   procedure delete_cust_subscription(pn_cust_id in number,
                                      pn_prod_id in number,
                                      pn_domain_id in number)
    is

    begin

      delete from delete_cust_subscription
      where product_id = pn_prod_id
        and customer_id = pn_cust_id
        and domain_id = pn_domain_id;

    exception
       when others then
          null;
    end;

end;

/

show errors;