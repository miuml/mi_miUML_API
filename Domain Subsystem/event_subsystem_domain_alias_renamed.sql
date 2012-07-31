create or replace function midom.event_subsystem_domain_alias_renamed(
    -- Existing
	p_subsystem     subsystem.name%type,
	p_domain	    domain.name%type,
    -- Modify
	p_new_alias     domain.alias%type			-- New domain alias
) returns void as 
$$
--
-- Event: The Domain's Alias was changed.  So we need to update our sequence names
-- since they incorporate the alias.
--
-- Copyright 2012, Model Integration, LLC
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
declare
    self        subsystem%rowtype;
    my_schema   text := 'midom';
    new_c_seq   subsystem.cnum_generator%type;
    new_r_seq   subsystem.rnum_generator%type;
begin
	-- Get self
    select * from subsystem into strict self where(
        name = p_subsystem and domain = p_domain
    );

    new_c_seq := p_new_alias || '_' || self.alias || '_cnum_seq';
    execute 'alter sequence ' || my_schema || '.' || self.cnum_generator
        || ' rename to ' || new_c_seq;

    new_r_seq := p_new_alias || '_' || self.alias || '_rnum_seq';
    execute 'alter sequence ' || my_schema || '.' || self.rnum_generator
        || ' rename to ' || new_r_seq;

    update subsystem set cnum_generator = new_c_seq, rnum_generator = new_r_seq
    where name = self.name and domain = self.domain;
end
$$
language plpgsql;
