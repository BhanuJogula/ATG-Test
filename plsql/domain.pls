create or replace package domain is 

  procedure add_domain(pv_domain_name in varchar2,
                       pv_ip_address in varchar2,
                       pv_desc in varchar2);


  procedure update_ip_address(pv_domain_id in number,
                              pv_ip_address in varchar2);

end;

/

show errors;
