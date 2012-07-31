create or replace function mipoly.method_del_event_getall_eff_event(
	-- ID
	p_id			delegated_event.id%type,
	p_cnum			delegated_event.cnum%type,
	p_domain		delegated_event.domain%type
) returns setof inherited_effective_event as 
$$
--
-- Method: Delegated Event.Getall Effective Events
--
-- Returns the set of Effective Events directly or indirectly inheriting this
-- Delegated Event.  These will all be Inherited Effective Events since delegation
-- is relevant only to polymorphism.  Ordinarily, this function will be invoked
-- first on a Local Delegated Event so that all Effective Events in the polymorphic
-- event tree will be found.
--
-- This function applies itself recursively, starting at a root Delegated Event,
-- typically the Local Delegated Event on a Polymorphic Event Specification.  It
-- traces each Delegation Path leading from the invoking Delegated Event.  This
-- leads to each Subclass in the specified Generalization and either a Delegated
-- or Effective Inherited Event.  If the Event is Effective, it is added to the
-- return set.  Otherwise, this function is called again, recursively, on the
-- Subclass Delegated Event.  The recursive function call will see the Subclass as
-- a Superclass of a deeper Generalization and continue downward.  There can be no
-- cycles in connected Generalizations, so terminal Subclasses will eventually be
-- reached and, hence, Inherited Effective Events.
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
	cname			mirel.superclass.class%type;
	this_dpath		delegation_path%rowtype;	-- Current Delegation Path
	this_in_event	inherited_event%rowtype;	-- Corresponding Inherited Event on Path
	found_event		inherited_effective_event%rowtype; -- Added to the return set
begin
	--raise info 'New set of Dpaths';
	-- Change to all Dpaths down all generalizations 
	-- a branch is defined by a gen_rnum and 
	-- get all generalizations on the class

	cname := miclass.read_class_name( p_cnum, p_domain ); -- Need the name in Superclass
	for this_dpath in
		-- Get all Delegation Paths down the supplied Generalization
		select * from delegation_path where
			super_cnum = p_cnum and gen_rnum in
				-- All gen rnums originating originating from the specified class
				( select rnum from mirel.superclass where class = cname and domain = p_domain )
			and domain = p_domain
	loop
		begin
			--raise info 'Dpath: del%:super%:sub%:r%', this_dpath.delegated_evid,
			--	this_dpath.super_cnum, this_dpath.sub_cnum, this_dpath.gen_rnum;

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
			-- recursion below

			--raise info 'Found event';
			return next found_event;

		exception
			when no_data_found then
				-- The Delegation Path leads to another Delegated Event.  Add its descendant
				-- Effective Events to the return set by calling this function recursively.

				--raise info 'Search: Further delegation';

				--raise info 'Query from: evid%:cnum%:r%', this_dpath.delegated_evid,
				--	this_dpath.sub_cnum, this_dpath.gen_rnum;

				-- Now return the set of Effective Events below this
				-- Inherited Delegated Event in the Delegation Direction
				return query select * from method_del_event_getall_eff_event(
					this_in_event.id, this_in_event.sub_cnum,
					this_in_event.domain
				);
		end;

	end loop;
	return;
end
$$
language plpgsql;
