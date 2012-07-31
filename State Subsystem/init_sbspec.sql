-- init_sbspec.sql

-- Create the State Model Build Specification singleton
--
-- Args: Default initial state name, max event specs per state model
select method_sbspec_new( 'Initial', 200, 200 );
