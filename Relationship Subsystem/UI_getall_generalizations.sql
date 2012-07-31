create or replace function mirel.UI_getall_generalizations(
	-- IN
	p_domain	mi.name,
	-- OUT
	o_rnum		OUT mi.nominal,
	o_class		OUT mi.name,
	o_role		OUT boolean
) returns setof record as  -- Generalization
$$
--
-- Returns all Generalization Roles for the specified Domain.
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
	perform * from midom.domain where name = p_domain;
	if not found then
		raise exception 'UI: Domain [%] does not exist.', p_domain;
	end if;

return query
	select rnum, class, role from(
		select
			-- Superclass
			rnum,
			class,
			true as role,
			domain
			from superclass
		union select
			-- Subclass
			rnum,
			class,
			false as role,
			domain
			from subclass
	) as gun -- aun: Union of Superclass and Subclass Generalization Roles
		where domain = p_domain order by rnum, role desc, class;
		-- To put superclass at top of a group of classes in the same
		-- Generalization, order by role descending since 'superclass'
		-- comes after 'subclass' alphabetically.
end
$$
language plpgsql;
