create or replace function mipoly.method_event_get_spec(
	p_evid			effective_signaling_event.id%type,
	p_sm_name		effective_signaling_event.state_model%type,
	p_sm_type		effective_signaling_event.sm_type%type,
	p_domain		effective_signaling_event.domain%type
) returns event_spec as 
$$
--
-- Method: Event.Get event spec( Event ID, State Model, SM Type, Domain ) - > Ev Spec
--
-- Returns the Event Specification that defines the supplied Event ID.
-- If the Event is a Local Effective Event, then it is and directly
-- related to its Monomorphic Event Spec.  But if the Event is Inherited, it must be
-- traced up the polymorphic event hierarchy to find a Local Delegated Event and,
-- from there, a Polymorphic Event Spec.
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
	ev_name			mi.name;
	ldel_event		local_delegated_event%rowtype;
	found_ev_spec	event_spec%rowtype;
begin
	begin
		-- First try monomorphic
		select es.* into strict found_ev_spec from
			local_effective_event as le join event_spec as es on
				es.number = le.ev_spec and
				es.state_model = le.state_model and
				es.sm_type = le.sm_type and
				es.domain = le.domain
			where id = p_evid;
		return found_ev_spec;
	exception
		when no_data_found then
		begin
			-- Must be polymorphic
			-- Find the Local Delegated Event at the top of the polymorphic tree
			ldel_event := method_event_get_local_del_event( p_evid, p_sm_name, p_domain );
			select es.* into strict found_ev_spec from
				local_delegated_event as ld join event_spec as es on
					es.number = ld.ev_spec and
					es.state_model = ld.cnum and
					es.sm_type = 'lifecycle' and
					es.domain = ld.domain
				where id = p_evid;
			return found_ev_spec;
		exception
			when no_data_found then raise exception
				'SYS: Could not trace root Local Delegated Event from evid[%] sm[% - % :: %].',
					p_evid, p_sm_name, p_sm_type, p_domain;
		end;
	end;
end
$$
language plpgsql;
