create or replace function mirel.UI_new_binary_assoc(
	-- Existing
	p_active_class			mi.name,	-- Class on active perspective
	p_passive_class			mi.name,	-- Class on passive perspective (may be active class too)
	p_subsys				mi.name,	-- Subsystem
	p_domain				mi.name,	-- Domain
	-- New
	p_rnum					integer default null,	-- Rnum is assigned if not provided			
	p_formalizing_persp		text default 'P',		-- miuml.side: A or P

	p_active_mult			text default '1',		-- miuml.mult: 1, M
	p_active_cond			boolean default false,
	p_active_phrase			text default 'phrase',	-- mi.name

	p_passive_mult			text default '1',		-- miuml.mult: 1, M
	p_passive_cond			boolean default false,
	p_passive_phrase		text default 'phrase',	-- mi.name

	p_assoc_class			text default null,		-- mi.name: Name of new or existing class to use
	p_assoc_alias			text default null		-- mi.short_name: Alias required if class is new
) returns mi.nominal as 
$$
--
-- Create a new Binary Association.
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
--
declare
	v_formalizing_persp		miuml.binary_side;
	v_rnum					mi.nominal;

	v_active_mult			miuml.mult;
	v_active_phrase			mi.name;

	v_passive_mult			miuml.mult;
	v_passive_phrase		mi.name;

	v_assoc_class			mi.name;
	v_assoc_alias			mi.short_name;
begin
	
	-- Input validation
	begin
		v_formalizing_persp := p_formalizing_persp;
	exception
		when check_violation then
			raise 'UI: Binary assoc perspective [%] must be A or P.', p_formalizing_persp;
	end;

	begin
		if p_rnum is not null then
			v_rnum := p_rnum;
		end if;
	exception
		when check_violation then
			raise 'UI: Rnum [%] must be a positive integer. SQLSTATE[%]', p_rnum, SQLSTATE;
	end;

	begin
		v_active_mult := p_active_mult;
	exception
		when check_violation then
			raise 'UI: Active multiplicity [%] must be 1 or M.', p_active_mult;
	end;

	begin
		v_active_phrase := rtrim( p_active_phrase );
	exception
		when check_violation then
			raise exception 'UI: Active phrase [%] violates format.', p_active_phrase;
	end;

	begin
		v_passive_mult := p_passive_mult;
	exception
		when check_violation then
			raise 'UI: Active multiplicity [%] must be 1 or M.', p_passive_mult;
	end;

	begin
		v_passive_phrase := rtrim( p_passive_phrase );
	exception
		when check_violation then
			raise exception 'UI: Active phrase [%] violates format.', p_passive_phrase;
	end;

	begin
		if p_assoc_class is not null then
			v_assoc_class := rtrim( p_assoc_class );
		end if;
		-- Otherwise, we will just pass the null along
	exception
		when check_violation then
			raise exception 'UI: Association class name [%] violates format.', p_assoc_class;
	end;

	if p_assoc_class is not null then -- Otherwise, it won't be used
		begin
			v_assoc_alias := rtrim( p_assoc_alias );
		exception
			when check_violation then
				raise exception 'UI: Association class alias [%] violates format.', p_assoc_alias;
		end;
	end if;

	-- Invoke function
	return method_binary_assoc_new(
		p_active_class, p_passive_class, p_subsys, p_domain,
		v_rnum,
		v_formalizing_persp,
		v_active_mult, p_active_cond, v_active_phrase,
		v_passive_mult, p_passive_cond, v_passive_phrase,
		v_assoc_class, v_assoc_alias
	);
end
$$
language plpgsql;
