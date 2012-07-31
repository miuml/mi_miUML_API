create or replace function mipoly.method_event_spec_get_transitions(
	-- ID
	p_ev_name		event_spec.name%type,
	p_state_model	event_spec.state_model%type,
	p_sm_type		event_spec.sm_type%type,
	p_domain		event_spec.domain%type
) returns setof mistate.transition as 
$$
--
-- Method: Event Specification.Get transitions -> Transitions
--
-- Returns all Transition objects triggered by this Event Specification.  If the
-- Event Spec is monomorphic, they will all be on the same State Model as that of
-- the Event Spec.  If polymorphic, Transitions may exist on multiple Lifecycle State
-- Models.
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
	self			event_spec%rowtype;
	ldel_id			local_delegated_event.id%type;

begin
	select * into strict self from event_spec where
		name = p_ev_name and
		state_model = p_state_model and sm_type = p_sm_type and
		domain = p_domain;

	-- Build up a set of Effective Signaling Events with Transition Responses
	-- and return them
	perform * from monomorphic_event_spec where
		number = self.number and
		state_model = self.state_model and sm_type = self.sm_type and
		domain = self.domain;

	if found then return query -- Monomorphic
		select tr.* from local_effective_event as lee join mistate.transition as tr on (
			lee.id = tr.event and
			lee.state_model = tr.state_model and lee.sm_type = tr.sm_type and
			lee.domain = tr.domain
		) where lee.ev_spec = self.number and
			lee.state_model = self.state_model and lee.sm_type = self.sm_type and
			lee.domain = self.domain; -- All on the same State Model
	end if;

	-- Must be polymorphic
	-- get all Inherited Effective Events and join with Transitions

	-- First we need the ID of the topmost Local Delegated Event
	select id into ldel_id from
		polymorphic_event_spec as pes join local_delegated_event as lde on (
			pes.number = lde.ev_spec and
			pes.cnum = lde.cnum and
			pes.domain = lde.domain
		) where pes.number = self.number and pes.cnum = self.state_model and
			pes.domain = self.domain;

	return query
		select tr.* from method_del_event_getall_eff_event(
			ldel_id, self.state_model, self.domain
		) as iee join mistate.transition as tr on (
			iee.id = tr.event and
			iee.cnum = tr.state_model and
			iee.domain = tr.domain
		) where tr.sm_type = 'lifecycle' and tr.domain = self.domain;
		-- Many State Models, but only Lifecycles
end
$$
language plpgsql;
