create or replace function mistate.UI_getall_transitions_in_state_model(
	-- IN
	p_state_model	text,		-- Class name or rnum, quoted	
	p_domain		mi.name,	-- in this Domain
	-- OUT
	o_from_state		OUT mi.name,
	o_to_state			OUT mi.name,
	o_evname			OUT mi.name
) returns setof record as
$$
--
-- Query: Get all transitions in state model
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
		select
		state,
		destination,
		method_event_get_name( transition.event, v_sm_name, v_sm_type, p_domain )
		from transition where
			state_model = v_sm_name and sm_type = v_sm_type and domain = p_domain;
end
$$
language plpgsql;
