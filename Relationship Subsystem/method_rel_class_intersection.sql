create or replace function mirel.method_rel_class_intersection(
	p_rel1		relationship.rnum%type,
	p_rel2		relationship.rnum%type,
	p_domain	relationship.domain%type
) returns setof mi.name as 
$$
--
-- Returns the set of all classes that participate in both Relationships, or NULL
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
	perform * from relationship where rnum = p_rel1 and domain = p_domain;
	if not found then
		raise 'SYS: Relationship [%::R%] does not exist.', p_rnum, p_domain;
	end if;

	perform * from relationship where rnum = p_rel2 and domain = p_domain;
	if not found then
		raise 'SYS: Relationship [%::R%] does not exist.', p_rnum, p_domain;
	end if;

	return query
		select method_rel_get_class_names( p_rel1, p_domain )
		intersect
		select method_rel_get_class_names( p_rel2, p_domain );
end
$$
language plpgsql;
