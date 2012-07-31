create or replace function mistate.UI_single_assigner_to_multiple(
	-- Existing
	p_rnum			mi.nominal,		-- An existing Single Assigner association
	p_domain		mi.name,
	-- Args
	p_loop			mi.nominal,		-- Element number of Constrained Loop
	p_partition		mi.name			-- Class within same Constrained Loop as Association
) returns void as 
$$
--
-- UI: Single assigner to multiple
--
-- Changes the specified Single Assigner to a Multiple Assigner.
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
	-- Call the app
	perform method_single_assigner_to_multiple( p_rnum, p_domain, p_loop, p_partition );
end
$$
language plpgsql;
