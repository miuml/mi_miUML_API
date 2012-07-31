create or replace function mistate.method_transition_new(
	p_state			transition.state%type,
	p_ev_spec		mipoly.event_spec.name%type,		-- Event Spec name
	p_sm_name		transition.state_model%type,
	p_sm_type		transition.sm_type%type,
	p_domain		transition.domain%type,
	p_dest			transition.destination%type,
	p_sm_err_name	text
) returns void as 
$$
--
-- Method: Transition.New
--
-- Creates a new Transition Event Response on the specified State for the specified Event to
-- the specified Destination.
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
	my_evid 	transition.event%type;
begin
	-- Verify that the Event Spec exists
	perform * from event_spec where name = p_ev_spec and domain = p_domain;
	if not found then
		raise exception 'UI: Event [%] not defined on [%::%].',
			p_ev_spec, p_sm_err_name, p_domain;
	end if;

	-- Get the Event ID.
	my_evid	:= method_state_model_get_evid( p_sm_name, p_sm_type, p_domain, p_ev_spec );
	-- Assertion, my_evid not null;
	if my_evid is NULL then raise exception
		'SYS: No evid found while trying to create new transition.';
	end if;

	-- Verify that the event and dest signatures match
	if not mipoly.method_event_sig_compare(
		p_ev_spec, p_sm_name, p_sm_type, p_domain, p_dest
	) then
		-- Is the event used anywhere else?
		perform * from transition where 
			event = my_evid and state != p_state and
			state_model = p_sm_name and sm_type = p_sm_type and
			domain = p_domain;
		if not found then
			-- The event is used only on this transition, change its signature
			-- to make it compatible with the destination state
			perform mipoly.method_event_sig_copy(
				p_ev_spec, p_sm_name, p_sm_type, p_domain, p_dest
			);
		else
			raise exception
				'UI: Event sig is incompatible with dest state signature.';
		end if;
	end if;

	-- Create the Transition instance
	begin
		insert into transition( state, event, state_model, sm_type, domain, destination )
			values( p_state, my_evid, p_sm_name, p_sm_type, p_domain, p_dest );
	exception
		when unique_violation then
			-- There is already a Transition Event Response (possibly to another Destination)
			raise exception 'UI: A transition from state [%] on event [%] is already specified.',
				p_state, p_ev_spec;
		when foreign_key_violation then
			-- Destination missing?
			perform * from destination where
				name = p_state and
				state_model = p_sm_name and sm_type = p_sm_type and
				domain = p_domain;
			if not found then
				raise exception 'UI: Destination state [%] does not exist in [%::%].',
					p_state, p_sm_err_name, p_domain;
			end if;
			-- The only other possibility is that the Event Response is missing, but
			-- we've already established that the Event exists, so an Event Response
			-- must be defined.  Otherwise we have a non-user / system error.
	end;

	-- Delete the Non Transition Event Response instance
	delete from nt_response where
		state = p_state and event = my_evid and
		state_model = p_sm_name and sm_type = p_sm_type and
		domain = p_domain;
	-- It must be there, so no error checking
end
$$
language plpgsql;
