create or replace function mipoly.method_event_get_local_del_event(
	-- ID
	p_evid			delegated_event.id%type,
	p_cnum			delegated_event.cnum%type,
	p_domain		delegated_event.domain%type
) returns local_delegated_event as 
$$
--
-- Method: Event.Get local delegated event
--
-- Walks up the polymorphic event hierarchy starting at the supplied Event until
-- the Local Delegated Event is found and returned.
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
	ih_event		inherited_event%rowtype;
	ldel_event		local_delegated_event%rowtype;

begin
	-- Intiialize, assuming the supplied event is polymorphic
	begin
		select * into strict ih_event from inherited_event where
			id = p_evid and sub_cnum = p_cnum and domain = p_domain;
	exception
		when no_data_found then
			-- The supplied Event is not inherited and therefore the Local Delegated Event
			select * into strict ldel_event from local_delegated_event where id = p_evid and
				cnum = p_cnum and domain = p_domain;
			return ldel_event;
	end;

	/*
	raise info 'Starting with EV% C% PARENT:EV% SUPER:C% GEN:R%',
		ih_event.id, ih_event.sub_cnum, ih_event.parent_evid,
		ih_event.super_cnum, ih_event.gen_rnum;
		*/

	loop
		begin
			-- Get parent event
			select * into strict ih_event from inherited_event where
				id = ih_event.parent_evid and sub_cnum = ih_event.super_cnum and domain = p_domain;
		/*
		raise info 'Now on EV% C% PARENT:EV% SUPER:C% GEN:R%',
			ih_event.id, ih_event.sub_cnum, ih_event.parent_evid,
			ih_event.super_cnum, ih_event.gen_rnum;
			*/
		exception
			when no_data_found then
				-- The event was not inherited, so it must be the topmost event
				select * into strict ldel_event from local_delegated_event where
					id = ih_event.parent_evid and cnum = ih_event.super_cnum and domain = p_domain;
				return ldel_event;
		end;
	end loop;
end
$$
language plpgsql;
