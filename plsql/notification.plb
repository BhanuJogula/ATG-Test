create or replace package body notification is 

  procedure add_notification(pv_notification_type in varchar2,
                             pn_days in number,
                             pv_desc in varchar2)
  is

  begin
    if (upper(pv_notification_type) != 'ACTIVATION' and upper(pv_notification_type) != 'EXPIRATION') then
        raise_application_error(-10017, 'Notification type can have the values only ACTIVATION or EXPIRATION');
    end if;

    insert into NOTIFICATIONS (notification_id, notification_type, days,description,created_date)
         values (NOTIFICATIONS_S.nextval,pv_notification_type, pn_days, pv_desc, sysdate);

  exceptions
      when others then
          raise_application_error(-10016, 'Not able to add the Notification information');

end;

/

show errors;