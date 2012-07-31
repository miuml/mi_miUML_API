create or replace function midom.method_domain_build_spec_set(
	-- ID
	p_name  domain_build_spec.name%type,
	-- Args
	p_new_domain_name_is_default_subsys_name  domain_build_spec.domain_name_is_default_subsys_name%type default NULL,
	p_new_default_id_name                     domain_build_spec.default_id_name%type default NULL,
	p_new_default_subsys_name                 domain_build_spec.default_subsys_name%type default NULL,
	p_new_default_subsys_range                domain_build_spec.default_subsys_range%type default NULL,
	p_new_default_id_type                     domain_build_spec.default_id_type%type default NULL
) returns void as 
$$
--
-- Method: Sets Domain_Build_Spec attributes.
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
	self	        domain_build_spec%rowtype;

    -- Update strings
	u_new_domain_name_is_default_subsys_name  text := NULL;
	u_new_default_id_name                     text := NULL;
	u_new_default_subsys_name                 text := NULL;
	u_new_default_subsys_range                text := NULL;
	u_new_default_id_type                     text := NULL;
    no_set_values boolean := true;

begin
    if p_new_domain_name_is_default_subsys_name is not NULL then
        u_new_domain_name_is_default_subsys_name := 'domain_name_is_default_subsys_name = ' || p_new_domain_name_is_default_subsys_name;
        no_set_values = false;
    end if;

    if p_new_default_id_name is not NULL then
        u_new_default_id_name := 'default_id_name = ' || quote_nullable( p_new_default_id_name );
        no_set_values = false;
    end if;

    if p_new_default_subsys_name is not NULL then
        u_new_default_subsys_name := 'default_subsys_name = ' || quote_nullable( p_new_default_subsys_name );
        no_set_values = false;
    end if;

    if p_new_default_subsys_range is not NULL then
        u_new_default_subsys_range := 'default_subsys_range = ' || p_new_default_subsys_range;
        no_set_values = false;
    end if;

    if p_new_default_id_type is not NULL then
        u_new_default_id_type := 'default_id_type = ' || quote_nullable( p_new_default_id_type );
        no_set_values = false;
    end if;

    if no_set_values then
        raise exception 'UI: No values to set.';
    end if;

    -- ++ Pre-update code inserted here
    -- ==

    begin
        -- Apply any settings in a single UPDATE
        execute 'update domain_build_spec set '
            -- Concats only those values that are non-NULL
            || concat_ws( ', ',
                u_new_domain_name_is_default_subsys_name,
                u_new_default_id_name,
                u_new_default_subsys_name,
                u_new_default_subsys_range,
                u_new_default_id_type
            ) || ' where ' || concat_ws( ' and ',
                'name = ' || quote_nullable( p_name )
            ) || ' returning *' into strict self;
	exception
		when no_data_found then raise exception
            'UI: Domain_Build_Spec [%] does not exist.',
                concat_ws( ', ',
                    'name:' || p_name
                );
    end;

    -- ++ Post-update code inserted here
    -- ==
end
$$
language plpgsql;
