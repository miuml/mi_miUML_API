create or replace function mipoly.read_event_spec_number(
	-- id
	p_ev_spec_name	event_spec.name%type,			-- Name of the event spec
	p_state_model	event_spec.state_model%type,	-- Rnum or Cnum
	p_sm_type		event_spec.sm_type%type,		-- [ lifecycle | assigner ]
	p_domain		state.domain%type				-- Domain
) returns event_spec.number%type as 
$$
--
-- Read: Event Specification.Number
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
	self			event_spec%rowtype;
begin
	select * into strict self from event_spec where
		name = p_ev_spec_name and
		state_model = p_state_model and sm_type = p_sm_type and
		domain = p_domain;

	return self.number;

exception
	when no_data_found then raise;
		-- raise exception 'Event specification [%] does not exist on [%::%].',
--			p_ev_spec_name, p_sm_err_name, p_domain;

end
$$
language plpgsql;
