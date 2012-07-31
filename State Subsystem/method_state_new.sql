create or replace function mistate.method_state_new(
	p_name			state.name%type,				-- Name of the State
	p_state_model	state.state_model%type,			-- Rnum or Cnum
	p_sm_type		state.sm_type%type,				-- [ lifecycle | assigner ]
	p_domain		state.domain%type,				-- Domain
	p_sm_err_name	text,							-- Long State Model name for error msg
	p_snum			state.snum%type default null
) returns state.snum%type as 
$$
--
-- Method: State.New
--
-- Creates a new State in the specified State Model.  Uses the optional state number
-- if it is not currently in use in the same State Model.  Otherwise, the lowest available
-- number is assigned.  In either case the number is returned.  Fails if the State Model
-- does not exist or it already has a State with the same name.
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
	this_event		effective_signaling_event%rowtype;
	NEW_EVENT		text := 'newly defined';
	my_snum			state.snum%type;
begin
	-- Create the Destination instance
	begin
		insert into destination( name, state_model, sm_type, domain ) values(
			p_name, p_state_model, p_sm_type, p_domain
		);
	exception
		when unique_violation then
			raise exception 'UI: State [%] on [%::%] already exists.',
				p_name, p_sm_err_name, p_domain;
	end;

	-- Get a state number
	my_snum := method_state_model_assign_snum( p_state_model, p_sm_type, p_domain, p_snum );

	-- Create the State instance
	begin
		insert into state( name, snum, state_model, sm_type, domain ) values(
			p_name, my_snum, p_state_model, p_sm_type, p_domain
		);
	exception
		when foreign_key_violation then
			raise exception 'UI: [%::%] has no state model.', p_sm_err_name, p_domain;
	end;

	-- Add a State Signature with zero parameters
	perform mipoly.method_state_sig_new( p_name, p_state_model, p_sm_type, p_domain );

	-- Create Event Response for each Event initially as Can't Happen
	for this_event in
		select * from effective_signaling_event where
			state_model = p_state_model and sm_type = p_sm_type and domain = p_domain
	loop
		perform method_nt_response_new(
			p_name, this_event.id, p_state_model, p_sm_type, p_domain, 'CH', NEW_EVENT
		);
	end loop;

	return my_snum;
end
$$
language plpgsql;
