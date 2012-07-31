create or replace function mipoly.method_event_spec_delete(
	-- ID
	p_ev_name		event_spec.name%type,
	p_state_model	event_spec.state_model%type,
	p_sm_type		event_spec.sm_type%type,
	p_domain		event_spec.domain%type,
	-- Args
	p_sm_err_name	text					-- for error reporting
) returns void as 
$$
--
-- Method: Event Specification.Delete
--
-- Deletes an Event Specification and all corresponding Events.
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
	self		event_spec%rowtype;
begin
	begin
		select * into strict self from event_spec where
			name = p_ev_name and
			state_model = p_state_model and sm_type = p_sm_type and
			domain = p_domain;
	exception
		when no_data_found then raise exception
			'UI: Event [%] not defined on [%::%]',
				p_ev_name, p_sm_err_name, p_domain;
	end;

	perform * from monomorphic_event_spec where
		number = self.number and
		state_model = self.state_model and sm_type = self.sm_type and
		domain = self.domain;
	
	if found then
		perform method_mono_event_spec_delete(
			self.number, self.state_model, self.sm_type, self.domain
		);
	else
		perform method_poly_event_spec_delete(
			self.number, self.state_model, self.domain
		); -- The sm_type must be lifecycle, so no need to specify it
	end if;
end
$$
language plpgsql;
