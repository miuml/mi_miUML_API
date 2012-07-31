create or replace function miclass.method_class_migrate_specialized(
	-- Existing
	p_class		miclass.class.name%type,
	p_domain	miclass.class.domain%type
) returns void as 
$$
--
-- Migrates this Class from Non Specialized to Specialized.
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
	self	miclass.class%rowtype;
begin
	-- Get self
	select * into strict self from miclass.class where
		name = p_class and domain = p_domain;

	-- Delete Non Specialized instance
	delete from non_specialized_class where
		name = self.name and domain = self.domain;

	-- New Specialized instance
	insert into specialized_class( name, domain ) values( self.name, self.domain );
end
$$
language plpgsql;
