create or replace function mirel.method_assoc_subclass(
	p_rnum		relationship.rnum%type,
	p_domain	relationship.domain%type
) returns mi.name as 
$$
--
-- Returns the name of the Association subclass: [ unary | binary ]
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
	perform * from association where rnum = p_rnum and domain = p_domain;
	if not found then
		raise 'SYS: Association [%::R%] does not exist.', p_domain, p_rnum;
	end if;

	perform * from unary_association where rnum = p_rnum and domain = p_domain;
	if found then
		return 'unary';
	end if;

	perform * from binary_association where rnum = p_rnum and domain = p_domain;
	if found then
		return 'binary';
	end if;

	raise 'SYS: No subclass instance found for [%::R%].', p_domain, p_rnum;
end
$$
language plpgsql;
