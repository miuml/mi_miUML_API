create or replace function mipoly.method_poly_event_spec_delete(
	-- ID
	p_number		polymorphic_event_spec.number%type,
	p_cnum			polymorphic_event_spec.cnum%type,
	p_domain		polymorphic_event_spec.domain%type
) returns void as 
$$
--
-- Method: Polymorphic Event Specification.Delete
--
-- Deletes a Polymorophic Event Specification, its single Local Delegated Event and
-- all Events directly or indirectly inherited from this Event.
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
	this_event			inherited_effective_event%rowtype;
	my_local_del_event	local_delegated_event%rowtype;

begin
	-- Get my Local Delegated Event
	select * into strict my_local_del_event from local_delegated_event where
		ev_spec = p_number and cnum = p_cnum and domain = p_domain;

	-- Delete the Local Delegated Event and all descendant Events
	perform method_del_event_delete_all(
		my_local_del_event.id, my_local_del_event.cnum, my_local_del_event.domain
	);

	-- Wipe out the Event Spec cascading through all subclasses
	delete from event_spec where
		number = p_number and
		state_model = p_cnum and sm_type = 'lifecycle' and
		domain = p_domain;
end
$$
language plpgsql;
