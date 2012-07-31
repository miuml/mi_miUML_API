-- init_test.sql

-- Load some initial Domains
--
select method_constrained_type_new( 'nominal' );
select method_constrained_type_new( 'name' );
select method_constrained_type_new( 'short name' );
select method_constrained_type_new( 'description' );
select method_constrained_type_new( 'posint' );
