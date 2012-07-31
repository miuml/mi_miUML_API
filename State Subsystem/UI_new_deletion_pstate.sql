create or replace function mistate.UI_new_deletion_pstate(
	-- New
	p_state			text,			-- mi.name: Name of state
	-- Exists
	p_class_name	mi.name,		-- Lifecycle state model on this Class
	p_domain		mi.name			-- Domain
) returns void as 
$$
--
-- UI: New deletion pseudo state
--
-- Creates a new Deletion Pseudo State in the specified Lifecycle State Model.
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
	v_state			mi.name;
	v_cnum			mi.nominal;
begin
	-- Validate New parameters
	begin
		v_state := trim( p_state );
	exception
		when check_violation then
			raise exception 'UI: State name [%] violates format.', p_state;
	end;

	-- Get the cnum
	v_cnum := miclass.read_class_cnum( p_class_name, p_domain );

	-- Call the app
	perform method_deletion_pstate_new( v_state, v_cnum, p_class_name, p_domain );
end
$$
language plpgsql;
