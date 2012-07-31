-- Class Subsystem Queries

\echo
\echo 'Classes'
select * from class;
\echo 'Non Specialized Classes'
select * from non_specialized_class;
\echo 'Specialized Classes'
select * from specialized_class;
\echo '--'
\echo 'Identifiers'
select * from identifier;
\echo 'Modeled Identifiers'
select * from modeled_identifier;
\echo 'Required Referential Identifiers'
select * from rr_identifier;
\echo 'Identifier Attributes'
select * from identifier_attribute;
\echo '--'
\echo 'Attributes'
select * from attribute;
\echo 'Native Attributes'
select * from native_attribute;
\echo 'Independent Attributes'
select * from independent_attribute;
\echo 'Referential Attributes'
select * from referential_attribute;
\echo '--'
\echo 'Referential Roles'
select * from referential_role;
