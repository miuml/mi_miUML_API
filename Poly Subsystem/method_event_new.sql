create or replace function mipoly.method_event_new(
	p_state_model	event.state_model%type,
	p_sm_type		event.sm_type%type,
	p_domain		event.domain%type
) returns event.id%type as 
$$
--
-- Method: Event.New
--
-- Create a new Event in the specified State Model.  Called by subclass.
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
	my_id	mi.nominal;
	my_sm	mistate.state_model%rowtype;
begin
	-- Get my State Model
	select * into strict my_sm from mistate.state_model where
		name = p_state_model and sm_type = p_sm_type and domain = p_domain;

	-- Assign ID using State Model's sequence
	execute 'select nextval(' || quote_literal( my_sm.evid_generator ) || ')'
		into my_id;

	-- Create event instance
	insert into event( id, state_model, sm_type, domain ) values (
		my_id, p_state_model, p_sm_type, p_domain
	);

	return my_id;
end
$$
language plpgsql;
