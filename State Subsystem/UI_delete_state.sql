create or replace function mistate.UI_delete_state(
	-- Existing
	p_state			mi.name,	-- mi.name: Name of a State
	p_state_model	text,		-- mi.name or mi.nominal: class name or rnum
	p_domain		mi.name		-- In this Domain
) returns void as
$$
--
-- UI: Delete state
--
-- Deletes the specified State or Deletion Pseudo State.
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
	-- Compose the state model name
	select * from method_state_model_locate( p_state_model, p_domain )
		into v_sm_name, v_sm_type, sm_err_name;

	-- Call the app
	perform method_dest_delete( p_state, v_sm_name, v_sm_type, p_domain, sm_err_name );
end
$$
language plpgsql;
