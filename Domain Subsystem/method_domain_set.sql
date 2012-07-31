create or replace function midom.method_domain_set(
	-- ID
	p_name  domain.name%type,
	-- Args
	p_new_alias  domain.alias%type default NULL,
	p_new_name   domain.name%type default NULL
) returns void as 
$$
--
-- Method: Sets Domain attributes.
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
	self	        domain%rowtype;

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
        execute 'update domain set '
            -- Concats only those values that are non-NULL
            || concat_ws( ', ',
                u_new_alias,
                u_new_name
            ) || ' where ' || concat_ws( ' and ',
                'name = ' || quote_nullable( p_name )
            ) || ' returning *' into strict self;
	exception
		when no_data_found then raise exception
            'UI: Domain [%] does not exist.',
                concat_ws( ', ',
                    'name:' || p_name
                );
    end;

    -- ++ Post-update code inserted here
    declare
        my_subsystem    subsystem%rowtype;
    begin
        if p_name is not NULL then
            -- Manually cascade each State Model
            update mistate.state_model set domain = p_new_name
            where domain = p_name;
            update mistate.destination set domain = p_new_name
            where domain = p_name;
            update mipoly.event set domain = p_new_name
            where domain = p_name;
            update mistate.effective_signaling_event set domain = p_new_name
            where domain = p_name;
            update mipoly.state_model_signature set domain = p_new_name
            where domain = p_name;
        end if;

        -- Assert self exists
        if p_new_alias is not NULL then
            -- Update all my subsystem sequence names, if the alias changed
            for my_subsystem in
                select * from subsystem where domain = self.name
            loop
                perform event_subsystem_domain_alias_renamed(
                    my_subsystem.name, self.name, p_new_alias
                );
            end loop;
        end if;
    end;
    -- ==
end
$$
language plpgsql;
