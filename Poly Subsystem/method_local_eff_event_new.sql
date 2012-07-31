create or replace function mipoly.method_local_eff_event_new(
	p_name			event_spec.name%type,
	p_state_model	state.state_model%type,
	p_sm_type		state.sm_type%type,
	p_sm_err_name	text,
	p_domain		state.domain%type,
	p_ev_num		monomorphic_event_spec.number%type,
	-- Returned
	o_number		OUT local_effective_event.ev_spec%type,
	o_id			OUT local_effective_event.id%type
) as 
$$
--
-- Method: Local Effective Event.New
--
-- Creates a new Local Effective Event and its required Monomorphic Event Specification.
-- the Event Spec number and Event ID are returned.
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
	-- raise info '2> ev[%:%], sm[%:%::%]', p_ev_num, p_name, p_state_model, p_sm_type, p_domain;

	-- Create a Monmorphic Event Specification
	o_number := method_mono_event_spec_new(
		p_name, p_state_model, p_sm_type, p_sm_err_name, p_domain, p_ev_num
	);

	-- Create Effective Event superclass and get an ID
	o_id := method_eff_event_new( p_state_model, p_sm_type, p_domain );

	insert into local_effective_event( id, ev_spec, state_model, sm_type, domain )
		values( o_id, o_number, p_state_model, p_sm_type, p_domain );
end
$$
language plpgsql;
