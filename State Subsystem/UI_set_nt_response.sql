create or replace function mistate.UI_set_nt_response(
	-- Existing
	p_state_name			mi.name,	-- From State name
	p_event_name			mi.name,	-- Name of Event on Transition
	p_state_model			text,		-- Class name or Rnum in quotes
	p_domain				mi.name,
	-- Args
	p_behavior				text	default NULL,	-- miuml.ev_response: 'CH' or 'IGN'
	p_reason				text	default NULL	-- mi.description
) returns void as 
$$
--
-- UI: Set non transition response( behavior, reason )
--
-- Sets the behavior and reason characteristics of an existing Non-Transition Event Response.
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
	v_evid			mi.nominal;

	v_behavior		mi.name;
	v_reason		mi.description;
	all_args_null	boolean default true;

begin
	-- Get the state model identifier
	select * from method_state_model_locate( p_state_model, p_domain )
		into v_sm_name, v_sm_type, sm_err_name;
	
	-- Get the event id
	v_evid := method_state_model_get_evid( v_sm_name, v_sm_type, p_domain, p_event_name );

	if p_behavior is not NULL then
		begin -- Check for valid input
			v_behavior := p_behavior;
		exception
			when invalid_text_representation then
				raise 'UI: Behavior type [%] must be IG or CH.', p_behavior;
		end;
		all_args_null := false;
	end if;

	if p_reason is not NULL then
		begin -- Check for valid input
			v_reason := p_reason;
		exception
			when check_violation then
				raise exception 'UI: Reason [%] violates format.', p_reason;
		end;
		all_args_null := false;
	end if;

	if all_args_null then raise exception
		'UI: No args specified.';
	end if;
	
	-- Call the app
	perform method_nt_response_set(
		p_state_name, v_evid, v_sm_name, v_sm_type, p_domain,
		v_behavior, v_reason
	);
end
$$
language plpgsql;
