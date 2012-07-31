create or replace function mipoly.method_del_event_undelegate(
	-- ID
	p_evid			delegated_event.id%type,
	p_cnum			delegated_event.cnum%type,
	p_cname			miclass.class.name%type,
	p_domain		delegated_event.domain%type,
	-- Args
	p_ev_num		polymorphic_event_spec.number%type,
	p_del_rnum		delegation_path.gen_rnum%type	-- May be NULL
) returns effective_event.id%type as 
$$
--
-- Method: Delegated Event.Undelegate( event number, delegation gen rnum )
--
-- Removes the descendant Inherited Effective Events along either a specified
-- Generalization or, if not specified, all Generalizations originating at the
-- indicated Class.  If any descendant Inherited Effective Events remain, the
-- Delegated Event will remain a Delegated Event.  Otherwise, a Local Delegated
-- Event will be migrated to a Local Effecitve Event with its Event Spec migrated
-- from polymrophic to monomorphic in the process and an Inherited Delegated
-- Event will be migrated to an Inherited Effective Event.
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
	local		boolean;	-- Use booleans to increase readability of code
	compound	boolean;

	this_ih_eff_event	inherited_effective_event%rowtype;
begin
	-- Is this a Local Delegated Event?
	perform * from local_delegated_event where
		id = p_evid and cnum = p_cnum and domain = p_domain;
	local := found;

	-- Does the class participate in multiple Superclass roles?
	compound := miclass.method_class_is_compound_gen( p_cname, p_domain );

	-- If the event is not a Local Delegated Event, it will migrate from an
	-- Inherited Delegated Event to an Inherited Effective Event and thus remain
	-- polymorphic.

	-- A Local Delegated Event will convert to a Local Effective Event, and hence
	-- become monomorphic UNLESS the Generalization is compound AND
	-- a relationship has been specified.  Consequently, at least one Generalization
	-- will remain with descendant Inherited Effective Events leaving the Local Delegated
	-- Event as is.

	if local then
		if compound and p_del_rnum is not NULL then
			-- Local Delegated -> Local Delegated (no migration)
			-- Delete all Events tied to the event spec via the specified gen rel
			perform method_del_event_delete_all_via_gen( p_evid, p_cnum, p_domain, p_del_rnum );
			return p_evid; -- No change to Event ID
		else
			-- Make it monomorphic
			-- Local Delegated -> Local Effective
			return method_local_del_event_migrate_local_eff(
				p_evid, p_cnum, p_cname, p_domain, p_ev_num
			); -- returns a Local Effective Event ID
		end if;
	else
		-- Make it Polymorphic
		-- Inherited Delegated -> Inherited Effective
		 return method_inherited_del_event_migrate_inh_eff(
			 p_evid, p_cnum, p_domain, p_cname, p_ev_num
		 ); -- returns an Inherited Effective Event ID
	end if;
end
$$
language plpgsql;
