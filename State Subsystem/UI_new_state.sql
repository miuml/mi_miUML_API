create or replace function mistate.UI_new_state(
	-- New
	p_state			text,		-- mi.name: Name of a State
	-- Existing
	p_state_model	text,		-- mi.name or mi.nominal: class name or rnum
	p_domain		mi.name,	-- In this Domain
	-- Modify
	p_snum			mi.nominal default null -- Desired state number
) returns mi.nominal as -- The assigned state number
$$
--
-- UI: New state
--
-- Creates a new State in the specified State Model.  Uses the optional state number
-- if it is not currently in use in the same State Model.  Otherwise, the lowest available
-- number is assigned.  In either case the number is returned.  Fails if the State Model
-- does not exist or it already has a State with the same name.
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
	v_name			mi.name;
	v_state_model	mi.nominal;
	v_sm_type		miuml.sm_type;
	sm_err_name		text;
begin
	select * from method_state_model_locate( p_state_model, p_domain )
		into v_state_model, v_sm_type, sm_err_name;
	
	begin -- Check for valid input
		v_name := trim( p_state );
	exception
		when check_violation then
			raise exception 'UI: State name [%] violates format.', p_state;
	end;

	return method_state_new(
		v_name, v_state_model, v_sm_type, p_domain, sm_err_name, p_snum
	);
end
$$
language plpgsql;
