create or replace function mistate.UI_set_state_number(
	-- Existing
	p_state_name			mi.name,	-- State name
	p_state_model			text,		-- Class name or Rnum in quotes
	p_domain				mi.name,	-- The Destination is in this Domain
	-- New
	p_new_number			integer		-- mi.nominal: New number to attempt assigning
) returns void as 
$$
--
-- UI: Set state number
--
-- Attempts to change the number of a State.  This will fail if the number is already
-- in use by antother State on the same State Model.
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
	v_new_number	mi.nominal;
begin
	select * from method_state_model_locate( p_state_model, p_domain )
		into v_sm_name, v_sm_type, sm_err_name;

	begin -- Check for valid input
		v_new_number := p_new_number;
	exception
		when check_violation then
			raise exception 'UI: State number [%] must be a positive integer.', p_new_number;
	end;

	-- Invoke function
	perform write_state_number(
		p_state_name, v_sm_name, v_sm_type, p_domain, p_new_number, sm_err_name
	);
end
$$
language plpgsql;
