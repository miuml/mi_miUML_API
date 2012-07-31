-- Test: Poly lifecycle state model example

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
	'Pump', NULL, array[ 'Active Pump', 'Passive Pump' ], array[ 'AP', 'PP' ], 'Main', 'Gas'
);
commit;

-- Coordinated Lifecycles
select UI_new_lifecycle( 'Connector', 'Gas' );
select UI_new_lifecycle( 'Valve', 'Gas' );
select UI_new_lifecycle( 'Pump', 'Gas' );
select UI_new_lifecycle( 'Active Pump', 'Gas' );
select UI_new_lifecycle( 'Passive Pump', 'Gas' );

-- States
begin;
set constraints all deferred;
	select * from UI_set_dest_name( 'Initial', 'Active Pump', 'Gas', 'Idle' );
commit;
select * from UI_new_state( 'Running', 'Active Pump', 'Gas' );
select * from UI_new_state( 'Stopped', 'Active Pump', 'Gas' );
select * from UI_new_state( 'Pushed', 'Active Pump', 'Gas' );

-- Events
select * from UI_new_polymorphic_event( 'Start', 'Connector', 'Gas', 1, 1 );
select * from UI_new_polymorphic_event( 'Stop', 'Pump', 'Gas', NULL, 4 );
select * from UI_delegate_event( 'Start', 'Connector', 'Gas', 'Pump' );
select * from UI_new_signaling_event( 'Push', 'Active Pump', 'Gas', 8 );
select * from UI_new_creation_event( 'New', 'Active Pump', 'Idle', 'Gas' );

-- Transitions
select * from UI_new_transition( 'Idle', 'Running', 'Start', 'Active Pump', 'Gas' );
select * from UI_new_transition( 'Running', 'Stopped', 'Stop', 'Active Pump', 'Gas' );
select * from UI_new_transition( 'Idle', 'Stopped', 'Push', 'Active Pump', 'Gas' );

-- Change Destination
select * from UI_set_transition_dest( 'Idle', 'Push', 'Active Pump', 'Gas', 'Pushed' );

-- Add State Sig Param
select UI_add_param_to_state_sig( 'a', 'posint', 'Pushed', 'Active Pump', 'Gas' );
select UI_set_transition_dest( 'Idle', 'Push', 'Active Pump', 'Gas', 'Idle' );
