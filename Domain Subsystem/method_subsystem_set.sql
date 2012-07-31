create or replace function midom.method_subsystem_set(
	-- ID
	p_domain  subsystem.domain%type,
	p_name    subsystem.name%type,
	-- Args
	p_new_alias  subsystem.alias%type default NULL,
	p_new_name   subsystem.name%type default NULL
) returns void as 
$$
--
-- Method: Sets Subsystem attributes.
-- ++ -
-- ==
--
-- Copyright 2012 Model Integration, LLC
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
	self	        subsystem%rowtype;

    -- Update strings
	u_new_alias  text := NULL;
	u_new_name   text := NULL;
    no_set_values boolean := true;

begin
    if p_new_alias is not NULL then
        u_new_alias := 'alias = ' || quote_nullable( p_new_alias );
        no_set_values = false;
    end if;

    if p_new_name is not NULL then
        u_new_name := 'name = ' || quote_nullable( p_new_name );
        no_set_values = false;
    end if;

    if no_set_values then
        raise exception 'UI: No values to set.';
    end if;

    -- ++ Pre-update code inserted here
    -- ==

    begin
        -- Apply any settings in a single UPDATE
        execute 'update subsystem set '
            -- Concats only those values that are non-NULL
            || concat_ws( ', ',
                u_new_alias,
                u_new_name
            ) || ' where ' || concat_ws( ' and ',
                'domain = ' || quote_nullable( p_domain ),
                'name = ' || quote_nullable( p_name )
            ) || ' returning *' into strict self;
	exception
		when no_data_found then raise exception
            'UI: Subsystem [%] does not exist.',
                concat_ws( ', ',
                    'domain:' || p_domain,
                    'name:' || p_name
                );
    end;

    -- ++ Post-update code inserted here
    if p_new_alias is not NULL then
        perform event_subsystem_alias_renamed(
            self.name, self.domain
        );
    end if;
    -- ==
end
$$
language plpgsql;
