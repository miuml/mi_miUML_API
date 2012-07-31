create or replace function mipoly.method_local_del_event_new(
	p_name			event_spec.name%type,
	p_cnum			local_delegated_event.cnum%type,
	p_domain		local_delegated_event.domain%type,
	p_gen_rnum		mirel.generalization.rnum%type,			-- May be NULL
	p_ev_num		polymorphic_event_spec.number%type,		-- May be NULL
	-- Returned
	o_number		OUT local_delegated_event.ev_spec%type,
	o_id			OUT local_delegated_event.id%type
) as 
$$
--
-- Method: Local Delegated Event.New
--
-- Creates a new Local Delegated Event and its required Polymorphic Event Specification.
-- the Event Spec number and Event ID are returned.
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
begin
	-- Create a Polymorphic Event Specification
	o_number := method_polymorphic_event_spec_new(
		p_name, p_cnum, p_domain, p_ev_num
	);

	-- Create Delegated Event superclass and get an ID
	o_id := method_del_event_new(
		p_cnum, p_gen_rnum, p_domain
	);

	-- Create self instance
	insert into local_delegated_event( id, ev_spec, cnum, domain )
		values( o_id, o_number, p_cnum, p_domain );
end
$$
language plpgsql;
