create or replace function mipoly.method_event_spec_assign_num(
	p_sm_name		event_spec.state_model%type,
	p_sm_type		event_spec.sm_type%type,
	p_domain		event_spec.domain%type,
	p_ev_num		mipoly.event_spec.number%type default null	-- Optional desired ev num
) returns event_spec.number%type as 
$$
--
-- Method: Event Spec.Assign num
--
-- Assigns the next available Event number for the specified State Model.  If a particular
-- event number is requested, it is returned, if available.
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
	the_sbspec			state_model_build_spec%rowtype;
	new_evnum			mi.nominal;			-- The newly issued cnum
	try_evnum			mi.nominal;
begin
	--raise info 'event_spec_assign_num > sm[%:%::%] desired evnum[%]',
		--p_sm_name, p_sm_type, p_domain, p_ev_num;

	-- Get the max number of event specifications
	begin
		select * into strict the_sbspec from
			mistate.state_model_build_spec where name = 'singleton';
	exception
		when no_data_found then
			raise exception 'SYS: State Model Build Specification not initialized';
	end;

	-- Use the requested event number if it is not already taken
	if p_ev_num is not null then
		-- raise info 'not null';
		if p_ev_num between 1 and the_sbspec.max_event_specs then
			-- raise info 'in range';
			perform * from event_spec where
				number = p_ev_num and 
				state_model = p_sm_name and sm_type = p_sm_type and
				domain = p_domain;
			if not found then return p_ev_num; end if;
		end if; -- valid
	end if; -- not null

	-- Find an unused evnum
	try_evnum := 1;
	-- raise info 'Initially trying [%]', try_evnum;
	loop
		-- Loop through the number range looking for the lowest available evnum
		-- There aren't that many events on a state model so this
		-- simple looping mechanism should be fast enough.

		perform * from event_spec where
			number = try_evnum and 
			state_model = p_sm_name and sm_type = p_sm_type and
			domain = p_domain;
		if not found then -- The evnum not currently in use.
			-- raise info 'Returning [%]', try_evnum;
			return try_evnum;
		end if;

		-- Increment and loop unless there is a crazy number of event specs defined
		try_evnum := try_evnum + 1;
		if try_evnum > the_sbspec.max_event_specs then
			-- There are WAY too many event specs on this state model
			raise exception 'SYS: No more evnums available for state model [%-%].',
				p_sm_type, p_sm_name;
		end if;
	end loop;
end
$$
language plpgsql;
