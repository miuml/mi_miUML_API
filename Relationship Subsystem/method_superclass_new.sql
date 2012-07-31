create or replace function mirel.method_superclass_new(
	p_class		superclass.class%type,
	p_alias		miclass.class.alias%type,	-- May be null
	p_subsys	midom.subsystem.name%type,
	p_rnum		superclass.rnum%type,
	p_domain	superclass.domain%type
) returns void as 
$$
--
-- Create a new Superclass role for an existing or new Class.
--
-- If the Class is new, it is created as a Specialized Class.
-- If the Class already exists and is Non-Specialized, it migrates to Specialized.
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
begin
	-- If the Class does not exist, create it
	perform * from miclass.class where name = p_class and domain = p_domain;
	if not found then
		-- Verify that an alias was supplied
		if p_alias is NULL then
			raise exception 'UI: Alias not provided for new superclass [%::%].',
				p_domain, p_class;
		end if;
		perform method_class_new( p_class, p_alias, p_subsys, p_domain );
	end if;

	-- Migrate to Specialized if not already
	perform * from specialized_class where name = p_class and domain = p_domain;
	if not found then
		perform method_class_migrate_specialized( p_class, p_domain );
	end if;

	-- Create Generalization Role
	insert into generalization_role( rnum, class, domain) values(
		p_rnum, p_class, p_domain
	);
	insert into superclass( rnum, class, domain) values(
		p_rnum, p_class, p_domain
	);
end
$$
language plpgsql;

