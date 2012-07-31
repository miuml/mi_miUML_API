-- Lifecycle Test Queries
\pset border 2

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
\echo 'Monomorphic Event Specs j'
select 'ES-' || e.number as number, e.name, 'SM-' || e.state_model sm_name, e.sm_type from
	event_spec e join monomorphic_event_spec p using ( number, state_model, sm_type, domain );
\echo '--'
\echo 'Local Effective Events'
select * from local_effective_event;

\pset border 0
