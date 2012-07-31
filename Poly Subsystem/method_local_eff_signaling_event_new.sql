create or replace function mipoly.method_local_eff_signaling_event_new(
	p_event_name	mipoly.event_spec.name%type,
	p_sm_name		effective_signaling_event.state_model%type,
	p_sm_type		effective_signaling_event.sm_type%type,
	p_domain		effective_signaling_event.domain%type,
	p_sm_err_name	text,
	-- Modify
	p_ev_num		mi.nominal default null,	-- mi.nominal: Desired Event Spec number
	-- Returned
	o_number		OUT event_spec.number%type,
	o_id			OUT effective_signaling_event.id%type
) as 
$$
--
-- Method: Local Effective Signaling Event.New
--
-- Creates a new non-polymorphic Signaling Event on the specified Lifecycle.  An Event ID is
-- returned and Event Spec number is returned.
--
-- A Non-Transition Response of 'Can't Happen' is created by default for each State
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
begin
	select * from method_local_eff_event_new( 
		p_event_name, p_sm_name, p_sm_type, p_sm_err_name, p_domain, p_ev_num
	) into o_number, o_id;

	-- Create Effective Signaling Event superclass instance
	perform mistate.method_eff_signaling_event_new(
		o_id, p_sm_name, p_sm_type, p_domain, p_sm_err_name
	);

	-- Create my instance
	insert into local_effective_signaling_event( id, state_model, sm_type, domain ) values(
		o_id, p_sm_name, p_sm_type, p_domain
	);
end
$$
language plpgsql;
