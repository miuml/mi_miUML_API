create or replace function miclass.method_modeled_id_new(
	p_attr		identifier_attribute.attribute%type,
	p_class		modeled_identifier.class%type,
	p_domain	modeled_identifier.domain%type
) returns identifier.number%type as 
$$
--
-- Creates a Modeled Identifier
--
-- Copyright 2011, 2012 Model Integration, LLC
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
declare
	my_number	modeled_identifier.number%type;

begin
    my_number := method_id_new( p_class, p_domain );

	perform method_id_attr_new( p_attr, p_class, p_domain, my_number );

	insert into modeled_identifier( number, class, domain ) values(
		my_number, p_class, p_domain
	);

	return my_number;
end
$$
language plpgsql;
