create or replace function midom.method_subsystem_new(
	p_name          subsystem.name%type,
	p_domain        domain.name%type,
	p_alias         subsystem.alias%type,
	p_floor         subsystem_range.floor%type,
	p_ceiling       subsystem_range.ceiling%type
) returns void as 
$$
--
-- Creates a new Subsystem object with the specified numbering range
--
-- Copyright 2011, Model Integration, LLC
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
    my_domain           domain%rowtype;
	my_schema			text := 'midom';
	my_cnum_generator	subsystem.cnum_generator%type;
	my_rnum_generator	subsystem.rnum_generator%type;
    o_range             subsystem_range%rowtype;

begin
    -- Get domain alias
    select * from domain into strict my_domain where name = p_domain;

	-- Compose cnum, rnum generator names ensuring uniqueness across all domains
	my_cnum_generator := my_domain.alias || '_' || p_alias || '_cnum_seq';
	my_rnum_generator := my_domain.alias || '_' || p_alias || '_rnum_seq';

	-- Create the Subsystem object
	insert into subsystem( name, domain, alias, cnum_generator, rnum_generator ) values(
		p_name,
		p_domain,
		p_alias,
		my_cnum_generator,
		my_rnum_generator
	);

	-- Check for any overlapping range
    select * from subsystem_range where domain = p_domain and (
	    ( p_floor between floor and ceiling ) or
        ( p_ceiling between floor and ceiling )
    ) into o_range limit 1;

    if found then
        raise exception 'UI: Range [%-%] overlaps with %[%-%]::[%].',
            p_floor, p_ceiling, o_range.subsystem, o_range.floor, o_range.ceiling, p_domain;
    end if;

	-- Create the Subsystem Range object
    begin
        insert into subsystem_range( floor, ceiling, subsystem, domain ) values (
            p_floor,
            p_ceiling,
            p_name,
            p_domain
        );
    exception
		when check_violation then
			raise exception 'UI: Invalid range [%-%] supplied for subsystem [%::%].',
				p_floor, p_ceiling, p_name, p_domain;
    end;

	-- Create cnum and rnum sequences
	execute 'create sequence ' || my_schema || '.' || my_cnum_generator
		|| ' minvalue ' || p_floor
		|| ' maxvalue ' || p_ceiling
		|| ' start with ' || p_floor || ' cycle ';

	execute 'create sequence ' || my_schema || '.' || my_rnum_generator
		|| ' minvalue ' || p_floor
		|| ' maxvalue ' || p_ceiling
		|| ' start with ' || p_floor || ' cycle ';

	exception
		when unique_violation then
			raise exception 'UI: Subsystem [%(%)::%] already exists.', p_name, p_alias, p_domain;
		when foreign_key_violation then
			raise exception 'UI: Domain [%] does not exist.', p_domain;
end
$$
language plpgsql;
