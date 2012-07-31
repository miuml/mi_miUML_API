-- test_id_addition.sql

\set VERBOSITY terse

-- Create test case
select UI_new_class( 'X', 'X', 'Main', 'App' );
select UI_new_class( 'Y', 'Y', 'Main', 'App' );

-- X <--  -->> Y
select UI_new_binary_assoc(
	'X', 'Y', 'Main', 'App',
	NULL, NULL,
	'1', false, 'left',
	'M', false, 'right'
);

\echo 'Start condition:  Only one ref attr in Y: X_ID (R1)'
select * from referential_attribute where class = 'Y';

-- Add an Attribute to X
select UI_new_ind_attr( 'Code', 'X', 'App', 'short name' );
select UI_add_attr_to_id( 'Code', 'X', 'App', 1 );

\echo 'End condition:  Additional ref attr in Y: Code (R1)'
select * from referential_attribute where class = 'Y';
