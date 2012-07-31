create or replace function mipoly.method_local_del_event_migrate_local_eff(
	-- ID
	p_evid			local_delegated_event.id%type,
	p_cnum			local_delegated_event.cnum%type,
	p_cname			miclass.class.name%type,
	p_domain		local_delegated_event.domain%type,
	-- Args
	p_ev_num		polymorphic_event_spec.number%type
) returns local_effective_event.id%type as 
$$
--
-- Method: Local Delegated Event.Migrate local effective( event number )
--
-- Migrates this Local Delegated Event to a Local Effective Event deleting all
-- descendant Inherited Effective Events and migrating its Polymorphic Event Spec
-- to a Monomorphic Event Spec in the process.
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
	my_new_id			local_effective_event.id%type;

begin
	-- Delete this and all descendant events (delegated and effective)
	perform method_del_event_delete_all( p_evid, p_cnum, p_domain );

	-- Migrate the Event Spec to Monomorphic
	delete from polymorphic_event_spec where
		number = p_ev_num and cnum = p_cnum and domain = p_domain;
	insert into monomorphic_event_spec( number, state_model, sm_type, domain )
		values( p_ev_num, p_cnum, 'lifecycle', p_domain );

	-- Create a new Local Effective Event for my event spec
	my_new_id := method_eff_event_new( p_cnum, 'lifecycle', p_domain );
	insert into local_effective_event( id, ev_spec, state_model, sm_type, domain )
		values( my_new_id, p_ev_num, p_cnum, 'lifecycle', p_domain );

	-- Create Effective Signaling Event
	perform mistate.method_eff_signaling_event_new(
		my_new_id, p_cnum, 'lifecycle', p_domain, p_cname
	);
	insert into local_effective_signaling_event( id, state_model, sm_type, domain )
		values( my_new_id, p_cnum, 'lifecycle', p_domain );

	return my_new_id;
end
$$
language plpgsql;
