create or replace function mipoly.event_delegation_dir_path_deleted(
	-- ID
	p_evid			delegation_dir.delegated_evid%type,
	p_cnum			delegation_dir.super_cnum%type,
	p_domain		delegation_dir.domain%type,
	p_gen_rnum		delegation_dir.gen_rnum%type
) returns void as 
$$
--
-- Event: Delegated Direction.Delegation path deleted
--
-- A Delegation Path has been deleted.  This Delegated Direction will delete itself if
-- it is no longer the source of any Delegation Paths.  If deletion is performed,
-- the associated Delegated Event will be notified.
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
	-- If there are any Delegation Paths in this Delegation Direction quit.
	perform * from delegation_path where
		delegated_evid = p_evid and super_cnum = p_cnum and
		gen_rnum = p_gen_rnum and domain = p_domain;
	if found then
		return;
	end if;

	-- There are no Events delegating in this Direction 
	delete from delegation_dir where
		delegated_evid = p_evid and super_cnum = p_cnum and
		gen_rnum = p_gen_rnum and domain = p_domain;

	-- Notify the source Delegated Event
	perform event_delegated_event_dir_deleted(
		p_evid, p_cnum, p_domain
	);
end
$$
language plpgsql;
