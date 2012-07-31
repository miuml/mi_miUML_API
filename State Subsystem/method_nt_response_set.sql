create or replace function mistate.method_nt_response_set(
	p_state			nt_response.state%type,
	p_event			nt_response.event%type,
	p_state_model	nt_response.state_model%type,	-- cnum or rnum
	p_sm_type		nt_response.sm_type%type,		-- lifecycle or assigner
	p_domain		nt_response.domain%type,		-- Domain
	p_behavior		nt_response.behavior%type,		-- May be NULL
	p_reason		nt_response.reason%type			-- May be NULL
) returns void as 
$$
--
-- Updates the behavior and/or reason values of this NT Response.
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
	self	nt_response%rowtype;	-- To assert that exactly one nt_response exists
begin
	-- Case 1: Both values updated
	if ( p_behavior is not NULL ) and ( p_reason is not NULL ) then
		update nt_response set behavior = p_behavior, reason = p_reason where
			state = p_state and event = p_event and state_model = p_state_model and
			sm_type = p_sm_type and domain = p_domain returning * into strict self;
		return;
	end if;

	-- Case 2: Behavior updated
	if p_behavior is not NULL then
		update nt_response set behavior = p_behavior where
			state = p_state and event = p_event and state_model = p_state_model and
			sm_type = p_sm_type and domain = p_domain returning * into strict self;
		return;
	end if;

	-- Case 3: Reason updated
	update nt_response set reason = p_reason where
		state = p_state and event = p_event and state_model = p_state_model and
		sm_type = p_sm_type and domain = p_domain returning * into strict self;
end
$$
language plpgsql;
