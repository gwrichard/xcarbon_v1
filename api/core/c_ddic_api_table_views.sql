set schema carbon_v1;
/*---------------------------------------------------------------------
    Copyright © 2019 Rizing LLC
    Version: 1.0
    Date: 5/22/20
    Author: Hardwick
----------------------------------------------------------------------*/

drop view c_task_tables; 
create view c_task_tables as
select 'carbon_v1.tasks.default.p6_resources.workcenters::composed' as task_name, 'P6_RESOURCE_STAGE' as table_name, 'Work center resource staging for P6' as table_text from dummy UNION
select 'carbon_v1.tasks.default.p6_activities.orders::composed' as task_name, 'P6_ACTIVITY_STAGE' as table_name, 'Order operation activity staging for P6' as table_text from dummy UNION
select 'carbon_v1.tasks.default.p6_activities.orders::composed' as task_name, 'P6_ACTIVITYCODE_STAGE' as table_name, 'Order operation activity code staging for P6' as table_text from dummy UNION
select 'carbon_v1.tasks.default.p6_activities.orders::composed' as task_name, 'P6_ACTIVITYCODEASSIGN_STAGE' as table_name, 'Order operation activity code assignment staging for P6' as table_text from dummy UNION
select 'carbon_v1.tasks.default.p6_activities.orders::composed' as task_name, 'P6_RESOURCEASSIGN_STAGE' as table_name, 'Order operation resource assignment staging for P6' as table_text from dummy UNION
select 'carbon_v1.tasks.default.p6_activities.operation_update::composed' as task_name, 'SAP_OPERATION_STAGE' as table_name, 'Operation staging for SAP' as table_text from dummy
;

drop view ODATA_P6_RESOURCE_STAGE; create view ODATA_P6_RESOURCE_STAGE as select 'carbon_v1.tasks.default.p6_resources.workcenters::composed' as task_name, 'P6_RESOURCE_STAGE' as table_name, * from carbon_v1.P6_RESOURCE_STAGE;
drop view ODATA_P6_ACTIVITY_STAGE; create view ODATA_P6_ACTIVITY_STAGE as select 'carbon_v1.tasks.default.p6_activities.orders::composed' as task_name, 'P6_ACTIVITY_STAGE' as table_name, * from carbon_v1.P6_ACTIVITY_STAGE;
drop view ODATA_P6_ACTIVITYCODE_STAGE; create view ODATA_P6_ACTIVITYCODE_STAGE as select 'carbon_v1.tasks.default.p6_activities.orders::composed' as task_name, 'P6_ACTIVITYCODE_STAGE' as table_name, * from carbon_v1.P6_ACTIVITYCODE_STAGE;
drop view ODATA_P6_ACTIVITYCODEASSIGN_STAGE; create view ODATA_P6_ACTIVITYCODEASSIGN_STAGE as select 'carbon_v1.tasks.default.p6_activities.orders::composed' as task_name, 'P6_ACTIVITYCODEASSIGN_STAGE' as table_name, * from carbon_v1.P6_ACTIVITYCODEASSIGN_STAGE;
drop view ODATA_P6_RESOURCEASSIGN_STAGE; create view ODATA_P6_RESOURCEASSIGN_STAGE as select 'carbon_v1.tasks.default.p6_activities.orders::composed' as task_name, 'P6_RESOURCEASSIGN_STAGE' as table_name, * from carbon_v1.P6_RESOURCEASSIGN_STAGE;
drop view ODATA_SAP_OPERATION_STAGE; create view ODATA_SAP_OPERATION_STAGE as select 'carbon_v1.tasks.default.p6_activities.operation_update::composed::composed' as task_name, 'SAP_OPERATION_STAGE' as table_name, * from carbon_v1.SAP_OPERATION_STAGE;