create or replace function mipoly.method_state_sig_add_param(
	p_name			state_model_parameter.name%type,
	p_type			state_model_parameter.type%type,
	p_state			state_signature.state%type,
	p_state_model	state_signature.state_model%type,
	p_sm_type		state_signature.sm_type%type,
	p_domain		state_signature.domain%type,
	p_sm_err_name	text
) returns void as 
$$
--
-- Method: State Signature.Add param
--
-- Adds a new State Model Parameter to a State Signature.
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
	my_dest					mistate.destination%rowtype;	-- Destination
	in_trans				mistate.transition%rowtype;		-- Incoming Transition
	other_trans				mistate.transition%rowtype;		-- Into some other State
	in_trans_ev_spec		event_spec.name%type;			-- Incoming Event Spec
	other_in_trans_ev_spec	event_spec.name%type;			-- Event Spec on other Transition

	-- No error if param to be added to Event Spec already exists
	IGNORE_DUPLICATE		boolean := true;

begin
	-- Verify that the Destination exists for good error reporting
	begin
		select * from destination into strict my_dest where
			name = p_state and
			state_model = p_state_model and sm_type = p_sm_type and
			domain = p_domain;
	exception
		when no_data_found then
			raise exception 'State [%] does not exist on [%::%]',
				p_state, p_sm_err_name, p_domain;
	end;

	-- Create the parameter instance for the supplied State Signature
	perform create_sm_parameter(
		p_name, p_type, p_state, 'state',
		p_state_model, p_sm_type, p_domain, p_sm_err_name
	);

	-- Get all transitions entering this state
	-- For in_trans, get the associated event spec
	-- 	For that event spec, find any events on transitions
	--		to states other than this one.
	--		If found, migrate in_trans to CH, 'trans disconnect'
	--		Else not found, get event signature
	--			add parameter to that signature if not already present

	-- Update all relevant signatures (if possible)
	for in_trans in
		-- All transitions leading into my state
		select * from mistate.transition where
			destination = my_dest.name and
			state_model = p_state_model and sm_type = p_sm_type and
			domain = p_domain
	loop
		in_trans_ev_spec := method_event_get_name(
			in_trans.event, p_state_model, p_sm_type, p_domain
		);
		for other_trans in
			select * from mistate.transition where
				destination != my_dest.name and
				state_model = p_state_model and sm_type = p_sm_type and
				domain = p_domain
		loop
			other_in_trans_ev_spec := method_event_get_name(
					other_trans.event, p_state_model, p_sm_type, p_domain
				);
			if in_trans_ev_spec = other_in_trans_ev_spec then
				-- Disconnect this transition by migrating it to CH
				perform mistate.method_transition_migrate_nt(
					'CH', 'state signature update',
					in_trans.state, in_trans.event,
					in_trans.state_model, in_trans.sm_type, in_trans.domain, 
					p_sm_err_name
				);
			else
				-- Add the parameter to the event spec on this transition
				perform create_sm_parameter(
					p_name, p_type, in_trans_ev_spec, 'event',
					p_state_model, p_sm_type, p_domain, p_sm_err_name,
					IGNORE_DUPLICATE
				);
			end if;
		end loop;
	end loop;
end
$$
language plpgsql;
