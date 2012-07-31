create or replace function mirel.method_rel_new(
	p_subsys	midom.subsystem_element.subsystem%type,	-- Subsystem
	p_domain	relationship.domain%type,				-- Domain
	p_rnum		relationship.rnum%type					-- Desired rnum may be NULL
) returns relationship.rnum%type as 
$$
--
-- Create a new Relationship superclass instance.  (called by subclass)
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
	my_domain			domain%rowtype;
	my_subsys			subsystem%rowtype;
	my_element_number	midom.subsystem_element.number%type;
	my_rnum				relationship.rnum%type;
begin
	-- Get my Subsystem
	begin
		select * from subsystem into strict my_subsys where(
			name = p_subsys and domain = p_domain
		);
	exception
		when no_data_found then
			raise exception 'UI: Subsystem [%::%] does not exist.', p_subsys, p_domain;
	end;

	-- And my Domain
	select * from domain into strict my_domain where(
		name = p_domain
	); -- If the Subsystem exists, then its Domain must also, it is part of the key

	-- Create this Relationship's superclass Element / Subsystem Element 
	select method_subsystem_element_new( my_subsys.name, my_subsys.domain ) into my_element_number;

	-- Get an rnum
	select method_subsystem_assign_rnum( my_subsys.name, my_subsys.domain, p_rnum ) into my_rnum;
	
	-- Create self
	begin
		insert into relationship( rnum, domain, element ) values (
			my_rnum,
			p_domain,
			my_element_number
		);
	exception
		when unique_violation then
			raise exception 'UI: Relationship [%::%] already exists.', p_domain, p_rnum;
	end;

	return my_rnum;
end
$$
language plpgsql;

