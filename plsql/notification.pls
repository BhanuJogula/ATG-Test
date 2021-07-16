create or replace package notification is 

  procedure add_notification(pv_notification_type in varchar2,
                             pn_days in number,
                             pv_desc in varchar2);

end;

/

show errors;