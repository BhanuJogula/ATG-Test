create or replace package product is
 
  procedure add_product(pv_product_name in varchar2,
                        pv_desc in varchar2);


  procedure add_prod_notifications(pn_product_id in number,
                                   pn_notification_id in number,
                                   pv_comments in varchar2);

end;

/

show errors;
