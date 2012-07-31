create or replace function mistate.UI_set_dest_name(
	-- Existing
	p_state_name			mi.name,	-- Old Destination name
	p_state_model			text,		-- Class name or Rnum in quotes
	p_domain				mi.name,	-- The Destination is in this Domain
	-- New
	p_new_state_name		text		-- mi.name: New Destination name
) returns void as 
$$
--
-- UI: Set dest name
--
-- Renames a Destination (State or Deletion Pseudo State).
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
	v_sm_name		mi.nominal;
	v_sm_type		miuml.sm_type;
	sm_err_name		text;
	v_new_sname		mi.name;
begin
	select * from method_state_model_locate( p_state_model, p_domain )
		into v_sm_name, v_sm_type, sm_err_name;

	-- Input validation
	begin
		v_new_sname := trim( p_new_state_name );
	exception
		when check_violation then
			raise exception 'UI: New state name [%] violates format.', p_new_state_name;
	end;

	-- Invoke function
	perform write_dest_name( p_state_name, v_sm_name, v_sm_type, p_domain, v_new_sname );
end
$$
language plpgsql;
