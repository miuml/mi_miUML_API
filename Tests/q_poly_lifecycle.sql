\pset border 2
-- Lifecycle Test Queries

\echo
\echo 'Lifecycles'
select * from lifecycle;
\echo 'State Model'
select * from state_model;
\echo '--'
\echo 'Destinations'
select * from destination;
\echo 'States'
select * from state;
\echo 'Transitions'
select * from transition;
\echo 'Non Transition Responses'
select * from nt_response;
\echo '--'
\echo 'Parameters'
select * from state_model_parameter;
\echo '--'
\echo 'Polymorphic Event Specs j'
select 'ES-' || e.number as number, e.name, 'C' || e.state_model sm_name, e.sm_type from
	event_spec e join polymorphic_event_spec p on (
		e.number = p.number and e.state_model = p.cnum and
		e.sm_type = p.sm_type and e.domain = p.domain
	);
\echo 'Local Delegated Events'
select 'EV-' || id as "del event", 'C' || cnum as class, 'ES-' || ev_spec as ev_spec from
	local_delegated_event;
\echo 'Delegation Dirs'
select 'EV-' || delegated_evid "del event", 'C' || super_cnum as super, 'R' || gen_rnum as gen from
	delegation_dir;
\echo 'Delegation Paths'
select 'EV-' || delegated_evid as "del event", 'C' || super_cnum as super, 'C' || sub_cnum as sub,
	'R' || gen_rnum as gen from delegation_path;
\echo 'Inherited Delegated Events'
select 'EV-' || id as event, 'C' || cnum as class from inherited_delegated_event;
\echo 'Inherited Effective Events'
select 'EV-' || id as event, 'C' || cnum as class, sm_type from inherited_effective_event;
\echo 'Local Effective Events'
select 'EV-' || id as event, 'SM-' || state_model as sm, sm_type from local_effective_event;
\echo 'Inherited Event'
select 'EV-' || id as event, 'C' || sub_cnum as sm, 'EV-' || parent_evid as "parent event", 
	'C' || super_cnum as super, 'R' || gen_rnum as "gen rel" from inherited_event;

