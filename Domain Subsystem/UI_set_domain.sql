create or replace function midom.UI_set_domain(
	-- Focus
	p_name  mi.name,
	-- Modify
    p_new_alias  text  default null,    -- ::mi.short_name
    p_new_name   text  default null    -- ::mi.name
) returns void as 
$$
--
-- UI Bridge: Sets Domain attributes
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
	v_new_alias  domain.alias%type;
	v_new_name   domain.name%type;
begin
	-- Validate attributes
	begin
		v_new_alias := trim( p_new_alias );
	exception
		when check_violation then
			raise exception 'UI: New alias [%] violates type: short_name.',
            p_new_alias;
	end;
	begin
		v_new_name := trim( p_new_name );
	exception
		when check_violation then
			raise exception 'UI: New name [%] violates type: name.',
            p_new_name;
	end;

	-- Call app
	perform method_domain_set(
        p_name := p_name,
        p_new_alias := v_new_alias,
        p_new_name := v_new_name
    );
end
$$
language plpgsql;
