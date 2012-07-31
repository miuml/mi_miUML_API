create or replace function mistate.UI_delete_transition(
	-- Existing
	p_from_state	mi.name,	-- From State name
	p_event_name	mi.name,	-- Event Specification name
	p_state_model	text,		-- mi.name or mi.nominal: class name or rnum
	p_domain		mi.name,	-- In this Domain
	p_behavior		text default 'CH',		-- 'CH' or 'IGN'
	p_reason		text default 'Transition deleted'
) returns void as 
$$
--
-- UI: Delete transition
--
-- Deletes the specified Transition by migrating it to a Non-Transition Response
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
	v_sm_name		mi.nominal;			-- valid state model name
	v_sm_type		miuml.sm_type;		-- valid state model type
	sm_err_name		text;				-- Readable state model name for error msgs
	v_behavior		miuml.ev_response;	-- valid non transition event behavior
	v_evid			mi.nominal;			-- The event id
begin
	-- Determine the actual state model name
	select * from method_state_model_locate( p_state_model, p_domain )
		into v_sm_name, v_sm_type, sm_err_name;
	
	begin -- Check for valid input
		v_behavior := p_behavior;
	exception
		when invalid_text_representation then
			raise exception 'UI: Event behavior [%] must be IGN or CH.', p_behavior;
	end;

	-- Lookup the event id for the event name
	v_evid := method_state_model_get_evid( v_sm_name, v_sm_type, p_domain, p_event_name );
	
	-- Call the app
	perform method_transition_migrate_nt(
		v_behavior, p_reason, p_from_state, v_evid,
		v_sm_name, v_sm_type, p_domain, sm_err_name
	);
end
$$
language plpgsql;
