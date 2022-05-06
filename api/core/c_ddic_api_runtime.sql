set schema carbon_v1;
/*---------------------------------------------------------------------
    Copyright © 2019 Rizing LLC
    Version: 1.0
    Date: 5/22/20
    Author: Hardwick
----------------------------------------------------------------------*/

--drop table c_task_properties;
create table c_task_properties(
	task_name nvarchar(256) primary key,
	task_text nvarchar(256) not null default '', 
	task_description nvarchar(256) not null default '',
	task_messages nvarchar(256)
);

--drop table c_task_param_gui_types cascade;
create table c_task_param_gui_types(
 	gui_type nvarchar(20) primary key,
 	gui_type_description nvarchar(256)  not null default ''
);

--drop table c_task_parameters;
create table c_task_parameters(
    task_name nvarchar(256) not null default '',
 	parameter_name nvarchar(256) not null default '',
    label nvarchar(50) not null default '',
    description nvarchar(256) not null default '',
 	gui_type nvarchar(20) not null default '',
 	expression nvarchar(256),
 	primary key (task_name, parameter_name),
 	foreign key (gui_type) references c_task_param_gui_types (gui_type) 
);

-->> if package changes update string length   
drop view c_tasks;
create view c_tasks as
    -- select t.task_name, t.schema_name, t.create_time, t.task_type, p.task_text, p.task_description, p.task_messages
    -- from public.tasks t 
    -- left join c_task_properties p on t.task_name = p.task_name
    -- where t.schema_name = 'CARBON_V1' and left(t.task_name,16) = 'carbon_v1.tasks.'
    -- union
    select p.task_name, 'CARBON_V1' as schema_name, '' as create_time, 'PROC' as task_type, task_text, task_description, p.task_messages
    from carbon_v1.c_task_properties p 
    left join public.tasks t on p.task_name = t.task_name
    where t.task_name is null and left(p.task_name,16) = 'carbon_v1.tasks.'
    order by p.task_text;

drop view c_parameters;
create view c_parameters as 
    select b.task_name, a.parameter_name, data_type_name, a.parameter_type, length, position, c.label, c.description, c.gui_type, c.expression
    from sys.procedure_parameters as a inner join carbon_v1.c_tasks as b on a.procedure_name = concat(b.task_name,'_SP')
                                   left join carbon_v1.c_task_parameters as c on a.procedure_name = concat(c.task_name,'_SP') and a.parameter_name = upper(c.parameter_name)
    union 
    select b.task_name, a.parameter_name, data_type_name, a.parameter_type, length, position, c.label, c.description, c.gui_type, c.expression
    from sys.procedure_parameters as a 
    inner join carbon_v1.c_tasks as b on a.procedure_name = b.task_name
    left join carbon_v1.c_task_parameters as c on a.procedure_name = c.task_name and a.parameter_name = upper(c.parameter_name) order by task_name, position;

--drop table c_task_variants;
create table c_task_variants(
	task_name nvarchar(256) not null default '',
	variant_name nvarchar(256) not null default '',
	variant_description nvarchar(256) not null default '',   
    shared nvarchar(1) not null default '',
    user_name nvarchar(256) not null default '',
	primary key (task_name, variant_name)
);

--drop table c_task_variant_values;
create table c_task_variant_values(
	task_name nvarchar(256) not null default '',
	variant_name nvarchar(256) not null default '',
	parameter_name nvarchar(256) not null default '',
	expression nvarchar(256) not null default '',
	primary key (task_name, variant_name, parameter_name)
);

drop table c_ping;
create table c_ping(
    version nvarchar(256) not null default '',
 	message nvarchar(256) not null default '',
 	primary key (version)
);

-->> if package changes update string length   
drop view c_task_executions;
create view c_task_executions as
select * from _sys_task.task_executions where schema_name = 'CARBON_V1' and left(task_name,16) = 'carbon_v1.tasks.' order by task_execution_id desc with read only;

-->> if package changes update string length   
drop view c_task_status;
create view c_task_status as
select  substr_before(substr_after(statement_string, 'CALL "CARBON_V1"."'),'"') as task_name, 
        statement_status as status, 
        last_executed_time as start_time 
from m_active_statements where left(statement_string, 33) = 'CALL "CARBON_V1"."carbon_v1.tasks';

insert into c_task_param_gui_types values ('text',	'Text control');
insert into c_task_param_gui_types values ('radio', 'Radio buttons');
insert into c_task_param_gui_types values ('checkbox',	'Boolean');
insert into c_task_param_gui_types values ('select', 'Drop-down list');
insert into c_task_param_gui_types values ('multiple', 'Multiple selection drop-down list');
insert into c_task_param_gui_types values ('button', 'Button');
insert into c_task_param_gui_types values ('date',	'Date control');
insert into c_task_param_gui_types values ('datetime',	'Date and time control');
insert into c_task_param_gui_types values ('datetime-local', 'Date and time control with no time zone');
insert into c_task_param_gui_types values ('time',	'Time control');
insert into c_task_param_gui_types values ('number', 'Text field or spinner control');
insert into c_task_param_gui_types values ('range', 'Slider control or similar');

insert into c_ping values ('Carbon v1.0 Copyright © 2019 Rizing LLC','Licensed to Customer');
