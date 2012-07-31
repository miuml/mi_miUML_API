create or replace function mipoly.UI_delete_event(
	-- Existing
	p_state_model	text,		-- mi.name or mi.nominal: class name or rnum
	p_ev_name		mi.name,	-- Name of an Event Specification
	p_domain		mi.name		-- In this Domain
) returns void as 
$$
--
-- UI: Delete event
--
-- Deletes an Event Specification and any corresponding Events.  If this is a
-- Monomorphic Event Specification, then only one Event will be deleted.  Otherwise, it
-- is polymorphic and all descendant Events (Inherited / Delegated) will be deleted.
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
	v_state_model		mi.nominal;
	v_sm_type			miuml.sm_type;
	sm_err_name			text;
begin
	select * from mistate.method_state_model_locate( p_state_model, p_domain )
		into v_state_model, v_sm_type, sm_err_name;

	-- Call the app
	perform method_event_spec_delete(
		p_ev_name, v_state_model, v_sm_type, p_domain,
		sm_err_name
	);
end
$$
language plpgsql;
