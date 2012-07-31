create or replace function mipoly.method_inherited_eff_event_delegate(
	-- ID
	p_evid			inherited_effective_event.id%type,
	p_cnum			inherited_effective_event.cnum%type,
	p_domain		inherited_effective_event.domain%type,
	-- Args
	p_del_cname		miclass.class.name%type,
	p_del_rnum		mirel.generalization.rnum%type		-- May be NULL
) returns void as 
$$
--
-- Method: Inherited Effective Event.Delegate
--
-- Converts this Event to an Inherited Delegated Event and creates a new Inherited Effective
-- Event on each Subclass of the specified Generalization with corresponding Delegation
-- Paths.
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
	this_super_class		mirel.superclass%rowtype;		-- Each of its Superclass roles

begin
	-- Delete the Effective Signaling instance, possibly cascading to self
	perform mistate.method_eff_signaling_event_delete(
		p_evid, p_cnum, 'lifecycle', p_domain
	);

	-- Delete self instance just to be sure
	delete from inherited_effective_event where
		id = p_evid and cnum = p_cnum and domain = p_domain;

	-- Delete Effective Event instance (but keep Event, we're just migrating to Delegated)
	delete from effective_event where
		id = p_evid and state_model = p_cnum and sm_type = 'lifecycle' and domain = p_domain;

	-- Create migrated Delegated instance to reference existing Event instance
	insert into delegated_event( id, cnum, sm_type, domain )
		values( p_evid, p_cnum, 'lifecycle', p_domain );

	-- Create Inherited Delegated Event, to reference existing Inherited Event instance
	insert into inherited_delegated_event( id, cnum, domain )
		values( p_evid, p_cnum, p_domain );

	-- Build the Delegation Dir / Paths
	if p_del_rnum is not NULL then
		-- Delegate only down the specified Generalization
		perform method_del_event_create_paths(
			p_evid, p_cnum, p_domain, p_del_rnum
		);
	else
		-- Delegate down ALL Generalizations where my Class is the Superclass
		-- (effectively the same as the above if case when there is no compound
		-- Generalization on the Class
		
		-- Create Delegation Paths for each Generalization stemming from my Class
		for this_super_class in select * from mirel.superclass where
			class = p_del_cname and domain = p_domain
		loop
			perform method_del_event_create_paths(
				p_evid, p_cnum, p_domain, this_super_class.rnum
			);
		end loop;
	end if;
end
$$
language plpgsql;
