create or replace function miclass.method_ref_attr_migrate_ind(
	-- Existing
	p_attr		referential_attribute.name%type,
	p_class		referential_attribute.class%type,
	p_domain	referential_attribute.domain%type
) returns void as 
$$
--
-- Migrates this instance to a Native,  Independent Attribute.
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
	self	referential_attribute%rowtype;
begin
	-- Get self
	select * into strict self from referential_attribute where
		name = p_attr and class = p_class and domain = p_domain;

	-- Delete ref attr instance
	delete from referential_attribute where
		name = self.name and class = self.class and domain = self.domain;

	-- New Native and Independent instances
	insert into native_attribute( name, class, domain, type ) values(
		self.name, self.class, self.domain, self.type
	);
	insert into independent_attribute( name, class, domain ) values(
		self.name, self.class, self.domain
	);

	perform CL_edit(
		p_domain || ':' || p_class || ':' || p_attr,
		'change to independent',
		'attribute'
	);
end
$$
language plpgsql;
