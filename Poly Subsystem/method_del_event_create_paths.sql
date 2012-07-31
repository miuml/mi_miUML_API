create or replace function mipoly.method_del_event_create_paths(
	-- ID
	p_evid			delegated_event.id%type,
	p_super_cnum	delegated_event.cnum%type,
	p_domain		delegated_event.domain%type,
	-- Args
	p_gen_rnum		delegation_path.gen_rnum%type
) returns void as 
$$
--
-- Method: Delegated Event.Create paths
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
	this_subclass	mirel.subclass%rowtype;
begin
	-- First create the Delegation Direction
	insert into delegation_dir( delegated_evid, super_cnum, domain, gen_rnum )
		values( p_evid, p_super_cnum, p_domain, p_gen_rnum );

	-- Create Delegation Paths to subclasses and Inherited Events
	for this_subclass in
		select * from subclass where
			rnum = p_gen_rnum and domain = p_domain
	loop
		perform method_del_path_new(
			p_evid,
			p_super_cnum, this_subclass.class,
			p_gen_rnum, p_domain
		);
	end loop;
end
$$
language plpgsql;
