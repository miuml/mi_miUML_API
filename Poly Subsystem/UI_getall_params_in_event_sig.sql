create or replace function mistate.UI_getall_params_in_event_sig(
	-- IN
	p_ev_spec		text,		-- Event Specification name
	p_state_model	text,		-- Class name or rnum, quoted	
	p_domain		mi.name,	-- in this Domain
	-- OUT
	o_param				OUT mi.name,
	o_type				OUT mi.name
) returns setof record as
$$
--
-- Query: Returns the name and type of each State Model Parameter in the supplied
--        Event Specification.
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

	-- Does the Event Spec actually exist?
	perform * from event_signature where
		 ev_spec = p_ev_spec and state_model = v_sm_name and sm_type = v_sm_type
		and domain = p_domain;
	if not found then raise exception
		'UI: Event [%] is not defined on state model [%::%].',
		p_ev_spec, sm_err_name, p_domain;
	end if;

	return query select name, type::mi.name
		from state_model_parameter where
			signature = p_ev_spec and sig_type = 'event' and
			sm_type = v_sm_type and domain = p_domain;
end
$$
language plpgsql;
