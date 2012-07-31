create or replace function mistate.method_transition_migrate_nt(
	p_behavior		nt_response.behavior%type,	-- [ CH | IGN ]
	p_reason		nt_response.reason%type,
	p_state			transition.state%type,
	p_evid			transition.event%type,
	p_sm_name		transition.state_model%type,
	p_sm_type		transition.sm_type%type,
	p_domain		transition.domain%type,
	p_sm_err_name	text
) returns void as 
$$
--
-- Method: Transition.Migrate to Non Transition Response
--
-- Migrates a Transition to a Non Transition Response of the specified behavior.
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
	delete from transition where
		state = p_state and event = p_evid and
		state_model = p_sm_name and sm_type = p_sm_type and
		domain = p_domain;
	if not found then raise exception
		'UI: There is no transition from state [%] on event [%] in state model [%::%].',
		p_state, p_ev_name, p_sm_err_name, p_domain;
	end if;

	insert into nt_response(
		state, event, state_model, sm_type, domain, behavior, reason
	) values(
		p_state, p_evid, p_sm_name, p_sm_type, p_domain, p_behavior, p_reason
	);

end
$$
language plpgsql;
