create or replace function miclass.method_id_new(
	p_class		class.name%type,
	p_domain	domain.name%type
) returns identifier.number%type as 
$$
--
-- Creates an Identifier and returns its assigned Number.
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
	my_number	identifier.number%type;

begin
	-- Get the next ID Number
	my_number := method_class_next_id_num( p_class, p_domain );

    begin
        insert into identifier( number, class, domain )
            values( my_number, p_class, p_domain );

	exception 
		when unique_violation then raise exception
            'SYS: Identifier [%(%)::%] not unique.', p_class, my_number, p_domain;

		when foreign_key_violation then raise exception
            'UI: Class [%::%] does not exist.', p_class, p_domain;
    end;

	return my_number;
end
$$
language plpgsql;
