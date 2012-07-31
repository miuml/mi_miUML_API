create or replace function mipoly.method_event_sig_add_param(
	p_name			state_model_parameter.name%type,
	p_type			state_model_parameter.type%type,
	p_ev_spec		event_signature.ev_spec%type,
	p_state_model	event_signature.state_model%type,
	p_sm_type		event_signature.sm_type%type,
	p_domain		event_signature.domain%type,
	p_sm_err_name	text
) returns void as 
$$
--
-- Method: Event Signature.Add param
--
-- Adds a new State Model Parameter to an Event Signature.
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
	my_ev_spec			event_spec%rowtype;				-- The Event Spec
	trig_tr				mistate.transition%rowtype;		-- Transition triggered by event
	trig_sm_err_text	text;

	-- No error if param to be added to Event Spec already exists
	IGNORE_DUPLICATE	boolean := true;

begin
	-- Verify that the Event Spec exists for good error reporting
	begin
		select * from event_spec into strict my_ev_spec where
			name = p_ev_spec and
			state_model = p_state_model and sm_type = p_sm_type and
			domain = p_domain;
	exception
		when no_data_found then
			raise exception 'UI: Event [%] does not exist on [%::%]',
				p_ev_spec, p_sm_err_name, p_domain;
	end;

	-- Create the parameter instance for the supplied Event Signature
	perform create_sm_parameter(
		p_name, p_type, my_ev_spec.name, 'event',
		my_ev_spec.state_model, my_ev_spec.sm_type, my_ev_spec.domain, p_sm_err_name
	);

	-- For each Transition triggered by the event spec:
	--		Are there any other Transitions into the same Destination
	--			triggered by a different event spec?
	--		If so, migrate the Trigger Transition to NT-CH
	--		If not, add param to the Destination State Signature

	
	for trig_tr in select * from method_event_spec_get_transitions(
		my_ev_spec.name, my_ev_spec.state_model, my_ev_spec.sm_type, my_ev_spec.domain
	) loop -- on each Transition triggered by my Event Spec
		-- Is the Destination arrived at exclusively via my Event Spec?

		-- Errors will be formated for the Transition's State Model
		trig_sm_err_text := method_state_model_get_err_name(
			trig_tr.state_model, trig_tr.sm_type, trig_tr.domain
		); -- Rn or Class name

		if method_dest_ev_spec_exclusive(
			trig_tr.destination, trig_tr.state_model, trig_tr.sm_type,
			my_ev_spec.name, my_ev_spec.state_model, my_ev_spec.sm_type,
			p_domain
		) then
			-- It's exclusive, so we can update the Destination's State Signature
			perform create_sm_parameter(
				p_name, p_type, trig_tr.destination, 'state',
				trig_tr.state_model, trig_tr.sm_type, trig_tr.domain, trig_sm_err_text,
				IGNORE_DUPLICATE
			);
		else
			-- There are other incoming Event Specs and we don't want to conflict
			-- with any of them, so just disconnect this Transition
			perform mistate.method_transition_migrate_nt(
				'CH', 'event signature update',
				trig_tr.state, trig_tr.event,
				trig_tr.state_model, trig_tr.sm_type, trig_tr.domain, 
				trig_sm_err_text
			);
		end if;
	end loop;
end
$$
language plpgsql;
