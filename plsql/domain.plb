create or replace package body domain is 

  procedure add_domain(pv_domain_name in varchar2,
                       pv_ip_address in varchar2,
                       pv_desc in varchar2) 
   is 

   begin
     insert into domains(domain_id, domain_name, description, ip_address, created_date, last_updated_date)
       values(domains_s.nextval, pv_domain_name, pv_desc, pv_ip_address, sysdate, sysdate);

  exceptions
      when others then
           raise_application_error(-10006, 'Not able to add the domain information');

   end;

 

  procedure update_ip_address(pv_domain_id in number,
                              pv_ip_address in varchar2)

  is 

   begin
     update domains
      set ip_address = pv_ip_address,
          last_updated_date = sysdate
      where domain_id = pv_domain_id

  exceptions
      when others then
           raise_application_error(-10007, 'Not able to update the domain IP address information');

   end;
end;

/

show errors;
