create or replace function mistate.UI_getall_responses_in_state_model(
	-- IN
	p_state_model	text,		-- Class name or rnum, quoted	
	p_domain		mi.name,	-- in this Domain
	-- OUT
	o_state				OUT mi.name,
	o_ev_name			OUT mi.name,
	o_dest_state		OUT mi.name,
	o_nt_resp			OUT miuml.ev_response,
	o_reason			OUT mi.description
) returns setof record as
$$
--
-- Query: Get all transition and non-transition responses in state model
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
	v_sm_name		mi.nominal;
	v_sm_type		miuml.sm_type;
	sm_err_name		text;
begin
	-- First convert the specified name into an Rnum or Cnum
	-- (reports error if neither exists)
	select * from method_state_model_locate( p_state_model, p_domain )
		into v_sm_name, v_sm_type, sm_err_name;

	return query
		select state, ev_name, destination::mi.name,
			behavior::miuml.ev_response, reason::mi.description from event_response join(
			select
				state, event,
				method_event_get_name( event, v_sm_name, v_sm_type, p_domain ) as ev_name,
				state_model, sm_type,
				destination, null as behavior, null as reason,
				domain from transition
			union select
				state, event,
				method_event_get_name( event, v_sm_name, v_sm_type, p_domain ) as ev_name,
				state_model, sm_type,
				null as destination, behavior, reason,
				domain from nt_response
			) as erun using( state, event, state_model, sm_type, domain )
			where state_model = v_sm_name and sm_type = v_sm_type and domain = p_domain;
end
$$
language plpgsql;
