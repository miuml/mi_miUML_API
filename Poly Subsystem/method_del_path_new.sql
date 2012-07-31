create or replace function mipoly.method_del_path_new(
	p_evid			delegation_path.delegated_evid%type,
	p_super_cnum	delegated_event.cnum%type,
	p_sub_cname		delegation_path.sub_cname%type,
	p_gen_rnum		delegation_path.gen_rnum%type,		-- May be NULL
	p_domain		delegated_event.domain%type
) returns void as 
$$
--
-- Method: Delegation Path.New
--
-- Creates a new Delegation Path for the specified Generalization branch from Superclass to
-- Subclass.  An Inherited Effective Event is also spawned.
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
	my_sub_cnum		delegation_path.sub_cnum%type;
begin
	my_sub_cnum := miclass.read_class_cnum( p_sub_cname, p_domain );
	-- Create my instance
	insert into delegation_path(
		delegated_evid, super_cnum, sub_cname, sub_cnum, gen_rnum, domain
	) values(
		p_evid, p_super_cnum, p_sub_cname, my_sub_cnum,
		p_gen_rnum, p_domain
	);

	-- Create a corresponding Inherited Effective Event
	perform method_inherited_eff_event_new(
		p_evid, my_sub_cnum, p_sub_cname, p_super_cnum, p_gen_rnum, p_domain
	);
end
$$
language plpgsql;
