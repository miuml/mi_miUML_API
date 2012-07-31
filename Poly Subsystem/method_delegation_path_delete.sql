create or replace function mipoly.method_delegation_path_delete(
	p_evid			delegation_path.delegated_evid%type,
	p_super_cnum	delegation_path.super_cnum%type,
	p_sub_cnum		delegation_path.sub_cnum%type,
	p_gen_rnum		delegation_path.gen_rnum%type,
	p_domain		delegation_path.domain%type
) returns void as 
$$
--
-- Method: Delegation Path.Delete
--
-- Deletes this Delegation Path as requested by its Inherited Event.
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
begin
	-- Delete self
	delete from delegation_path where
		delegated_evid = p_evid and
		super_cnum = p_super_cnum and
		sub_cnum = p_sub_cnum and
		gen_rnum = p_gen_rnum and
		domain = p_domain;

	-- Notify the Delegation Direction that the deletion has occurred
	perform event_delegation_dir_path_deleted( p_evid, p_super_cnum, p_domain, p_gen_rnum );
end
$$
language plpgsql;
