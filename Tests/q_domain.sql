-- Domain and Subsystem Queries
\pset border 2

\echo
\echo 'Domains'
select * from domain;
\echo 'Bridges'
select * from bridge;
\echo 'Realized Domains'
select * from realized_domain;
\echo 'Modeled Domains'
select * from modeled_domain;

\echo '--'
\echo 'Subsystems'
select * from subsystem;
\echo 'Ranges'
select * from subsystem_range;

\echo '--'
\echo 'Elements'
select * from element;
\echo 'Subsystem Elements'
select * from subsystem_element;
\echo '--'

\pset border 0
