create or replace function mistate.UI_get_state_model_build_spec(
	o_default_initial_state		OUT	mi.name,
	o_max_event_specs			OUT	mi.posint,
	o_max_states				OUT	mi.posint
) as 
$$
--
-- Query: Get state model build spec
--
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
declare
	the_spec	state_model_build_spec%rowtype;
begin
	select default_initial_state, max_event_specs, max_states into
		o_default_initial_state, o_max_event_specs, o_max_states from state_model_build_spec
		where name = 'singleton';
end
$$
language plpgsql;
