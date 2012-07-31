create or replace function mistate.method_signaling_poly_event_new(
	p_event_name	mipoly.event_spec.name%type,
	p_sm_name		effective_signaling_event.state_model%type,
	p_sm_type		effective_signaling_event.sm_type%type,
	p_domain		effective_signaling_event.domain%type,
	p_sm_err_name	text,
	-- Modify
	p_ev_num		mi.nominal default null,	-- mi.nominal: Desired Event Spec number
	-- Returned
	o_id			OUT effective_signaling_event.id%type,
	o_number		OUT event_spec.number%type
) as 
$$
--
-- Method: Signaling Polymorphic Event.New
--
-- Creates a new Polymorphic Signaling Event on the specified Lifecycle.  An Event ID is returned.
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
	CREATION		boolean := false;
	this_state		state%rowtype;
	NEW_EVENT		text := 'newly defined';

begin
	-- ** Placeholder method calls until Poly Subsystem is ready **
	-- Create the Monomorphic Event Specification
	select * from mipoly.method_event_spec_new(
		p_event_name, p_sm_name, p_sm_err_name, p_sm_type, p_domain, CREATION, p_ev_num
	) into o_number, o_id;

	-- Create the Signaling Event instance
	insert into effective_signaling_event( id, state_model, sm_type, domain ) values(
		o_id, p_sm_name, p_sm_type, p_domain
	);

	-- Create Event Response for each State initially as Can't Happen
	for this_state in
		select * from state where
			state_model = p_sm_name and sm_type = p_sm_type and domain = p_domain
	loop
		perform method_nt_response_new(
			this_state.name, o_id, p_sm_name, p_sm_type, p_domain, 'CH', NEW_EVENT
		);
	end loop;
end
$$
language plpgsql;
