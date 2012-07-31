create or replace function mistate.UI_set_default_initial_state_name(
	-- New
	p_name		text		-- mi.name: New default name
) returns void as 
$$
--
-- UI: Set default initial state name
--
-- Sets the default name that will be used for the state automatically created
-- with a new State Model.
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
	v_name		mi.name;
begin
	-- Input validation
	begin
		v_name := trim( p_name );
	exception
		when check_violation then
			raise exception 'UI: Default initial state name [%] violates format.', p_name;
	end;

	-- Call app
	perform write_sm_build_spec_def_init_state( v_name );
end
$$
language plpgsql;
