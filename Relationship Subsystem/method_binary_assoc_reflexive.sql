create or replace function mirel.method_binary_assoc_reflexive(
	p_rnum		binary_association.rnum%type,
	p_domain	binary_association.domain%type
) returns boolean as 
$$
--
-- Returns true if the specified Binary Association is reflexive
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
	-- If reflexive, both viewed class names will be the same.
	-- A distinct count will, therefore, yield one for a reflexive
	-- association, and two for a non-reflexive.
	if ( select count( distinct viewed_class ) from perspective where
		rnum = p_rnum and domain = p_domain ) = 1 then
		return true;
	else
		return false;
	end if;
end
$$
language plpgsql;
