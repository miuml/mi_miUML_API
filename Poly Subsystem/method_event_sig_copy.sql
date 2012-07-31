create or replace function mipoly.method_event_sig_copy(
	-- ID
	p_ev_spec		event_signature.ev_spec%type,
	p_state_model	event_signature.state_model%type,
	p_sm_type		event_signature.sm_type%type,
	p_domain		event_signature.domain%type,
	-- Args
	p_state_name	state_signature.state%type
) returns void as 
$$
--
-- Method: Event Signature.Copy
--
-- Replaces this Event's Signature with that of the supplied State Signature so that they
-- are both compatible (identical).
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
	this_param		state_model_parameter%rowtype;
begin
	--raise info 'Copying from state [%] into [%], smn[%], smt[%], d[%]',
	--	p_state_name, p_ev_spec, p_state_model, p_sm_type, p_domain;

	-- Delete the current signature
	delete from state_model_parameter where
		signature = p_ev_spec and sig_type = 'event' and
		state_model = p_state_model and sm_type = p_sm_type and domain = p_domain;

	-- Copy parameters from the state sig
	for this_param in
		select * from state_model_parameter where
			signature = p_state_name and sig_type = 'state' and
			state_model = p_state_model and sm_type = p_sm_type and domain = p_domain
	loop
		insert into state_model_parameter(
			name, signature, sig_type,
			state_model, sm_type, domain, type
		) values(
			this_param.name, p_ev_spec, 'event',
			p_state_model, p_sm_type, p_domain, this_param.type
		);
	end loop;
end
$$
language plpgsql;
