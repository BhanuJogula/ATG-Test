============================================
Configurations for Email Notifications:
============================================

-- Domain sends email 2 days before expiration.
exec notification.add_notification('EXPIRATION', 2, '2 days before expiration'); -- notification id for this is 1
exec product.add_prod_notifications('Domain',1, 'Domain sends email 2 days before expiration');




-- Hosting sends email 1 day after activation and 3 days before expiration.
exec notification.add_notification('ACTIVATION', 1, '1 day  after activation'); 
   -- notification id for this is 2
exec notification.add_notification('EXPIRATION', 3, '3 days  before expiration'); 
    -- notification id for this is 3
exec product.add_prod_notifications('Hosting',2, 'Hosting sends email 1 day after activation');
exec product.add_prod_notifications('Hosting',3, 'Hosting sends email 3 day  before expiration');
 


-- Protected Domain sends email 9 days before expiration and 2 days before expiration.

exec notification.add_notification('EXPIRATION', 9, '9 days  before expiration'); 
    -- notification id for this is 4
exec product.add_prod_notifications('Protected Domain',4, 'Protected Domain sends email 9 days before expiration');
exec product.add_prod_notifications('Protected Domain',1, 'Protected Domain sends email 2 days before expiration');
 -- This notification is already configured as the first notification.



