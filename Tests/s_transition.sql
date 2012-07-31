-- Show Transitions
\pset border 2

\echo
\echo '--'
\echo 'Transitions'
select state as "from", event as "on", destination as "to", state_model as "sm", sm_type from transition;

\pset border 0
