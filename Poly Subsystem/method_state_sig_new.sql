create or replace function mipoly.method_state_sig_new(
	p_snum			state_signature.state%type,
	p_state_model	state_signature.state_model%type,
	p_sm_type		state_signature.sm_type%type,
	p_domain		state_signature.domain%type	
) returns void as 
$$
--
-- Method: State Signature.New
--
-- Creates a new State Signature with zero parameters
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
	-- First create the State Model Signature superclass instance
	perform method_sm_sig_new( p_snum, 'state', p_state_model, p_sm_type, p_domain );

	-- Now create my instance
	insert into state_signature( state, sig_type, state_model, sm_type, domain )
		values( p_snum, 'state', p_state_model, p_sm_type, p_domain );
end
$$
language plpgsql;
