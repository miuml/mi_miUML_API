create or replace function mirel.UI_set_mult(
	-- Existing
	p_rnum			mi.nominal,	-- Rnum is assigned if not provided			
	p_persp			text,		-- miuml.side: A, P, or S
	p_domain		mi.name,	-- Domain
	-- New
	-- At least of these two must be set
	p_new_mult		text default null,		-- mi.mult: 1 | M
	p_new_cond		boolean default null,	-- new conditionality, optional
	-- New or existing
	p_assoc_class	text default null,	-- mi.name: Name of new or exisiting class
	-- New
	p_assoc_alias	text default null	-- mi.short_name: Required if class is new
) returns void as 
$$
--
-- Changes the multiplicity of an Association Perspective.  This will change
-- the underlying Referential Attributes and Required Referential Identifiers.
-- When changing from a non-associative 1x:1x or 1x:Mx to an Mx:Mx, an
-- Association Class must be specified.  The alias is required if the Association
-- Class will be newly created.  Conditionality may be supplied also.  If it is
-- omitted, NULL, then it is not changed.
--
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
	v_new_mult			miuml.mult;
	v_persp				miuml.side;
	v_assoc_class		mi.name;
	v_assoc_alias		mi.short_name;
begin

	-- Ensure that either or both mult and cond are set
	if ( p_new_mult is null ) and ( p_new_cond is null ) then
		raise 'UI: Conditionality, multiplicity or both must be specified.';
	end if;
	
	-- Input validation
	begin
		v_new_mult := p_new_mult;
	exception
		when check_violation then
			raise 'UI: Multiplicity [%] must be 1 or M.', p_new_mult;
	end;

	begin
		v_persp := p_persp;
	exception
		when check_violation then
			raise 'UI: Perspective [%] must be A, P or S.', p_persp;
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
	perform method_assoc_set_mult(
		v_new_mult, p_new_cond, p_rnum, v_persp, p_domain, v_assoc_class, v_assoc_alias
	);
end
$$
language plpgsql;
