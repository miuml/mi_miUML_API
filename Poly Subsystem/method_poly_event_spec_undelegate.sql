create or replace function mipoly.method_poly_event_spec_undelegate(
	-- ID
	p_number		polymorphic_event_spec.number%type,
	p_ev_name		event_spec.name%type,				-- For error reporting
	p_ev_cnum		polymorphic_event_spec.cnum%type,	-- Poly event spec class number
	p_ev_cname		miclass.class.name%type,			-- For error reporting
	p_domain		polymorphic_event_spec.domain%type,
	-- Args
	p_del_cnum		delegated_event.cnum%type,	-- Delegation, not ev spec class
	p_del_cname		miclass.class.name%type,				-- For error reporting
	p_del_rnum		mirel.generalization.rnum%type			-- May be NULL
) returns effective_event.id%type as
$$
--
-- Method: Polymorphic Event Specification.Un Delegate
--
-- Locates a Delegated Event ID described by the supplied Polymorphic Event Spec
-- and undelegates it.
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
	this_del_event		delegated_event%rowtype;
	this_ev_name		event_spec.name%type;
begin
	-- We know the Class where delegation occurs, the delegation Class, which
	-- is descended ultimately from the Class where this Poly Event Spec is defined.
	-- So we need to find the one Delegated Event on this delegation Class that
	-- this Poly Event Spec defines.  We'll have to trace each Delegated
	-- Event back to its Poly Event Spec until we find a match.  Then we
	-- will migrate the Delegated Event to an Inherited Effective Event.

	for this_del_event in
		select * from delegated_event where
			cnum = p_del_cnum and domain = p_domain
	loop
		-- Walk back to this candidate Delegated Event's spec and get the name
		this_ev_name := method_event_get_name(
			this_del_event.id, p_del_cnum, 'lifecycle', p_domain
		);
		-- If it matches our name, undelegate it
		if this_ev_name = p_ev_name then
			return method_del_event_undelegate(
				this_del_event.id, p_del_cnum, p_del_cname, p_domain,
				read_event_spec_number( p_ev_name, p_ev_cnum, 'lifecycle', p_domain ),
				p_del_rnum
			);
		end if;
	end loop;

	raise exception
	'UI: No delegated event found on subclass [%] for event [%:%] on class [%::%].',
		p_del_cname, p_ev_cnum, p_ev_name, p_ev_cname, p_domain;
end
$$
language plpgsql;
