create or replace function midom.UI_new_bridge(
	-- Existing
	p_client		mi.name,	-- Domain on client side of Bridge
	p_service		mi.name		-- Domain on service side of Bridge
	-- New
) returns void as 
$$
--
-- Creates a new Bridge between a Domain in the client role and another in the service role.
-- A Domain may not bridge to itself.
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
	perform method_bridge_new( p_client, p_service );
end
$$
language plpgsql;
