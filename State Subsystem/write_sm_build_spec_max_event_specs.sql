create or replace function mistate.write_sm_build_spec_max_event_specs(
	-- args
	p_ceiling		state_model_build_spec.max_event_specs%type
) returns void as 
$$
--
-- Write: State Model Build Spec.Max event specs
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
	if p_ceiling < max(number) from event_spec then raise exception
		'UI: Max event spec value [%] is lower than the highest existing event spec number.',
		p_ceiling;
	end if;

	update state_model_build_spec set max_event_specs = p_ceiling where 
		name = 'singleton';
	if not found then raise exception
		'SYS: State build spec missing.';
	end if;
end
$$
language plpgsql;
