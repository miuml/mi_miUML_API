create or replace function mistate.UI_getall_states_in_state_model(
	-- IN
	p_state_model	text,		-- Class name or rnum, quoted	
	p_domain		mi.name,	-- in this Domain
	-- OUT
	o_name			OUT mi.name,
	o_snum			OUT mi.nominal
) returns setof record as  -- State name and number or NULL if pseudostate
$$
--
-- Query: Get all states in state model
--
-- Returns the name and number for each State and the name of each
-- Deletion Pseudo State in the specified State Model.
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
	select destination.name, snum::mi.nominal from destination join(
		select name, snum, state_model, sm_type, domain from state union
		select name, NULL as snum, cnum as state_model, sm_type, domain from deletion_pstate
	) as x using( state_model, sm_type, domain ) where
		state_model = v_sm_name and sm_type = v_sm_type and domain = p_domain order by name;
end
$$
language plpgsql;
