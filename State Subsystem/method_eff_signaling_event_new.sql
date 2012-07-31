create or replace function mistate.method_eff_signaling_event_new(
	p_evid			effective_signaling_event.id%type,
	p_sm_name		effective_signaling_event.state_model%type,
	p_sm_type		effective_signaling_event.sm_type%type,
	p_domain		effective_signaling_event.domain%type,
	p_sm_err_name	text
) returns void as 
$$
--
-- Method: Effective Signaling Event.New
--
-- Creates a new non-polymorphic Signaling Event on the specified Lifecycle.
--
-- A Non-Transition Response of 'Can't Happen' is created by default for each State
-- in the State Model.
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
	NEW_EVENT		text := 'newly defined';
	this_state		state%rowtype;
begin
	-- raise info 'evid[%], sm[%:%::%]', p_evid, p_sm_name, p_sm_type, p_domain;

	-- Create my instance
	insert into effective_signaling_event( id, state_model, sm_type, domain ) values(
		p_evid, p_sm_name, p_sm_type, p_domain
	);

	-- Create Event Response for each State initially as Can't Happen
	for this_state in
		select * from state where
			state_model = p_sm_name and sm_type = p_sm_type and domain = p_domain
	loop
		perform method_nt_response_new(
			this_state.name, p_evid, p_sm_name, p_sm_type, p_domain, 'CH', NEW_EVENT
		);
	end loop;
end
$$
language plpgsql;
