-- init_fail.sql : Test cases that should fail


-- Init : Create one Modeled Domain
select UI_new_modeled_domain( 'T_1', 'T1' );
-- Test
-- Fail with duplicate
select UI_new_modeled_domain( 'T_1', 'T1' );
select UI_new_modeled_domain( 'T_x', 'T1' );
select UI_new_modeled_domain( 'T_1', 'Tx' );
-- Fail with no exist
select UI_delete_domain( 'T_A' );
select UI_set_domain_name( 'T_x', 'T_2' );
select UI_set_domain_alias( 'T_x', 'a' );
-- Cleanup
select UI_delete_domain( 'T_1' );

-- Init : Create one Realized Domain
select UI_new_realized_domain( 'T_1', 'T1' );
-- Test
-- Fail with duplicate
select UI_new_realized_domain( 'T_1', 'T1' );
select UI_new_realized_domain( 'T_x', 'T1' );
select UI_new_realized_domain( 'T_1','Tx' );
-- Fail with no exist
select UI_delete_domain( 'T_A' );
-- Cleanup
select UI_delete_domain( 'T_1' );

-- Init : Create one Bridge between two Domains
select UI_new_modeled_domain( 'TC', 'TC' );
select UI_new_modeled_domain( 'TS', 'TS' );
select UI_new_bridge( 'TC', 'TS' );
-- Test
-- Fail with duplicate
select UI_new_bridge( 'TC', 'TS' );
-- Fail with domain no exist
select UI_new_bridge( 'TC', 'Tx' );
select UI_new_bridge( 'Tx', 'TS' );
select UI_new_bridge( 'Tx', 'Ty' );
-- Fail on cycle
select UI_new_bridge( 'TC', 'TC' );
-- Fail on bridge no exist
select UI_delete_bridge( 'Tx', 'TS' );
select UI_delete_bridge( 'TC', 'Tx' );
select UI_delete_bridge( 'Tx', 'Tx' );
select UI_delete_bridge( 'TS', 'TC' );
-- Cleanup
select UI_delete_domain( 'TC' );
select UI_delete_domain( 'TS' );

-- Subsystems
/*
select UI_new_subsystem( 'TheApp', 'Specification', 'Spec', 200, 299 );
select UI_set_subsystem_name( 'Application', 'TheApp', 'Main' );
*/
