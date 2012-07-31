create or replace function mipoly.method_inherited_eff_event_new(
	p_evid			inherited_effective_event.id%type,		-- Parent
	p_sub_cnum		inherited_effective_event.cnum%type,
	p_sub_cname		delegation_path.sub_cname%type,
	p_super_cnum	inherited_event.super_cnum%type,
	p_gen_rnum		inherited_event.gen_rnum%type,
	p_domain		delegated_event.domain%type
) returns inherited_effective_event.id%type as 
$$
--
-- Method: Inherited Effective Event.New
--
-- Creates a new Inherited Effective Event for a corresponding Delegation Path.  A new
-- Event ID will be generated for the Inherited Event.
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
	my_id		inherited_effective_event.id%type;

begin
	-- Create Effective Event superclass and get an ID
	my_id := method_eff_event_new( p_sub_cnum, 'lifecycle', p_domain );

	-- Create Inherited Event superclass
	perform method_inherited_event_new(
		my_id, p_sub_cnum, p_evid, p_super_cnum, p_gen_rnum, p_domain
	);

	-- Create Effective Signaling Event
	perform mistate.method_eff_signaling_event_new(
		my_id, p_sub_cnum, 'lifecycle', p_domain, p_sub_cname
	);

	-- Create my instance
	insert into inherited_effective_event( id, cnum, sm_type, domain )
		values( my_id, p_sub_cnum, 'lifecycle', p_domain );

	return my_id;
end
$$
language plpgsql;
