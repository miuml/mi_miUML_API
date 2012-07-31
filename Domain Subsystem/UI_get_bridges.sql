create or replace function midom.UI_get_bridges(
    -- IN
    p_client        mi.name default NULL,
    p_service       mi.name default NULL,
    -- OUT
	o_client		OUT mi.name,
	o_service		OUT mi.name
) returns setof record as 
$$
--
-- Returns all Bridges in the form { Client domain name, Service domain name }
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
-- 
begin
    if (p_client is NULL) and (p_service is NULL) then
        return query
            select client, service from bridge order by client;
    end if;

    return query execute 'select * from bridge where '
        -- Concats only those values that are non-NULL
        || concat_ws( ' and ',
            'client = ' || quote_nullable( p_client ),
            'service = ' || quote_nullable( p_service )
        );
end
$$
language plpgsql;
