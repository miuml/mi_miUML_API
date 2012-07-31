create or replace function mipoly.method_poly_event_spec_delegate(
	-- ID
	p_number		polymorphic_event_spec.number%type,
	p_ev_name		event_spec.name%type,				-- For error reporting
	p_ev_cname		miclass.class.name%type,			-- For error reporting
	p_ev_cnum		polymorphic_event_spec.cnum%type,	-- Poly event spec class number
	p_domain		polymorphic_event_spec.domain%type,
	-- Args
	p_del_cnum		inherited_effective_event.cnum%type,	-- Delegation, not ev spec class
	p_del_cname		miclass.class.name%type,				-- For error reporting
	p_del_rnum		mirel.generalization.rnum%type			-- May be NULL
) returns void as
$$
--
-- Method: Polymorphic Event Specification.Delegate
--
-- Delegates an existing Polymorphic Event Spec on the specified Generalization.
-- The corresponding Inherited Effective Event must be identified, on the Superclass
-- of the Generalization and then migrated to an Inherited Delegated Event.  Delegation
-- Paths and Inherited Effective Events will be created for each Subclass on the
-- Generalization.
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
	my_inh_eff_event			inherited_effective_event%rowtype;
	my_ldel_event				local_delegated_event%rowtype;

begin
	-- We know the delegation Class and the Event Spec's number, but we need to find
	-- the ID of the Inherited Effective Event to migrate.
	--
	-- We trace each Inherited Effective Event on the delegation Class up to
	-- the root Local Delegated Event and see if it matches the Event Spec's Number
	--
	for my_inh_eff_event in
		-- For each event on the specified class (not the ev spec class!)
		select * from inherited_effective_event where cnum = p_del_cnum and domain = p_domain
	loop
		my_ldel_event := method_event_get_local_del_event(
			my_inh_eff_event.id, p_del_cnum, p_domain
		);
		if my_ldel_event.ev_spec = p_number then exit; end if;
	end loop;
	
	if my_inh_eff_event is NULL then
		raise exception 'UI: Polymorphic event [%:%] has not been defined on [%::%].',
			p_number, p_ev_name, p_ev_cname, p_domain;
	end if;

	-- Migrate it to a Delegated Event and create a corresponding Inherited
	-- Effective Event in each subclass
	perform method_inherited_eff_event_delegate(
		my_inh_eff_event.id, my_inh_eff_event.cnum, my_inh_eff_event.domain,
		p_del_cname, p_del_rnum
	);
end
$$
language plpgsql;
