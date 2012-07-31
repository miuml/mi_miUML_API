create or replace function mipoly.method_sm_sig_new(
	p_name			state_model_signature.name%type,	-- Event spec or State number
	p_sig_type		state_model_signature.sig_type%type,	-- [ event | state ]
	p_state_model	state_model_signature.state_model%type,
	p_sm_type		state_model_signature.sm_type%type,
	p_domain		state_model_signature.domain%type	
) returns void as 
$$
--
-- Method: State Model Signature.New
--
-- Creates a new State Model Signature with zero parameters
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
	--raise info '6ins> name[%], sig_type[%], state_model[%], sm_type[%], domain[%}',
	--	p_name, p_sig_type, p_state_model, p_sm_type, p_domain;
	
	insert into state_model_signature( name, sig_type, state_model, sm_type, domain )
		values( p_name, p_sig_type, p_state_model, p_sm_type, p_domain );
end
$$
language plpgsql;
