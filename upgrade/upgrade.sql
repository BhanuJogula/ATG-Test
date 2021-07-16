--
--  Table to maintain the customer information
--
create table CUSTOMERS ( 
customer_id number not null,
customer_name varchar2(200) not null,
email_id varchar2(200) not null,
start_date date not null,
last_updated_date date not null,
constraint customers_pk primary key (customer_id)) 

comment on table CUSTOMERS is
   'Stores customer details';

--
-- Table to maintain product information
--
create table PRODUCTS ( 
product_id number not null,
product_name varchar2(200) not null,
description varchar2(200) not null,
created_date date not null,
constraint products_pk primary key (product_id)) 

comment on table PRODUCTS is
   'Stores Product details';

--
-- Table to maintain Domains information
--
create table DOMAINS ( 
domain_id number not null,
domain_name varchar2(200) not null,
ip_address varchar2(200) not null,
description varchar2(200) not null,
created_date date not null,
last_updated_date date not null,
constraint domains_pk primary key (product_id)) 

comment on table DOMAINS is
   'Stores Domain details';


--
-- Table to maintain the Notifications information
--
create table NOTIFICATIONS ( 
notification_id number not null, 
description varchar2(200) not null,
notification_type varchar2(200) not null, 
days varchar2(200) not null,
created_date date not null,
constraint notifications_pk primary key (notification_id)) 

comment on table NOTIFICATIONS is
   'Stores Notification details';

ALTER TABLE NOTIFICATIONS
    ADD CONSTRAINT NOTIFICATIONS_c1 CHECK (notification_type IN ('ACTIVATION','EXPIRATION'))


--
-- Table to configurae the product notifications
--
create table PRODUCT_NOTIFICATIONS ( 
product_id number not null,
notification_id number not null, 
comments varchar2(200) not null ,
created_date date not null,
constraint product_notifications_pk primary key (product_id,notification_id),
  constraint product_notifications_r1 foreign key (product_id)
  references PRODUCTS (product_id),
  constraint product_notifications_r2 foreign key (notification_id)
  references NOTIFICATIONS (notification_id)) 

comment on table PRODUCT_NOTIFICATIONS is
   'Product Notification details';


--
-- Table to manage the customer Domain Subscriptions
--
create table CUST_DOMAIN_SUBSCRIPTIONS ( 
cust_sub_id number not null,
customer_id number not null,
product_id number not null,
domain_id number not null,
start_date date not null,  
end_date date default null,
duration number not null, 
constraint cust_domain_subscriptions_pk primary key (cust_sub_id),
constraint cust_domain_subscriptions_r1 foreign key (customer_id)
  references CUSTOMERS (customer_id),
constraint cust_domain_subscriptions_r2 foreign key (product_id)
  references PRODUCTS (product_id),
constraint cust_domain_subscriptions_r3 foreign key (domain_id)
  references DOMAINS (domain_id)) 

 CREATE UNIQUE INDEX cust_domain_subscriptions_i1
  ON CUST_DOMAIN_SUBSCRIPTIONS(customer_id, product_id, domain_id);

comment on table CUST_DOMAIN_SUBSCRIPTIONS is
   'Stores customer product subscritption details';


create table CUST_DOMAIN_NOTIFICATIONS ( 
cust_notification_id number not null,
cust_sub_id number not null,
email_date date not null,
constraint cust_domain_notifications_pk primary key (cust_notification_id),
constraint cust_domain_notifications_r1 foreign key (cust_sub_id)
  references CUST_DOMAIN_SUBSCRIPTIONS (cust_sub_id)) 

comment on table CUST_DOMAIN_NOTIFICATIONS is
   'Stores customer product subscritption notification details';

create table CUST_DOMAIN_SUBSCRIPTION_HISTORY ( 
cust_domain_his_id not null,
customer_id number not null,
product_id number not null,
domain_id number not null,
start_date date not null,  
end_date date default null,
duration number not null,
last_updated_date date not null,
constraint cust_domain_subscription_hist_pk primary key (cust_domain_his_id),
constraint cust_domain_subscription_hist_r1 foreign key (customer_id)
  references CUSTOMERS (customer_id),
constraint cust_domain_subscription_hist_r2 foreign key (product_id)
  references PRODUCTS (product_id),
constraint cust_domain_subscription_hist_r3 foreign key (domain_id)
  references DOMAINS (domain_id)) 

comment on table CUST_DOMAIN_SUBSCRIPTIONS is
   'Stores customer product subscritption details history';


--
-- Creation sequence for subscription 
--

CREATE SEQUENCE subscription_s
    MINVALUE 1
    START WITH 1
   INCREMENT BY 1;

--
-- Creation sequence for cust notifications 
--

CREATE SEQUENCE cust_notifications_s
    MINVALUE 1
    START WITH 1
   INCREMENT BY 1;


--
-- Creation sequence for subscription history
--

CREATE SEQUENCE subscription_hist_s
    MINVALUE 1
    START WITH 1
   INCREMENT BY 1;


--
-- Creation sequence for notifications
--

CREATE SEQUENCE NOTIFICATIONS_S
    MINVALUE 1
    START WITH 1
   INCREMENT BY 1;

--
-- Creation sequence for products
--
CREATE SEQUENCE PRODUCTS_S
    MINVALUE 1
    START WITH 1
   INCREMENT BY 1;

--
-- Creation sequence for customers
--
CREATE SEQUENCE CUSTOMERS_S
    MINVALUE 1
    START WITH 1
   INCREMENT BY 1;

--
-- Creation sequence for domains
--
CREATE SEQUENCE DOMAINS_S
    MINVALUE 1
    START WITH 1
   INCREMENT BY 1;