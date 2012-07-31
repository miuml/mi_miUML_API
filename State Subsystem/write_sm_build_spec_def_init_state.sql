create or replace function mistate.write_sm_build_spec_def_init_state(
	-- args
	p_name		state_model_build_spec.default_initial_state%type
) returns void as 
$$
--
-- Write: State Model Build Spec.Default initial state
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
begin
	update state_model_build_spec set default_initial_state = p_name where 
		name = 'singleton';
	if not found then raise exception
		'SYS: State build spec missing.';
	end if;
end
$$
language plpgsql;
