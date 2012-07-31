create or replace function mirel.UI_delete_loop(
	-- Existing
	p_loop		mi.nominal,		-- Element number of a Loop
	p_domain	mi.name			-- The domain name
) returns void as 
$$
--
-- Deletes a Constrained Loop.
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
	perform mirel.method_loop_delete( p_loop, p_domain );
end
$$
language plpgsql;
