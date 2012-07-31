create or replace function mirel.method_unary_assoc_set_mult(
	p_mult			miuml.mult,	-- may be null (if so, cond will be specified)
	p_cond			boolean,	-- may be null (if so, mult will be specified)
	p_rnum			perspective.rnum%type,
	p_domain		perspective.domain%type,
	p_assoc_class	association_class.class%type,
	p_assoc_alias	miclass.class.alias%type
) returns void as 
$$
--
-- Changes the multiplicity of a Unary Symmetric Perspective.
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
	my_persp	perspective%rowtype;
	my_subsys	midom.subsystem_element.subsystem%type;
	-- The p_ mult and cond params may be null and params are never updated
	-- so corresponding new_ values will be updated so that they are guaranteed to
	-- be non-null when used later
	new_mult	miuml.mult;
	new_cond	boolean;
begin
	-- Get some perspective
	select * into strict my_persp from perspective where
		rnum = p_rnum and domain = p_domain; -- Side is always 'S' and only one in rel

	-- Fail if Mx and no Association Class specified
	if p_mult = 'M' and p_assoc_class is NULL then
		raise 'UI: Association class must be specified on a many symmetric association.';
	end if;

	-- Set mult and cond on perspective
	if p_mult is not null then
		if p_mult = 'M' then
			perform method_perspective_migrate_many( p_rnum, 'S', p_domain );
		else
			perform method_perspective_migrate_one( p_rnum, 'S', p_domain );
		end if;
		new_mult := p_mult;
	else
		new_mult := method_perspective_subclass( p_rnum, 'S', p_domain );
	end if;

	if p_cond is not null then
		update perspective set cond = p_cond where
			rnum = my_persp.rnum and domain = p_domain returning * into strict my_persp;
		new_cond := p_cond;
	else
		new_cond := my_persp.conditional;
	end if;
	-- Both new_mult and new_cond are now non-null and should now be used
	-- instead of the corresponding p_ params

	-- Re-derive the UML multiplicity based on the new values
	update perspective set
		uml_multiplicity = derive_perspective_uml_mult( new_mult, new_cond ) where
			rnum = my_persp.rnum and domain = p_domain
			returning * into strict my_persp;

	if p_assoc_class is not NULL then
		-- Lookup the existing association subsys
		my_subsys := method_class_get_subsys( my_persp.viewed_class, p_domain );
		
		-- Associative, 1x or Mx (using an Association Class)
		perform method_assoc_class_new(
			new_mult, my_persp.viewed_class, -- active
			new_mult, my_persp.viewed_class, -- passive
			p_assoc_class, p_assoc_alias,
			my_rnum, my_subsys, p_domain, true -- symmetric
		);
	else
		-- Non-associative 1x (Not using an Association Class)
		perform method_referring_participant_class_new(
			new_mult, new_cond, my_persp.viewed_class, -- active
			new_mult, new_cond, my_persp.viewed_class,
			NULL, my_rnum, p_domain
		);
	end if;
end
$$
language plpgsql;
