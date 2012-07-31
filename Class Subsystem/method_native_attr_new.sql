create or replace function miclass.method_native_attr_new(
	p_name		attribute.name%type,
	p_class		class.name%type,
	p_domain	domain.name%type,
	p_type		mitype.constrained_type.name%type
) returns void as 
$$
--
-- Creates a new Native Attribute
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
	perform method_attr_new( p_name, p_class, p_domain );

	begin
		-- Create self instance
		insert into native_attribute( name, class, domain, type ) values(
			p_name, p_class, p_domain, p_type
		);
	exception
		when foreign_key_violation then
			perform * from constrained_type where name = p_type;
			if not found then
				raise exception 'UI: Type [%] does not exist.', p_type;
			else
				raise;
			end if;
	end;
end
$$
language plpgsql;
