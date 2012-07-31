create or replace function midom.method_subsystem_new_default(
	-- args
	p_domain_name      domain.name%type, -- Create initial default Subsystem in this Domain
    p_domain_alias     domain.alias%type
) returns void as 
$$
--
-- Creates the initial default Subsystem when a new Domain is created
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
declare
	the_dbspec			domain_build_spec%rowtype;
	new_subsys_name		subsystem.name%type;
begin

	-- Get the Domain Model
	select * into strict the_dbspec from domain_build_spec where name = 'singleton';

	if the_dbspec.domain_name_is_default_subsys_name then
		new_subsys_name := p_domain_name;
	else
		new_subsys_name := the_dbspec.default_subsys_name;
	end if;

	perform method_subsystem_new(
		new_subsys_name,
		p_domain_name, 
		new_subsys_name::mi.short_name, -- Use name for the alias also
		1,
		the_dbspec.default_subsys_range
	);

	exception
		when no_data_found then
			raise exception 'SYS: Domain Build Specification missing. Bad initialization?';
end
$$
language plpgsql;
