create or replace function mistate.method_dest_delete(
	-- ID
	p_state			destination.name%type,
	p_sm_name		destination.state_model%type,
	p_sm_type		destination.sm_type%type,
	p_domain		destination.domain%type,
	-- Args
	p_sm_err_name	text
) returns void as 
$$
--
-- Method: Destination.Delete( sm_err_name )
--
-- Deletes an existing Destination
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
	self				destination%rowtype;
	in_trans			transition%rowtype;
begin
	-- Get self, verify existence
	begin
		select * into strict self from destination where
			name = p_state and state_model = p_sm_name and sm_type = p_sm_type and
			domain = p_domain;
	exception
		when no_data_found then raise exception
			'UI: State [%] not found in state model [%::%].',
				p_state, p_sm_err_name, p_domain;
	end;

	-- State?
	
	perform * from state where
		name = self.name and state_model = self.state_model and sm_type = self.sm_type and
		domain = self.domain;
	if found then
		-- Destination is a State
		-- Cannot delete last remaining state, R503 unconditional
		perform * from state where
			name != self.name and
			state_model = self.state_model and sm_type = self.sm_type and
			domain = self.domain;
		if not found then raise exception
			'UI: Cannot delete the last remaining state in a state model.';
		end if;
		-- Delete the associated Creation Event, if any exists
		if p_sm_type = 'lifecycle' then
			-- If it exists, delete the incoming Creation Event
			perform method_creation_event_delete(
				self.state_model, self.name, self.domain, p_sm_err_name
			); -- Fails silently, if it wasn't there
		end if;
	end if;

	-- Migrate all incoming transitions
	for in_trans in
		select * from transition where 
			destination = self.name and
			state_model = self.state_model and sm_type = self.sm_type and
			domain = self.domain
	loop
		perform method_transition_migrate_nt(
			'CH', 'Transition deleted',
			in_trans.state, in_trans.event, in_trans.state_model, in_trans.sm_type,
			in_trans.domain, p_sm_err_name
		);
	end loop;

	-- Delete Destination
	delete from destination where
		name = self.name and
		state_model = self.state_model and sm_type = self.sm_type and
		domain = self.domain;
	
	-- This will cascade through subclasses
end
$$
language plpgsql;
