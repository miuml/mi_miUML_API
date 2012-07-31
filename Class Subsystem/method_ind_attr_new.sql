create or replace function miclass.method_ind_attr_new(
	p_name		attribute.name%type,
	p_class		class.name%type,
	p_domain	domain.name%type,
	p_type		mitype.constrained_type.name%type
) returns void as 
$$
--
-- Creates a new Independent Attribute
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
	-- Create superclass instance
	perform method_native_attr_new( p_name, p_class, p_domain, p_type );

	-- Create self instance
	insert into independent_attribute( name, class, domain ) values(
		p_name, p_class, p_domain
	);
end
$$
language plpgsql;
