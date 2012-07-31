create or replace function mipoly.UI_new_polymorphic_event(
	-- New
	p_name			text,		-- mi.name: Event name
	-- Existing
	p_super_cname	mi.name,	-- Name of a Superclass
	p_domain		mi.name,	-- In this Domain
	p_gen_rnum		mi.nominal default null,	-- If null, delegate on all gen rels
	-- New
	p_ev_num		integer default null,	-- mi.nominal: Desired Event Spec number
	-- Returned
	o_number		OUT mi.nominal,		-- The generated Event Specification.Number
	o_id			OUT mi.nominal		-- The generated Event.ID
) as 
$$
--
-- UI: New polymorphic event
--
-- Creates a Polymorphic Event Specification, a Delegated Event for the specified
-- Superclass and an Inherited Effective Event on each Subclass reached through the
-- supplied Generalization.  The user can further delegate a subclass event if
-- desired by further delegating it in a separate operation.
--
-- If the specified Class plays multiple Superclass roles (is the root of a compound
-- Generalization), the event will be delegated down each Generalization.  If an
-- Rnum is supplied, however, the event will be delegated down the specified
-- Generalization only.
--
-- The Event Spec number and Local Delegated Event ID is returned.
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
	v_event_name	mi.name;
	v_ev_num		mi.nominal;
begin
	-- Validate New parameters
	begin
		v_event_name := trim( p_name );
	exception
		when check_violation then
			raise exception 'UI: Event name [%] violates format.', p_name;
	end;

	begin
		v_ev_num := p_ev_num; -- May be null
	exception
		when check_violation then
			raise exception 'UI: Requested event number [%] violates format.', p_ev_num;
	end;

	-- Call the app
	select * from method_local_del_event_new(
		v_event_name,
		miclass.read_class_cnum( p_super_cname, p_domain ), 
		p_domain, p_gen_rnum, v_ev_num
	) into o_number, o_id;
end
$$
language plpgsql;
