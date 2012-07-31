create or replace function mipoly.method_del_event_delete_all(
	-- ID
	p_id			delegated_event.id%type,
	p_cnum			delegated_event.cnum%type,
	p_domain		delegated_event.domain%type
) returns void as 
$$
--
-- Method: Delegated Event.Delete all
--
-- Deletes this Delegated Event as well as all descendant Delegated and Effective
-- Events.
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
	this_dpath		delegation_path%rowtype;
	this_inh_event	inherited_event%rowtype;
begin
	-- For each Delegation Path who's source is the specified Delegated Event
	for this_dpath in
		select * from delegation_path where
			super_cnum = p_cnum and domain = p_domain
	loop
		-- Get the Inherited Event on the other side of the Delegation Path
		select * into this_inh_event from inherited_event where
			sub_cnum = this_dpath.sub_cnum and
			domain = this_dpath.domain and
			parent_evid = this_dpath.delegated_evid and
			super_cnum = this_dpath.super_cnum and
			gen_rnum = this_dpath.gen_rnum;

		-- If it is an Effective Event delete it
		perform * from inherited_effective_event where
			id = this_inh_event.id and
			cnum = this_inh_event.sub_cnum and
			domain = this_inh_event.domain;

		if found then
			perform method_inherited_eff_event_delete(
				this_inh_event.id, this_inh_event.sub_cnum, this_inh_event.domain
			);
		else
			-- Continue outward
			perform method_del_event_delete_all( 
				this_inh_event.id, this_inh_event.sub_cnum, this_inh_event.domain
			);
		end if;
	end loop;
end
$$
language plpgsql;
