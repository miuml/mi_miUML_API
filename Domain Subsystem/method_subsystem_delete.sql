create or replace function midom.method_subsystem_delete(
	-- id
	p_subsys	subsystem.name%type,
	p_domain	domain.name%type
	-- args
) returns void as 
$$
--
-- Deletes this Subsystem.  Cnum and Rnum sequencers must be dropped.
--
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
	my_schema	text := 'midom';
	self		subsystem%rowtype;
begin
    begin
        -- Get self
        select * into strict self from subsystem where name = p_subsys and domain = p_domain;
	exception
		when no_data_found then raise exception
            'UI: Subsystem [%:%] does not exist.', p_domain, p_subsys;
    end;

    -- Verify that I am not the last Subsystem in my Domain
    perform * from subsystem where name != p_subsys and domain = p_domain;
    if not found then raise exception
        'UI: Cannot delete [%].  It is the last subsystem in [%].',
            p_subsys, p_domain;
    end if;

	-- Drop cnum and rnum sequences
	execute 'drop sequence ' || my_schema || '.' || self.cnum_generator;
	execute 'drop sequence ' || my_schema || '.' || self.rnum_generator;

	-- Delete self (using cascade to remove contents)
	delete from subsystem where name = self.name and domain = self.domain;
    if not found then raise exception
        'SYS: On delete, [%:%] was missing.', p_subsys, p_domain;
    end if;
end
$$
language plpgsql;
