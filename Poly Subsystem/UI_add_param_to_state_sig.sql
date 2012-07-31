create or replace function mipoly.UI_add_param_to_state_sig(
	-- New
	p_param			text,					-- mi.name: Name of parameter
	-- Existing
	p_type			mi.compound_name,		-- Name of a Constrained Type
	p_state			mi.name,				-- Destination name (State or Deletion Pseudo State)
	p_state_model	text,					-- mi.name or mi.nominal: state name or ev_spec num
	p_domain		mi.name
) returns void as 
$$
--
-- UI: Add parameter to state
--
-- Defines a new State Model Parameter and associates it with an existing State Model Signature.
-- An attempt is made to update each of the Event Signatures associated with any Signaling
-- Events on Transitions leading into the State.
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
	v_param			mi.name;
	v_sm_name		mi.nominal;
	v_sm_type		miuml.sm_type;
	sm_err_name		text;
begin
	-- Validate parameter name
	begin
		v_param := trim( p_param );
	exception
		when check_violation then
			raise exception 'UI: Parameter name [%] violates format.', p_param;
	end;

	-- Compose state model name
	select * from method_state_model_locate( p_state_model, p_domain )
		into v_sm_name, v_sm_type, sm_err_name;

	-- Call the app
	perform method_state_sig_add_param(
		v_param, p_type, p_state, v_sm_name, v_sm_type, p_domain, sm_err_name
	);
end
$$
language plpgsql;
