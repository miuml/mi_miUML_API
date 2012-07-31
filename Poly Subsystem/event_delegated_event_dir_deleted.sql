create or replace function mipoly.event_delegated_event_dir_deleted(
	-- ID
	p_evid			delegated_event.id%type,
	p_cnum			delegated_event.cnum%type,
	p_domain		delegated_event.domain%type
) returns void as 
$$
--
-- Event: Delegated Event.Delegation direction deleted
--
-- A Delegation Direction has been deleted.  This Delegated Event will delete itself if
-- it is no longer the source of any Delegation Directions.
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
	-- If this Delegated Event is still the source of any Delegation Directions, quit
	perform * from delegation_dir where
		delegated_evid = p_evid and super_cnum = p_cnum and domain = p_domain;
	if found then
		return;
	end if;

	-- This Event is no longer delegating, delete it
	perform * from inherited_delegated_event where
		id = p_evid and
		cnum = p_cnum and
		domain = p_domain;
	if found then
		-- Inherited Delegated Event
		perform method_inherited_event_delete( p_evid, p_cnum, p_domain );
	else
		-- Local Delegated Event
		delete from event where
			id = p_evid and
			state_model = p_cnum and
			sm_type = 'lifecycle' and
			domain = p_domain;
	end if;
end
$$
language plpgsql;
