create or replace function mistate.UI_getall_lifecycles(
	-- IN
	p_domain		mi.name,
	-- OUT
	o_name			OUT mi.name		-- Class name
) returns setof mi.name as
$$
--
-- Query: Get all lifecycles
--
-- Returns the name of each Class with a defined Lifecycle.
--
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
begin
	perform * from midom.domain where name = p_domain;
	if not found then raise exception
		'UI: Domain [%] does not exist.', p_domain;
	end if;

	return query select name from lifecycle join miclass.class using ( cnum, domain )
		where lifecycle.domain = p_domain;
end
$$
language plpgsql;
