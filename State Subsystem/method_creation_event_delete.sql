create or replace function mistate.method_creation_event_delete(
	-- ID
	p_cnum			creation_event.cnum%type,
	p_to_state		creation_event.to_state%type,
	p_domain		creation_event.domain%type,
	p_sm_err_name	text
) returns void as 
$$
--
-- Method: Creation Event.Delete
--
-- Deletes a Creation Event's Monomorphic Event Specification along with the Event
-- itself.
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
	self			creation_event%rowtype;
	my_evspec_name	mipoly.event_spec.name%type;
begin
	begin
		select * into strict self from creation_event where
			cnum = p_cnum and to_state = p_to_state and domain = p_domain;
	exception
		when no_data_found then
			return;  -- Do nothing
	end;

	select name from event_spec as es join local_effective_event as le on
		es.number = le.ev_spec and es.state_model = le.state_model and es.sm_type = le.sm_type and
		es.domain = le.domain where le.id = self.id into my_evspec_name;

	perform mipoly.method_event_spec_delete(
		my_evspec_name, p_cnum, 'lifecycle', p_domain, p_sm_err_name
	);
end
$$
language plpgsql;
