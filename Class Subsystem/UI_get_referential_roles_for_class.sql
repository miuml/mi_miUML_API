create or replace function miclass.UI_get_referential_roles_for_class(
	-- IN
	p_class		mi.name,
	p_domain	mi.name,
	-- OUT
	o_from_attr		OUT mi.name,
	o_ref_type		OUT text,
	o_to_attr		OUT	mi.name,
	o_to_class		OUT mi.name,
	o_rnum			OUT mi.nominal,
	o_to_identifier	OUT mi.nominal
) returns setof record as  -- Referential Role
$$
--
-- Returns all Referential Roles on the specified Class.
--
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
begin
	perform * from miclass.class where name = p_class and domain = p_domain;
		if not found then
			raise exception 'UI: Class [%:%] does not exist.', p_domain, p_class;
		end if;

return query
	select from_attribute, reference_type::text,
		to_attribute, to_class, rnum, to_identifier from referential_role
		where from_class = p_class and domain = p_domain order by from_attribute;
end
$$
language plpgsql;
