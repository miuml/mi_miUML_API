create or replace function mipoly.method_inherited_event_new(
	p_evid			inherited_event.id%type,
	p_sub_cnum		inherited_event.sub_cnum%type,
	p_parent_evid	inherited_event.parent_evid%type,
	p_super_cnum	inherited_event.super_cnum%type,
	p_gen_rnum		inherited_event.gen_rnum%type,
	p_domain		inherited_event.domain%type
) returns void as 
$$
--
-- Method: Inherited Event.New
--
-- Creates a new Inherited Event for a corresponding Delegation Path.  Called
-- by subclass.
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
	-- Create my instance
	insert into inherited_event( id, sub_cnum, domain, parent_evid, super_cnum, gen_rnum )
		values( p_evid, p_sub_cnum, p_domain, p_parent_evid, p_super_cnum, p_gen_rnum );
end
$$
language plpgsql;
