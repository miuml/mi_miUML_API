create or replace function miclass.method_attr_add_to_id(
	p_attr		identifier_attribute.attribute%type,
	p_class		modeled_identifier.class%type,
	p_domain	modeled_identifier.domain%type,
    p_id_num    modeled_identifier.number%type default NULL
) returns identifier.number%type as 
$$
--
-- Creates a Modeled Identifier
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
    my_number   modeled_identifier.number%type;

begin
    -- If an id num was specified, it must already exist and it must be
    -- a Modeled Identifier
    if p_id_num is not NULL then
        perform * from modeled_identifier where
            number = p_id_num and class = p_class and domain = p_domain;
        if not found then
            -- Fail for one of two reasons
            perform * from identifier where
            number = p_id_num and class = p_class and domain = p_domain;
            if found then raise exception
                'UI: Cannot add attribute to a required referential [%] identifier.', p_id_num;
            end if;
            raise exception
                'UI: Identifier [%] does not exists on class [%:%].', p_class, p_domain;
        end if;

        -- Id num was specified and it is an existing Modeled Identifier
        my_number := p_id_num;
    end if;

    -- Success cases

    -- Case 1:  No id num specified, so create a new Modeled Identifier
    --          with the supplied attribute
    if my_number is NULL then
        my_number := method_modeled_id_new( p_attr, p_class, p_domain );
        return my_number;
    end if;

    -- Case 2:  Add attribute to the existing Modeled Identifier
	perform method_id_attr_new( p_attr, p_class, p_domain, my_number );
	return my_number;
end
$$
language plpgsql;
