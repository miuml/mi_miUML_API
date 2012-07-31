create or replace function mipoly.UI_new_signaling_event(
	-- New
	p_event_name	text,		-- mi.name: Event name
	-- Existing
	p_state_model	text,		-- mi.name or mi.nominal: class name or rnum
	p_domain		mi.name,	-- In this Domain
	-- New
	p_ev_num		integer default null,	-- mi.nominal: Desired Event Spec number
	-- Returned
	o_number		OUT mi.nominal,		-- The generated Event Specification.Number
	o_id			OUT mi.nominal		-- The generated Event.ID
) as 
$$
--
-- UI: New signaling event
--
-- Creates a new Signaling Event on the specified Lifecycle.  An Event ID will be
-- generated along with an Event Specification number, if none is specified.  Both
-- the assigned Event.ID and Event Specification.Number will be returned.  If a
-- desired Event Specification number is specified, it will be used unless the
-- number is already taken, in which case any available number will be assigned.
-- 
-- Also a Non-Transition Response of 'Can't Happen' is created by default for each State
-- in the State Model.
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
	v_state_model	mi.nominal;
	v_sm_type		miuml.sm_type;
	sm_err_name		text;
	v_ev_num		mi.nominal;
begin
	select * from mistate.method_state_model_locate( p_state_model, p_domain )
		into v_state_model, v_sm_type, sm_err_name;
	
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

	-- Call app
	select * from method_local_eff_signaling_event_new(
		v_event_name, v_state_model, v_sm_type, p_domain, sm_err_name, v_ev_num
	) into o_number, o_id;
end
$$
language plpgsql;
