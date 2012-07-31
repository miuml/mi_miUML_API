create or replace function mistate.method_event_response_new(
	p_state			nt_response.state%type,
	p_event			nt_response.event%type,
	p_state_model	nt_response.state_model%type,	-- cnum or rnum
	p_sm_type		nt_response.sm_type%type,		-- lifecycle or assigner
	p_domain		nt_response.domain%type		-- Domain
) returns void as 
$$
--
-- Creates a new Event Response, driven by subclasses.
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
	insert into event_response( state, event, state_model, sm_type, domain )
		values( p_state, p_event, p_state_model, p_sm_type, p_domain );

exception
	when foreign_key_violation then
		-- Missing State?
		perform * from state where
			name = p_state and
			state_model = p_state_model and sm_type = p_sm_type and
			domain = p_domain;
		if not found then
			raise exception 'UI: State [%] does not exist.', p_state;
		end if;
		-- Missing Signaling Event?
		perform * from signaling_event where
			id = p_event and
			state_model = p_state_model and sm_type = p_sm_type and
			domain = p_domain;
		if not found then
			raise exception 'UI: Signaling Event [%] does not exist.', p_event;
		end if;
	when unique_violation then
		raise exception 'UI: Event response already defined for event [%] on state [%].',
			p_event, p_state;
end
$$
language plpgsql;
