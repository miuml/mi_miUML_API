-- test_id_addition_assoc.sql

\set VERBOSITY default

-- Create test case
select UI_new_class( 'X', 'X', 'Main', 'App' );
select UI_new_class( 'Y', 'Y', 'Main', 'App' );

-- X <--  Z -->> Y
begin;
set constraints all deferred;

select UI_new_binary_assoc(
	'X', 'Y', 'Main', 'App',
	NULL, NULL,
	'M', true, 'left',
	'M', true, 'right',
	'Z', 'Z'
);

commit;


\echo 'Start condition: t <ID> and p <Y_ID> references in Z'
select * from referential_attribute where class = 'Z';

-- Add an Attribute to X
select UI_new_ind_attr( 'Code', 'X', 'App', 'short name' );
select UI_add_attr_to_id( 'Code', 'X', 'App', 1 );

\echo 'End condition:  Additional ref attr in Z: Code (R1)'
select * from referential_attribute where class = 'Z';
