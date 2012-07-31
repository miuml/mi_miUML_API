-- Test: Single lifecycle state model example

-- Domain / Subsystem
select UI_new_domain( 'App', 'APP', 'modeled' );

-- Class
-- name, alias, subsys, domain, [cnum], [id_name], [id_type]
select UI_new_class( 'Thing', 'T', 'Main', 'App', 8 );


-- Lifecycle with Initial state 'Initial'
select UI_new_lifecycle( 'Thing', 'App' );
begin;
set constraints all deferred;
	select UI_set_dest_name( 'Initial', 'Thing', 'App', 'A' );
commit;

select UI_new_state( 'B', 'Thing', 'App' );
select UI_new_state( 'C', 'Thing', 'App' );
select UI_new_state( 'D', 'Thing', 'App' );


-- Events
select * from UI_new_creation_event( 'Create', 'Thing', 'A', 'App' );
select * from UI_new_signaling_event( 'Go', 'Thing', 'App', 51 );
select * from UI_new_signaling_event( 'Stop', 'Thing', 'App', 52 );

-- State sigs
select * from UI_add_param_to_state_sig( 'x', 'posint', 'D', 'Thing', 'App' );

-- Event sigs
select * from UI_add_param_to_event_sig( 'y', 'posint', 'Stop', 'Thing', 'App' );

-- Transitions
select * from UI_new_transition( 'A', 'B', 'Go', 'Thing', 'App' );
select * from UI_new_transition( 'B', 'C', 'Go', 'Thing', 'App' );
select * from UI_new_transition( 'C', 'D', 'Stop', 'Thing', 'App' );
