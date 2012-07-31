create or replace function mipoly.method_state_model_assign_snum(
	p_sm_name		state.state_model%type,
	p_sm_type		state.sm_type%type,
	p_domain		state.domain%type,
	p_snum			state.snum%type default null	-- Optional desired ev num
) returns state.snum%type as 
$$
--
-- Method: State Model.Assign snum
--
-- Assigns the next available State number (snum) for the specified State Model.  If a particular
-- snum is requested, it is returned, if available.
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
	the_sbspec			state_model_build_spec%rowtype;  -- Provides max states value
	new_snum			mi.nominal;			-- The newly issued snum
	try_snum			mi.nominal;			-- Potentially available snum
begin
	-- Get the max number of states allowed in a state model
	begin
		select * into strict the_sbspec from
			mistate.state_model_build_spec where name = 'singleton';
	exception
		when no_data_found then
			raise exception 'SYS: State Model Build Specification not initialized';
	end;

	-- Use the requested state number if it is not already taken
	if p_snum is not null then
		if p_snum between 1 and the_sbspec.max_states then
			perform * from state where
				snum = p_snum and 
				state_model = p_sm_name and sm_type = p_sm_type and
				domain = p_domain;
			if not found then return p_snum; end if;
		end if; -- valid
	end if; -- not null

	-- Find an unused snum
	try_snum := 1;
	loop
		-- Loop through the number range looking for the lowest available snum
		-- There aren't that many states on a state model so this
		-- simple looping mechanism should be fast enough.

		perform * from state where
			snum = try_snum and 
			state_model = p_sm_name and sm_type = p_sm_type and
			domain = p_domain;
		if not found then -- The snum not currently in use.
			return try_snum;
		end if;

		-- Increment and loop unless there is a crazy number of states defined
		try_snum := try_snum + 1;
		if try_snum > the_sbspec.max_states then
			-- There are WAY too many states on this state model
			raise exception 'SYS: No more snums available for state model [%-%].',
				p_sm_type, p_sm_name;
		end if;
	end loop;
end
$$
language plpgsql;
