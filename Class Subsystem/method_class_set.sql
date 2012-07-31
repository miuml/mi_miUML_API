create or replace function miclass.method_class_set(
	-- ID
	p_domain  class.domain%type,
	p_name    class.name%type,
	-- Args
	p_new_cnum  class.cnum%type default NULL,
	p_new_name  class.name%type default NULL,
	p_new_alias class.alias%type default NULL
) returns void as 
$$
--
-- Method: Sets Class attributes.
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
	self	        class%rowtype;

    -- Update strings
	u_new_cnum  text := NULL;
	u_new_name  text := NULL;
	u_new_alias text := NULL;
    no_set_values boolean := true;

begin
    if p_new_cnum is not NULL then
        u_new_cnum := 'cnum = ' || p_new_cnum;
        no_set_values = false;
    end if;

    if p_new_name is not NULL then
        u_new_name := 'name = ' || quote_nullable( p_new_name );
        no_set_values = false;
    end if;

    if p_new_alias is not NULL then
        u_new_alias := 'alias = ' || quote_nullable( p_new_alias );
        no_set_values = false;
    end if;

    if no_set_values then
        raise exception 'UI: No values to set.';
    end if;

    -- ++ Pre-update code inserted here
    -- The cnum requires special validation logic
    if p_new_cnum is not NULL then
        perform method_class_validate_cnum( p_name, p_domain, p_new_cnum );
        -- Will throw an erorr if the cnum is invalid
    end if;
    -- ==

    begin
        -- Apply any settings in a single UPDATE
        execute 'update class set '
            -- Concats only those values that are non-NULL
            || concat_ws( ', ',
                u_new_cnum,
                u_new_name,
                u_new_alias
            ) || ' where ' || concat_ws( ' and ',
                'domain = ' || quote_nullable( p_domain ),
                'name = ' || quote_nullable( p_name )
            ) || ' returning *' into strict self;
	exception
		when no_data_found then raise exception
            'UI: Class [%] does not exist.',
                concat_ws( ', ',
                    'domain:' || p_domain,
                    'name:' || p_name
                );
    end;

    -- ++ Post-update code inserted here
    -- ==
end
$$
language plpgsql;
