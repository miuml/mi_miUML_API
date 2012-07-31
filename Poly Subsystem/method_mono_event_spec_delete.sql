create or replace function mipoly.method_mono_event_spec_delete(
	-- ID
	p_number		monomorphic_event_spec.number%type,
	p_state_model	monomorphic_event_spec.state_model%type,
	p_sm_type		monomorphic_event_spec.sm_type%type,
	p_domain		monomorphic_event_spec.domain%type
) returns void as 
$$
--
-- Method: Monomorphic Event Specification.Delete
--
-- Deletes a Monomrophic Event Specification and its single Local Effective Event.
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
	my_local_eff_event		local_effective_event%rowtype;
begin
	-- Get this spec's single Local Effective Event
	select * into strict my_local_eff_event from local_effective_event where
		ev_spec = p_number and
		state_model = p_state_model and sm_type = p_sm_type and
		domain = p_domain;

	-- Wipe out the Signaling instance and related Event Responses via cascade
	-- If this is a Creation Event, no instances will be found here
	delete from effective_signaling_event where id = my_local_eff_event.id and
		state_model = p_state_model and sm_type = p_sm_type and
		domain = p_domain;

	-- Wipe out the Event cascading through all subclasses
	delete from event where id = my_local_eff_event.id and
		state_model = p_state_model and sm_type = p_sm_type and
		domain = p_domain;
	
	-- Wipe out the Event Spec cascading through all subclasses
	delete from event_spec where
		number = p_number and
		state_model = p_state_model and sm_type = p_sm_type and
		domain = p_domain;
end
$$
language plpgsql;
