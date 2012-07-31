create or replace function mirel.method_rel_get_class_names(
	p_rnum		relationship.rnum%type,
	p_domain	relationship.domain%type,
	-- OUT
	o_name		OUT mi.name
) returns setof mi.name as 
$$
--
-- Returns the set of all classes that participate in a Relationship
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
	perform * from relationship where rnum = p_rnum and domain = p_domain;
	if not found then
		raise 'SYS: Relationship [%::R%] does not exist.', p_rnum, p_domain;
	end if;

	return query
		select class from generalization_role where
			rnum = p_rnum and domain = p_domain
		union select distinct viewed_class from perspective where
			rnum = p_rnum and domain = p_domain
		union select class from association_class where
			rnum = p_rnum and domain = p_domain;
end
$$
language plpgsql;
