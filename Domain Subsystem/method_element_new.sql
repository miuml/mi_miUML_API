create or replace function midom.method_element_new(
	-- args
	p_domain	domain.name%type
) returns mi.nominal as 
$$
--
-- Create a new Element and returns its number.
--
--
-- Copyright 2011, Model Integration, LLC
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
	my_element_number	mi.nominal;
begin
	-- Create self
	insert into element( number, domain ) values( default, p_domain );
	select currval( 'element_number_seq' ) into my_element_number;

	return my_element_number;

	exception
		when foreign_key_violation then
			raise exception 'UI: Domain [%] does not exist.', p_domain;
end
$$
language plpgsql;
