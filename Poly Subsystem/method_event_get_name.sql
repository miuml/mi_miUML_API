create or replace function mipoly.method_event_get_name(
	p_evid			effective_signaling_event.id%type,
	p_sm_name		effective_signaling_event.state_model%type,
	p_sm_type		effective_signaling_event.sm_type%type,
	p_domain		effective_signaling_event.domain%type
) returns mi.name as 
$$
--
-- Method: Event.Get name
--
-- Returns the Event Specification name that defines the supplied Event ID.
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
	ev_name		mi.name;
	ldel_event	local_delegated_event%rowtype;
begin
	-- First try monomorphic
	select name from
		local_effective_event join event_spec on
			event_spec.number = local_effective_event.ev_spec and
			event_spec.state_model = local_effective_event.state_model and
			event_spec.sm_type = local_effective_event.sm_type and
			event_spec.domain = local_effective_event.domain
		where id = p_evid limit 1 into ev_name;
	if found then return ev_name; end if;
	
	-- Must be polymorphic

	-- Find the Local Delegated Event at the top of the polymorphic tree
	ldel_event := method_event_get_local_del_event( p_evid, p_sm_name, p_domain );
	select name from
		local_delegated_event join event_spec on
			event_spec.number = local_delegated_event.ev_spec and
			event_spec.state_model = local_delegated_event.cnum and
			event_spec.sm_type = 'lifecycle' and
			event_spec.domain = local_delegated_event.domain
		where id = p_evid limit 1 into ev_name;

	if not found then raise exception
		'SYS: Could not trace root Local Delegated Event from evid[%] sm[% - % :: %].',
			p_evid, p_sm_name, p_sm_type, p_domain;
	end if;

	return ev_name;
end
$$
language plpgsql;
