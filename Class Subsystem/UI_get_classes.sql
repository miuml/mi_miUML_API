create or replace function miclass.UI_get_classes(
	-- IN
	p_domain		mi.name default NULL,
	p_subsystem		mi.name default NULL,
	-- OUT
	o_name			OUT mi.name,
	o_alias			OUT mi.short_name,
	o_element		OUT mi.nominal,
	o_cnum			OUT mi.nominal,
	o_specialized	OUT boolean,
	o_subsystem		OUT mi.name,
    o_domain        OUT mi.name
) returns setof record as  -- class + subsystem name
$$
--
-- Returns data for all Classes, all Classes in the specified Domain or all
-- Classes in the specified Domain and Subsystem.  If a Subsystem is specified,
-- a Domain must also be specified.
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
    if (p_subsystem is not NULL) and (p_domain is NULL) then raise exception
        'UI: A Domain must be specified for Subsystem [%].', p_subsystem;
    end if;

return query
	select 
		-- All the values we want to return are here
		name,
		alias,
		element,
		cnum,
		specialized,		-- Computed in Part 2, below
		subsystem,
        domain from(		-- From join in Part 1, below
			-- Get those values from two parts
			-- Part 1:  Get the subsystem by joining Class with Subsystem Element
			select
				name,		-- Class
				alias,		-- Class
				element,	-- Class
				cnum,		-- Class
				subsystem,	-- Subsytem Element (that's all we needed here)
				miclass.class.domain	-- Class
				from
				miclass.class join midom.subsystem_element on(
						miclass.class.element = midom.subsystem_element.number and
						miclass.class.domain = midom.subsystem_element.domain
				) where miclass.class.domain = coalesce( p_domain, miclass.class.domain ) and
                    midom.subsystem_element.subsystem =
                    coalesce( p_subsystem, midom.subsystem_element.subsystem )
		) as csub join(
			-- csub: Join of Class and Subsystem classes
			-- Part 2: Get the specialized status by joining csub with subclass union
			select
				-- Non Specialized Class subclass
				false as specialized,	-- newly computed
				name,					
				domain from non_specialized_class
			union select
				-- Specialized Class subclass
				true as specialized,	-- newly computed
				name,
				domain from specialized_class
		) as sun using( name, domain )
		-- sun: Union of both Specialized and Non-Specialized Class subclasses
		order by name;
end
$$
language plpgsql;
