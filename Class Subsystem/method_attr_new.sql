create or replace function miclass.method_attr_new(
	p_name		attribute.name%type,
	p_class		class.name%type,
	p_domain	domain.name%type
) returns void as 
$$
--
-- Creates a new Attribute.  (called by subclass)
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
begin
    begin
        -- Create self instance
        insert into attribute( name, class, domain )
            values( p_name, p_class, p_domain );
    exception
        when foreign_key_violation then raise exception
            'UI: Class [%::%] does not exist.', p_class, p_domain;
    end;

	perform CL_edit(
		p_domain || ':' || p_class || ':' || p_name,
		'new',
		'attribute'
	);

end
$$
language plpgsql;
