create or replace function mistate.UI_new_transition(
	-- Existing
	p_from_state	mi.name,
	p_dest			mi.name,	-- Name of a Destination (State or Deletion Pseudo State)
	p_event_spec	mi.name,	-- Event Specification name
	p_state_model	text,		-- mi.name or mi.nominal: class name or rnum
	p_domain		mi.name		-- In this Domain
) returns void as 
$$
--
-- UI: New transition
--
-- Creates a Transition from a State to a Destination State or Deletion Pseudo State.
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
begin
	-- Determine the actual state model name
	select * from method_state_model_locate( p_state_model, p_domain )
		into v_sm_name, v_sm_type, sm_err_name;
	
	-- Call the app
	perform method_transition_new(
		p_from_state, p_event_spec, v_sm_name, v_sm_type, p_domain, p_dest, sm_err_name
	);
end
$$
language plpgsql;
