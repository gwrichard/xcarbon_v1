set schema carbon_v1;
/*---------------------------------------------------------------------
    Copyright © 2019 Rizing LLC
    Version: 1.0
    Date: 5/22/2020
    Author: Hardwick
----------------------------------------------------------------------*/

--standard log view tile

drop view c_message_stream;
create view c_message_stream as 
select * from carbon_v1.c_message_stage 
where change_user = current_user and id not in('10003','10005','10007') order by oid asc;

drop view c_task_messages; 
create view c_task_messages as 
select * from carbon_v1.c_messages;

--custom log view tile

drop view c_task_alerts; 
create view c_task_alerts as 
select * from carbon_v1.c_messages where ( type = 'W' or type = 'E' ) and change_user = current_user;

drop view c_task_allmsg;
create view c_task_allmsg as 
select * from carbon_v1.c_messages where change_user = current_user;