create or replace function midom.UI_new_domain(
	-- Focus
	-- Modify
	p_name          text,	-- ::mi.name, Name of the new Modeled Domain: Application
	p_alias         text,	-- ::mi.short_name, Alias for the new Modeled Domain: APP
    p_type          text default 'modeled'    -- [ 'modeled' | 'realized' ]
) returns void as 
$$
--
-- Create a new Modeled Domain with an initial Subsystem
--
-- Copyright 2011,2012 Model Integration, LLC
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
	v_name          mi.name;
	v_alias	        mi.short_name;
    v_type          miuml.domain_type;
begin
-- Validate name formats
	begin
		v_name := trim( p_name );
	exception
		when check_violation then
			raise exception 'UI: Domain name [%] violates format.', p_name;
	end;
	begin
		v_alias := trim( p_alias );
	exception
		when check_violation then
			raise exception 'UI: Domain alias [%] violates format.', p_alias;
	end;
    begin
        v_type := trim( p_type );
    exception
		when check_violation then
			raise 'UI: Type [%] should be modeled or realized.', p_type;
    end;

	-- Call App with appropriate function
    if v_type = 'modeled' then
        perform method_modeled_domain_new( v_name, v_alias );
    else
        perform method_realized_domain_new( v_name, v_alias );
    end if;
end
$$
language plpgsql;
