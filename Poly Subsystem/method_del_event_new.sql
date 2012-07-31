create or replace function mipoly.method_del_event_new(
	p_cnum			delegated_event.cnum%type,
	p_gen_rnum		delegation_path.gen_rnum%type,	-- May be NULL
	p_domain		delegated_event.domain%type
) returns delegated_event.id%type as 
$$
--
-- Method: Delegated Event.New
--
-- Creates a new Delegated Event and an Inherited Effective Event for each of
-- the Generalization's Subclass Lifecycle State Models.  Each Inherited Effective
-- Event may be further delegated by the user.
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
	my_id					delegation_path.delegated_evid%type;
	my_cname				mirel.superclass.class%type;	-- Name of my Class
	this_super_class		mirel.superclass%rowtype;		-- Each of its Superclass roles
begin
	-- Create Event superclass and get an ID
	my_id := method_event_new( p_cnum, 'lifecycle', p_domain );

	-- Create my instance
	insert into delegated_event( id, cnum, sm_type, domain )
		values( my_id, p_cnum, 'lifecycle', p_domain );

	-- Create Delegation Paths to subclasses and Inherited Events
	if p_gen_rnum is not NULL then
		-- Delegate only down the specified Generalization
		perform method_del_event_create_paths( my_id, p_cnum, p_domain, p_gen_rnum );
	else
		-- Delegate down ALL Generalizations where my Class is the Superclass
		-- (effectively the same as the above if case when there is no compound
		-- Generalization on the Class

		-- Get name of this Delegated Event's class using supplied cnum
		my_cname := miclass.read_class_name( p_cnum, p_domain );
		
		-- Create Delegation Paths for each Generalization stemming from my Class
		for this_super_class in select * from mirel.superclass where
			class = my_cname and domain = p_domain
		loop
			perform method_del_event_create_paths(
				my_id, p_cnum, p_domain, this_super_class.rnum
			);
		end loop;
	end if;

	return my_id;
end
$$
language plpgsql;
