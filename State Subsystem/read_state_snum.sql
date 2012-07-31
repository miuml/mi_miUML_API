create or replace function mistate.read_state_snum(
	-- id
	p_state			state.name%type,				-- Name of the State
	p_state_model	state.state_model%type,			-- Rnum or Cnum
	p_sm_type		state.sm_type%type,				-- [ lifecycle | assigner ]
	p_domain		state.domain%type,				-- Domain
	-- error
	p_sm_err_name	text							-- Long State Model name for error msg
) returns state.snum%type as 
$$
--
-- Accessor: State.Snum
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
	self			state%rowtype;
begin
	select * into strict self from state where
		name = p_state and
		state_model = p_state_model and sm_type = p_sm_type and
		domain = p_domain;

	return self.snum;

exception
	when no_data_found then
		raise exception 'State [%] does not exist on [%::%].', p_state, p_sm_err_name, p_domain;
end
$$
language plpgsql;
