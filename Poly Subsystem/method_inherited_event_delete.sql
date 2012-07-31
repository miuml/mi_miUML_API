create or replace function mipoly.method_inherited_event_delete(
	p_evid			inherited_event.id%type,
	p_sub_cnum		inherited_event.sub_cnum%type,
	p_domain		inherited_event.domain%type
) returns void as 
$$
--
-- Method: Inherited Event.Delete
--
-- Deletes this Inherited Event instance as requested by a subclass instance.
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
	self		inherited_event%rowtype;

begin
	-- Get self
	select * from inherited_event into strict self where
		id = p_evid and sub_cnum = p_sub_cnum and domain = p_domain;

	-- Delete self instance
	delete from inherited_event where
		id = p_evid and sub_cnum = p_sub_cnum and domain = p_domain;

	-- Delete the Delegation Path to my ancestor Delegated Event
	perform method_delegation_path_delete(
		self.id, self.super_cnum, self.sub_cnum, self.gen_rnum, self.domain
	);

	-- Delete all other instances constituting this Event
	delete from event where
		id = p_evid and
		state_model = p_sub_cnum and
		sm_type = 'lifecycle' and
		domain = p_domain;
end
$$
language plpgsql;
