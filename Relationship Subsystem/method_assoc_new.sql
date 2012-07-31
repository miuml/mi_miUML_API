create or replace function mirel.method_assoc_new(
	p_subsys	midom.subsystem_element.subsystem%type,	-- Subsystem
	p_domain	relationship.domain%type,				-- Domain
	p_rnum		relationship.rnum%type					-- Desired rnum may be NULL
) returns relationship.rnum%type as 
$$
--
-- Create a new Association superclass instance.  (called by subclass)
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
--
declare
	my_rnum		association.rnum%type;
begin
	my_rnum := method_rel_new( p_subsys, p_domain, p_rnum );
	
	-- Create self
	insert into association( rnum, domain ) values (
		my_rnum,
		p_domain
	);

	return my_rnum;
end
$$
language plpgsql;

