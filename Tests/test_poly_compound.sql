-- Test: Poly lifecycle compound generalization example

select UI_new_modeled_domain( 'Gas', 'GAS' );

-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_class( 'Connector', 'CONN', 'Main', 'Gas' );

begin;
set constraints all deferred;
select UI_new_gen(
	'Connector', NULL, array[ 'Valve', 'Pump' ], array[ 'V', 'P' ], 'Main', 'Gas'
);
commit;

begin;
set constraints all deferred;
select UI_new_gen(
	'Connector', NULL, array[ 'Digital', 'Analog' ], array[ 'DIG', 'AN' ], 'Main', 'Gas'
);
commit;

begin;
set constraints all deferred;
select UI_new_gen(
	'Pump', NULL, array[ 'Active Pump', 'Passive Pump' ], array[ 'AP', 'PP' ], 'Main', 'Gas'
);
commit;

-- Coordinated Lifecycles
select UI_new_lifecycle( 'Connector', 'Gas' );
select UI_new_lifecycle( 'Valve', 'Gas' );
select UI_new_lifecycle( 'Pump', 'Gas' );
select UI_new_lifecycle( 'Active Pump', 'Gas' );
select UI_new_lifecycle( 'Passive Pump', 'Gas' );
select UI_new_lifecycle( 'Digital', 'Gas' );
select UI_new_lifecycle( 'Analog', 'Gas' );

-- States
begin;
set constraints all deferred;
	select * from UI_set_dest_name( 'Initial', 'Active Pump', 'Gas', 'Idle' );
commit;
select * from UI_new_state( 'Running', 'Active Pump', 'Gas' );

-- Events
select * from UI_new_signaling_event( 'Start', 'Connector', 'Gas', 1 );
select * from UI_delegate_event( 'Start', 'Connector', 'Gas' );
select * from UI_delegate_event( 'Start', 'Connector', 'Gas', 'Pump' );

-- Deletion
-- select * from UI_delete_event( 'Connector', 'Start', 'Gas' );

--select * from UI_new_polymorphic_event( 'Start', 'Connector', 'Gas', 1 );
--select * from UI_new_polymorphic_event( 'Set', 'Connector', 'Gas', NULL, 2 );

-- Transitions
--select * from UI_new_transition( 'Idle', 'Running', 'Start', 'Active Pump', 'Gas' );
