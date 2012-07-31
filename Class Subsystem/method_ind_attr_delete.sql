create or replace function miclass.method_ind_attr_delete(
	-- Existing
	p_attr		independent_attribute.name%type,
	p_class		independent_attribute.class%type,
	p_domain	independent_attribute.domain%type
) returns void as 
$$
--
-- Deletes an Independent Attribute.
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
	self	independent_attribute%rowtype;
begin
	-- Get self and fail if not found
	begin
		select * into strict self from independent_attribute where
			name = p_attr and class = p_class and domain = p_domain;
	exception
		when no_data_found then
			raise exception 'UI: Independent attribute [%.%] in domain [%] does not exist.', 
				p_class, p_attr, p_domain;
	end;

	-- Delete superclass instance
	perform method_native_attr_delete( self.name, self.class, self.domain );

	-- Cascade delete self instance
end
$$
language plpgsql;
