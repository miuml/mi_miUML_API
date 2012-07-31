create or replace function mipoly.method_inherited_del_event_migrate_inh_eff(
	-- ID
	p_evid			inherited_delegated_event.id%type,
	p_cnum			inherited_delegated_event.cnum%type,
	p_domain		inherited_delegated_event.domain%type,
	-- Args
	p_cname			delegation_path.sub_cname%type,
	p_ev_num		polymorphic_event_spec.number%type
) returns inherited_effective_event.id%type as 
$$
--
-- Method: Inherited Delegated Event.Migrate to inherited effective( class name, event number )
--
-- Migrates this Event to be an Inherited Effective Event.
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
	old_inh_event	inherited_event%rowtype;
begin
	-- This instance provides context within the poly tree for use later
	select * into strict old_inh_event from inherited_event where
		id = p_evid and sub_cnum = p_cnum and domain = p_domain;

	-- Delete this and all descendant events (delegated and effective)
	perform method_del_event_delete_all( p_evid, p_cnum, p_domain );

	-- Rebuild a Delegation Path using old parent info
	insert into delegation_path(
		delegated_evid, super_cnum, sub_cname, sub_cnum, gen_rnum, domain
	) values( 
		old_inh_event.parent_evid, old_inh_event.super_cnum, p_cname,
		p_cnum, old_inh_event.gen_rnum, p_domain
	);

	-- Create a new Inherited Effective Event
	return method_inherited_eff_event_new(
		old_inh_event.parent_evid, p_cnum, p_cname, old_inh_event.super_cnum,
		old_inh_event.gen_rnum, p_domain
	);
end
$$
language plpgsql;
