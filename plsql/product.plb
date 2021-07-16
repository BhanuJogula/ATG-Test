create or replace package body product is
 
  procedure add_product(pv_product_name in varchar2,
                        pv_desc in varchar2) 
  is 

  begin
     insert into products(product_id, product_name, description, created_date)
       values(products_s.nextval, pv_product_name, pv_desc, sysdate);

  exceptions
      when others then
           raise_application_error(-10004, 'Not able to add the product information');

   end;


  procedure add_prod_notifications(pv_product_name in varchar2,
                                   pn_notification_id in number,
                                   pv_comments in varchar2)
  is 
     ln_product_id number;

  begin

     select product_id  into ln_product_id
     from products where product_name = pv_product_name;

     insert into PRODUCT_NOTIFICATIONS(product_id, notification_id, description, created_date)
       values(ln_product_id, pn_notification_id, pv_comments, sysdate);

  exceptions
      when others then
           raise_application_error(-10005, 'Not able to add the notification to product');

   end;


end;

/

show errors;
