create or replace function midom.UI_delete_bridge(
	-- Existing
	p_client		mi.name, 	-- Client Domain
	p_service		mi.name		-- Service Domain
	-- New
) returns void as 
$$
--
-- Removes an existing Bridge.
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
begin
	perform method_bridge_delete( p_client, p_service );
end
$$
language plpgsql;
