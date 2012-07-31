-- init_test.sql

-- Load some initial Domains
--
select UI_new_modeled_domain( 'Application', 'APP' );
select UI_new_modeled_domain( 'Alarms', 'ALARMS' );
select UI_new_realized_domain( 'UI', 'UI' );
--select UI_new_modeled_domain( 'DeleteMe', 'DEL' );
--select UI_delete_domain( 'DeleteMe' );

-- Bridges
select UI_new_bridge( 'Application', 'UI' );
select UI_new_bridge( 'Application', 'Alarms' );
select UI_delete_bridge( 'Application', 'UI' );

-- Rename Domains
-- select UI_set_domain_name( 'UI', 'GUI' );
-- Rename Alias
-- select UI_set_domain_alias( 'Application', 'App' );

-- Subsystems
-- select UI_new_subsystem( 'TheApp', 'Specification', 'Spec', 200, 299 );
select UI_set_subsystem_name( 'Application', 'Application', 'Main' );
select UI_set_subsystem_alias( 'Main', 'Application', 'M' );
