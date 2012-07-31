create or replace function mipoly.method_mono_event_spec_delegate(
	-- ID
	p_number		monomorphic_event_spec.number%type,		-- Rejected if it's a creation evspec
	p_ev_name		event_spec.name%type,					-- For error reporting
	p_cname			miclass.class.name%type,				-- For error reporting
	p_cnum			monomorphic_event_spec.state_model%type,	-- Must be a superclass cnum
	p_domain		monomorphic_event_spec.domain%type,
	-- Arg
	p_gen_rnum		mirel.generalization.rnum%type	-- May be NULL
) returns void as
$$
--
-- Method: Monomorphic Event Specification.Delegate
--
-- Delegates an existing Monomorphic Event Spec on the specified Generalization.
-- The Local Effective Event, which must be an Effective Signaling Event,
-- will be migrated to a Local Delegated Event.  Delegation Paths and Inherited
-- Effective Events will be created for each Subclass on the Generalization.
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
	my_local_eff_event		local_effective_event%rowtype;
	my_cname				mirel.superclass.class%type;	-- Name of my Class
	this_super_class		mirel.superclass%rowtype;		-- Each of its Superclass roles

begin
	-- Get the Local Effective Event
	select * into strict my_local_eff_event from local_effective_event where
		ev_spec = p_number and state_model = p_cnum and domain = p_domain;

	-- Verify that it is not a Creation Event
	perform * from creation_event where
		id = my_local_eff_event.id and
		cnum = my_local_eff_event.state_model and
		domain = my_local_eff_event.domain;
	if found then raise exception
		'UI: A creation event may not be delegated.';
	end if;

	-- Delete the Effective Signaling instance
	perform mistate.method_eff_signaling_event_delete(
		my_local_eff_event.id,
		my_local_eff_event.state_model,
		'lifecycle',
		my_local_eff_event.domain
	);

	-- Delete Effective Event instance
	delete from effective_event where
		id = my_local_eff_event.id and
		state_model = my_local_eff_event.state_model and
		sm_type = 'lifecycle' and
		domain = my_local_eff_event.domain;

	-- Create a Delegated Event, referring to existing Event instance
	insert into delegated_event( id, cnum, sm_type, domain ) values(
		my_local_eff_event.id,
		my_local_eff_event.state_model,
		'lifecycle',
		my_local_eff_event.domain
	);

	-- Migrate mono to polymorphic event spec
	delete from monomorphic_event_spec where
		number = p_number and state_model = p_cnum and
		sm_type = 'lifecycle' and domain = p_domain;
	begin
		insert into polymorphic_event_spec( number, cnum, sm_type, domain )
			values( p_number, p_cnum, 'lifecycle', p_domain );
	
	exception
		when foreign_key_violation then
			perform * from mirel.superclass where
				rnum = p_gen_rnum and class = p_cnum and domain = p_domain;
			if not found then raise exception
				'UI: Generalization [R%] does not exist.', p_gen_rnum, p_domain;
			end if;
		-- Any other exceptions are unexpected
	end;

	-- Now we can finally migrate Local Effective, to Local Delegated
	insert into local_delegated_event( id, ev_spec, cnum, domain )
		values( my_local_eff_event.id, p_number, p_cnum, p_domain );

	-- Build the Delegation Dir / Paths
	if p_gen_rnum is not NULL then
		-- Delegate only down the specified Generalization
		perform method_del_event_create_paths(
			my_local_eff_event.id, p_cnum, p_domain, p_gen_rnum 
		);
	else
		-- Delegate down ALL Generalizations where my Class is the Superclass
		-- (effectively the same as the above if case when there is no compound
		-- Generalization on the Class
		
		-- Create Delegation Paths for each Generalization stemming from my Class
		for this_super_class in select * from mirel.superclass where
			class = p_cname and domain = p_domain
		loop
			perform method_del_event_create_paths(
				my_local_eff_event.id, p_cnum, p_domain, this_super_class.rnum
			);
		end loop;
	end if;
end
$$
language plpgsql;
