create or replace function mistate.UI_new_creation_event(
	-- New
	p_event_name	text,			-- mi.name: Event specification name
	-- Exists
	p_cname			mi.name,		-- Lifecycle state model on this Class
	p_to_state		mi.name,		-- Creation state
	p_domain		mi.name,		-- Domain
	-- New
	p_ev_num		integer default null,	-- mi.nominal: Desired Event Spec number
	-- Returned
	o_number		OUT mi.nominal,		-- The generated Event Specification.Number
	o_id			OUT mi.nominal		-- The generated Event.ID
) as 
$$
--
-- UI: New creation event
--
-- Defines a new Creation Event on the specified Lifecycle.  An Event ID will be
-- generated along with an Event Specification number, if none is specified.  Both
-- the assigned Event.ID and Event Specification.Number will be returned.  If a
-- desired Event Specification number is specified, it will be used unless the
-- number is already taken, in which case any available number will be assigned.
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
	v_event_name		mi.name;
	v_cnum				mi.nominal;
	v_ev_num			mi.nominal;
begin
	-- Validate New parameters
	begin
		v_event_name := trim( p_event_name );
	exception
		when check_violation then
			raise exception 'UI: Event name [%] violates format.', p_event_name;
	end;

	begin
		v_ev_num := p_ev_num; -- May be null
	exception
		when check_violation then
			raise exception 'UI: Requested event number [%] violates format.', p_ev_num;
	end;

	-- Get the cnum
	v_cnum := miclass.read_class_cnum( p_cname, p_domain );

	-- Call the app
	select * from method_creation_event_new(
		v_event_name, v_cnum, p_cname, p_to_state, p_domain, v_ev_num
	) into o_number, o_id;
end
$$
language plpgsql;
