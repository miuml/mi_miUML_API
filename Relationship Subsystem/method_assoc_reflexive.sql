create or replace function mirel.method_assoc_reflexive(
	p_rnum		association.rnum%type,
	p_domain	association.domain%type
) returns boolean as 
$$
--
-- Returns true if the specified Association is reflexive (on a single class).
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
	-- Unary (always reflexive)
	if method_assoc_subclass( p_rnum, p_domain ) = 'unary' then
		return true;
	end if;

	-- Binary
	return method_binary_assoc_reflexive( p_rnum, p_domain );
end
$$
language plpgsql;
