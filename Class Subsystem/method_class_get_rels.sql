create or replace function miclass.method_class_get_rels(
	p_class		miclass.class.name%type,
	p_domain	miclass.class.domain%type,
	-- OUT
	o_rnum		OUT mi.nominal
) returns setof mi.nominal as 
$$
--
-- Returns the set of all Relationship rnums surrounding this class.
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
	-- Always validate queries since a NULL return would disguise an error
	perform * from class where name = p_class and domain = p_domain;
	if not found then
		raise 'SYS: Class [%::%] does not exist.', p_domain, p_class;
	end if;

	return query
		select rnum from relationship join (
			select distinct on( rnum ) rnum from referential_role where
				to_class = p_class or from_class = p_class
		) as x using( rnum );
end
$$
language plpgsql;
