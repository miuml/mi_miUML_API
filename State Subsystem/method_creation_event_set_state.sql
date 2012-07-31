create or replace function mistate.method_creation_event_set_state(
	-- ID
	p_cnum			creation_event.cnum%type,
	p_cname			miclass.class.name%type,	-- For error reporting
	p_to_state		creation_event.to_state%type,
	p_domain		creation_event.domain%type,
	-- Args
	p_new_to_state	creation_event.to_state%type
) returns void as 
$$
--
-- UI: Set creation state
--
-- Changes the State where instances are created with an existing Creation Event.
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
	self	creation_event%rowtype;
	
begin
	update creation_event set to_state = p_new_to_state where 
		cnum = p_cnum and to_state = p_to_state and domain = p_domain
		returning * into strict self;

exception
	when no_data_found then raise exception
		'Creation event to state [%] of class [%::%] does not exist.',
			p_to_state, p_cname, p_domain;
	when foreign_key_violation then
		perform * from state where
			name = p_new_to_state and state_model = p_cnum and sm_type = 'lifecycle' and
			domain = p_domain;
		if not found then raise exception
			'UI: Dest state [%] on class [%::%] does not exist.',
			p_new_to_state, p_cname, p_domain;
		end if;
end
$$
language plpgsql;
