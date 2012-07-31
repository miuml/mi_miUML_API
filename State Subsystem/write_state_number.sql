create or replace function mistate.write_state_number(
	-- ID
	p_name			state.name%type,
	p_sm_name		state.state_model%type,
	p_sm_type		state.sm_type%type,
	p_domain		state.domain%type,
	-- Args
	p_new_number	state.snum%type,
	p_sm_err_name	text
) returns void as 
$$
--
-- Write: State.Number
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
declare
	self	destination%rowtype;

begin
	update state set snum = p_new_number where 
		name = p_name and state_model = p_sm_name and
		sm_type = p_sm_type and domain = p_domain;
	
	if not found then
		raise exception 'UI: State [%] not found on state model [%::%]',
			p_name, p_sm_err_name, p_domain;
	end if;

exception
	when unique_violation then raise exception
		'UI: State number [%] already taken on state model [%::%]',
			p_new_number, p_sm_err_name, p_domain;
end
$$
language plpgsql;
