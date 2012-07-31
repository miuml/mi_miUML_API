create or replace function mistate.method_transition_set_dest(
	-- ID
	p_state			transition.state%type,
	p_ev_name		mipoly.event_spec.name%type,
	p_evid			transition.event%type,
	p_sm_name		transition.state_model%type,
	p_sm_type		transition.sm_type%type,
	p_domain		transition.domain%type,
	-- Args
	p_dest			transition.destination%type,
	p_sm_err_name	text
) returns void as 
$$
--
-- Method: Transition.Set destination
--
-- Points a Transition to a new Destination in the same State Model.
-- The Signatures of the Transition's Event and the destination State
-- must match.  If they do not initially, the Event Signature will be updated
-- to match the destination if the Event is not used on any other Transition.
-- Otherwise, the operation will fail and it will be necessary for the user to
-- first update the Event, Destination or both Signatures before proceeding.
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
	self			transition%rowtype;
begin
	begin -- Validate existence of the Transition
		select * into strict self from transition where
			state = p_state and event = p_evid and state_model = p_sm_name and
			sm_type = p_sm_type and domain = p_domain;
	exception
		when no_data_found then raise exception
			'UI: Transition from [%] on event [%] not found on [%::%].',
				p_state, p_ev_name, p_sm_err_name, p_domain;
	end;
	
	--raise info 'Comparing ev[%] on dest state[%]', p_ev_name, p_dest;
	if not mipoly.method_event_sig_compare(
		p_ev_name, self.state_model, self.sm_type, self.domain, p_dest
	) then
		--raise info 'Event and dest signatures are different.';
		-- Is the event used anywhere else?
		perform * from transition where 
			event = self.event and state != self.state and
			state_model = self.state_model and sm_type = self.sm_type and
			domain = self.domain;
		if not found then
			--raise info 'The event is not used on any other transition, copying.';
			-- The event is used only on this transition, change its signature
			-- to make it compatible with the destination state
			perform mipoly.method_event_sig_copy(
				p_ev_name, self.state_model, self.sm_type, self.domain, p_dest
			);
		else
			raise exception
				'UI: Event sig is incompatible with dest state signature.';
		end if;
	end if;

	begin
		update transition set destination = p_dest where
			state = self.state and event = self.event and
			state_model = self.state_model and sm_type = self.sm_type and
			domain = self.domain;
	exception
		when foreign_key_violation then raise exception
			'UI: Destination [%] does not exist in state model [%::%].',
				p_dest, p_sm_err_name, self.domain;
	end;
end
$$
language plpgsql;
