create or replace function miclass.method_class_is_compound_gen(
	-- ID
	p_name		miclass.class.name%type,
	p_domain	miclass.class.domain%type
) returns boolean as 
$$
--
-- Method: Class.Is compound
--
-- Returns true if this Class participates in more than one Superclass roles.
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
declare
	superclass_roles int;
begin
	select into superclass_roles
		count(*) from superclass where class = p_name and domain = p_domain;

	if superclass_roles > 1 then return true; end if;

	return false;
end
$$
language plpgsql;
