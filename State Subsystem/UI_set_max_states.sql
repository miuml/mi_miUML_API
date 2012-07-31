create or replace function mistate.UI_set_max_states(
	-- New
	p_ceiling		integer		-- mi.posint: New max value
) returns void as 
$$
--
-- UI: Set maximum number of states
--
-- This number is used as the maximum bound when searching for duplicate values during
-- state number assignment.  It should always be MUCH higher than the anticipated
-- maximum states in any single State Model.  Since it is typical to have
-- 1-30 States on a State Model, the number should never be lower than 100.  Too high
-- a value will increast the time it takes to assign a new state number.  So don't
-- make it 1,000,000!  Unless there is some reason to change it, 200 is a safe ceiling.
-- There's something terribly wrong with a State Model that approaches even 30
-- States.
--
-- The number cannot be changed to a value lower than the maximum assigned State
-- number, across ALL domains.  This maximum State number value, can be changed
-- to a lower value so that the ceiling can be lowered, however.
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
	v_ceiling		mi.posint;
begin
	-- Input validation
	begin
		v_ceiling := p_ceiling;
	exception
		when check_violation then raise exception
			'UI: Max states value [%] must be a positive integer.', p_ceiling;
	end;

	-- Call app
	perform write_sm_build_spec_max_states( v_ceiling );
end
$$
language plpgsql;
