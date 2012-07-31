create or replace function mistate.method_state_model_get_evid(
	-- ID
	p_sm_name		event_spec.state_model%type,
	p_sm_type		event_spec.sm_type%type,		
	p_domain		event_spec.domain%type,
	-- Args
	p_ev_spec		event_spec.name%type
) returns mipoly.event.id%type as 
$$
--
-- Method: State Model.Get evid( Event Spec Name ) -> Event ID
--
-- Locates the Event ID associated with the supplied Event Specification for this
-- State Model.  With non-polymorphic Events, this is simply the ID of the Local
-- Effective Signaling Event associated with the Event Spec.  For a polymorphic
-- Event, it is necessary to find the Inherited Effective Event ID associated with
-- the given Event Specification.
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
begin
	-- Monomorohic case
	 <<monomorphic>>
	declare
		local_evid		mipoly.local_effective_event.id%type;
		ev_spec_num		mipoly.event_spec.number%type;
	begin
		-- If the event spec's state model does not match the supplied state model
		-- this is not a monomorphic event and the read will throw an exception
		-- moving us on to the polymorphic case below
		ev_spec_num = mipoly.read_event_spec_number(
				p_ev_spec, p_sm_name, p_sm_type, p_domain
		); -- Exception triggered if no match
		select id from local_effective_event where
			ev_spec = ev_spec_num and state_model = p_sm_name and sm_type = p_sm_type and
			domain = p_domain into local_evid;
		-- No exception so the Local Effective Event should always be found
		if not found then raise exception 'SYS: Local eff event not found in mono case.'; end if;
		return local_evid;
	exception
		when no_data_found then
			exit monomorphic;
	end;

	-- Polymorphic case
	<<polymorphic>>
	declare
		this_event			mipoly.inherited_effective_event%rowtype;
		this_evspec_num		mipoly.event_spec.number%type;
		this_ev_name		mipoly.event_spec.name%type;
		no_events_found		boolean; -- For debugging
	begin
		-- Check each Inherited Effective Event to find the one that is associated
		-- wtih the given event spec
		no_events_found = true;
		for this_event in
			select * from inherited_effective_event where 
				cnum = p_sm_name and domain = p_domain
		loop
			no_events_found = false;
			this_ev_name = method_event_get_name(
				this_event.id, p_sm_name, 'lifecycle', p_domain
			);
			if this_ev_name = p_ev_spec then
				return this_event.id;
			end if;
		end loop;

		-- Debugging
		-- We should have returned by now, so one of two things is wrong
		if no_events_found then
			raise exception 'SYS: No inh effective events found on lifecycle.';
		else
			raise exception 'SYS: Poly spec not found for any inh eff event on lifecycle.';
		end if;
	end;
end
$$
language plpgsql;
