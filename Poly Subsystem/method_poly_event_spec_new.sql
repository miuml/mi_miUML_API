create or replace function mipoly.method_polymorphic_event_spec_new(
	p_name			event_spec.name%type,
	p_cnum			polymorphic_event_spec.cnum%type,
	p_domain		polymorphic_event_spec.domain%type,
	p_ev_num		polymorphic_event_spec.number%type
) returns polymorphic_event_spec.number%type as 
$$
--
-- Method: Polymorphic Event Specification.New
--
-- Creates a new Polymorphic Event Specification and returns its number.
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
	my_number	polymorphic_event_spec.number%type;
begin
	-- Create event spec
	my_number := method_event_spec_new(
		p_name, p_cnum, miclass.read_class_name( p_cnum, p_domain ), 'lifecycle',
		p_domain, p_ev_num
	);

	-- Create self instance
	insert into polymorphic_event_spec( number, cnum, sm_type, domain )
		values( my_number, p_cnum,'lifecycle', p_domain );

	return my_number;
end
$$
language plpgsql;
