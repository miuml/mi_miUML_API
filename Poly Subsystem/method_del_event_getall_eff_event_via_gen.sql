create or replace function mipoly.method_del_event_getall_eff_event_via_gen(
	-- ID
	p_id			delegated_event.id%type,
	p_cnum			delegated_event.cnum%type,
	p_domain		delegated_event.domain%type,
	-- Args
	p_gen_rnum		delegation_path.gen_rnum%type
) returns setof inherited_effective_event as 
$$
--
-- Method: Delegated Event.Getall effective events via generalization( generalization )
--
-- Returns the set of Effective Events directly or indirectly inheriting this
-- Delegated Event through a single specified Generalization.  This method is useful
-- when the Delegated Event is on a Class participating in multiple Superclass roles
-- (compound generalization) and there is a need to traverse only one Generalization
-- to find a set of descendant Inherited Effective Events.
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
	this_dpath		delegation_path%rowtype;
	this_in_event	inherited_event%rowtype;
	found_event		inherited_effective_event%rowtype;
begin
	for this_dpath in
		select * from delegation_path where
			super_cnum = p_cnum and gen_rnum = p_gen_rnum and domain = p_domain
	loop
		begin
			-- Get the Inherited Event on the other side of the Delegation Path
			select * into this_in_event from inherited_event where
				sub_cnum = this_dpath.sub_cnum and
				domain = this_dpath.domain and
				parent_evid = this_dpath.delegated_evid and
				super_cnum = this_dpath.super_cnum and
				gen_rnum = this_dpath.gen_rnum;

			-- If it is an Effective Event, add it to the return set
			select * into strict found_event from inherited_effective_event where
				id = this_in_event.id and
				cnum = this_in_event.sub_cnum and
				domain = this_in_event.domain;
			-- Otherwise it is a Delegated Event with the exception triggering

			return next found_event;

		exception
			when no_data_found then
				return query select * from method_del_event_getall_eff_event(
					this_in_event.id, this_in_event.sub_cnum,
					this_in_event.domain
				);
		end;
	end loop;
end
$$
language plpgsql;
