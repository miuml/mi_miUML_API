create or replace function mistate.UI_set_creation_state(
	-- Exists
	p_cname			mi.name,		-- Creation event class
	p_to_state		mi.name,		-- Current target state
	p_domain		mi.name,
	p_new_to_state	mi.name			-- New target state
) returns void as 
$$
--
-- UI: Set creation state
--
-- Changes the State where instances are created with an existing Creation Event.
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
declare
	v_cnum		creation_event.cnum%type;
begin
	-- Get the cnum
	v_cnum := miclass.read_class_cnum( p_cname, p_domain );

	-- Call the app
	perform method_creation_event_set_state(
		v_cnum, p_cname, p_to_state, p_domain, p_new_to_state
	);
end
$$
language plpgsql;
