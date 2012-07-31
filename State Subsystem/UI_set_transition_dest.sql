create or replace function mistate.UI_set_transition_dest(
	-- Existing
	p_state_name			mi.name,	-- From State name
	p_event_name			mi.name,	-- Name of Event on Transition
	p_state_model			text,		-- Class name or Rnum in quotes
	p_domain				mi.name,
	p_dest_name				mi.name		-- New Destination
) returns void as 
$$
--
-- UI: Set transition destination
--
-- Changes the Destination of an existing Transition.
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
	v_new_sname		mi.name;
	v_evid			mi.nominal;
begin
	-- Get the state model identifier
	select * from method_state_model_locate( p_state_model, p_domain )
		into v_sm_name, v_sm_type, sm_err_name;

	-- Get the event id
	v_evid := method_state_model_get_evid( v_sm_name, v_sm_type, p_domain, p_event_name );

	-- Call the app
	perform method_transition_set_dest(
		p_state_name, p_event_name, v_evid, v_sm_name, v_sm_type, p_domain,
		p_dest_name, sm_err_name
	);
end
$$
language plpgsql;
