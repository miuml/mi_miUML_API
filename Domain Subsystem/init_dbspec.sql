-- init_dbspec.sql

-- Create the Domain Build Specification singleton
--
-- Args: Use domain name, default first subsys name, range, id name, id type
select method_dbspec_new( false, 'Main', 100, 'ID', 'nominal' );
