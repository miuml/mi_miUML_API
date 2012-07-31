create or replace function mistate.method_nt_response_new(
	p_state			nt_response.state%type,
	p_event			nt_response.event%type,
	p_state_model	nt_response.state_model%type,	-- cnum or rnum
	p_sm_type		nt_response.sm_type%type,		-- lifecycle or assigner
	p_domain		nt_response.domain%type,		-- Domain
	p_behavior		nt_response.behavior%type,
	p_reason		nt_response.reason%type
) returns void as 
$$
--
-- Creates a new Non Transition Response on the specified State for the specified Event.
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
	-- Create the Event Response instance
	perform method_event_response_new( p_state, p_event, p_state_model, p_sm_type, p_domain );

	-- Create the Non Transition Response instance
	insert into nt_response( state, event, state_model, sm_type, domain, behavior, reason )
		values( p_state, p_event, p_state_model, p_sm_type, p_domain, p_behavior, p_reason );


	-- All relevant exception handling occurs in the superclass instance creation
	-- and during UI_ input validation
end
$$
language plpgsql;
