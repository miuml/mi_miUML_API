create or replace function miclass.method_class_validate_cnum(
	-- id
	p_name		mi.name,	-- Class name
	p_domain	mi.name,	-- The Class is in this Domain
	-- args
	p_new_cnum	int			-- mi.posint: New Class number
) returns void as 
$$
--
-- Changes a Class's cnum to an unused value within the Class's Subsystem Range.
--
-- Copyright 2012, Model Integration, LLC
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
	self				miclass.class%rowtype;
	my_subsys_element	midom.subsystem_element%rowtype;
	my_subsys_range		midom.subsystem_range%rowtype;
	dup_class			miclass.class%rowtype;
begin
	-- Get self
	begin
		select * into strict self from class where
			name = p_name and domain = p_domain;
	exception
		when no_data_found then
			raise exception 'UI: Class [%::%] does not exist.', p_domain, p_class;
	end;

	-- Validate subsystem range

	-- self->Subsystem Element[R14]->Subsystem[R13]->Subsystem Range[R3].(Floor, Ceiling)
	select * from midom.subsystem_element into strict my_subsys_element 
		where number = self.element and domain = self.domain;
	select * from midom.subsystem_range into strict my_subsys_range
		where subsystem = my_subsys_element.subsystem and domain = self.domain;

	if p_new_cnum < my_subsys_range.floor or p_new_cnum > my_subsys_range.ceiling then
		raise exception 'UI: Cnum [%] is outside subsystem range [%-%].',
			p_new_cnum, my_subsys_range.floor, my_subsys_range.ceiling;
	end if;
end
$$
language plpgsql;
