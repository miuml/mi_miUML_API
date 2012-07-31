create or replace function mipoly.method_eff_event_new(
	p_state_model	state.state_model%type,	-- cnum or rnum
	p_sm_type		state.sm_type%type,		-- [ lifecycle | assigner ]
	p_domain		state.domain%type		-- Domain
) returns effective_event.id%type as 
$$
--
-- Create a new Effective Event in the specified State Model.
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
	my_id	effective_event.id%type;
begin
	--raise info 'sm[%], smt[%], d[%]',
	--	p_state_model, p_sm_type, p_domain;

	-- Create Event superclass and get an ID
	my_id := method_event_new( p_state_model, p_sm_type, p_domain );

	-- Create my instance
	insert into effective_event( id, state_model, sm_type, domain )
		values ( my_id, p_state_model, p_sm_type, p_domain );

	return my_id;
end
$$
language plpgsql;
