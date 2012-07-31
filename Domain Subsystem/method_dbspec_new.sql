create or replace function midom.method_dbspec_new(
	-- Args
	p_domain_name_is_default_subsys_name	boolean,	-- For first created subsystem
	p_default_subsys_name					mi.name,	-- Default first subsystem name
														-- ignored if domain name is default
	p_default_subsys_range					mi.posint,	-- Extent of newly created range
	p_default_id_name						mi.name,	-- Attr Name like 'ID', 'Number'
	p_default_id_type						mi.name
) returns void as
$$
--
-- Creates the Domain Build Specification singleton.  One object must be created
-- at initialization (prior to run-time) or any code that creates new Domains or
-- Subsystems will fail.
--
-- Copyright 2011, Model Integration, LLC
-- Developer: Leon Starr / leon_starr@modelint.com
-- 
-- This file is part of the miUML metamodel library.
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.  The license text should be viewable at
-- http://www.gnu.org/licenses/
--
begin
	insert into domain_build_spec(
		name, domain_name_is_default_subsys_name, default_subsys_name, default_subsys_range,
		default_id_name, default_id_type
	) values (
		'singleton', p_domain_name_is_default_subsys_name, p_default_subsys_name, 
		p_default_subsys_range, p_default_id_name, p_default_id_type
	);
exception
	when foreign_key_violation then
		raise exception 'SYS: Common Type [%] does not exist.', p_default_id_type;
end
$$
language plpgsql;
