create or replace function mirel.method_binary_assoc_set_mult(
	p_mult			miuml.mult,	-- may be null (if so, cond will be specified)
	p_cond			boolean,	-- may be null (if so, mult will be specified)
	p_rnum			perspective.rnum%type,
	p_side			perspective.side%type,
	p_domain		perspective.domain%type,
	p_assoc_class	association_class.class%type,
	p_assoc_alias	miclass.class.alias%type
) returns void as 
$$
--
-- Changes the multiplicity of a Binary Symmetric Perspective.
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
	my_persp		perspective%rowtype;
	my_subsys		midom.subsystem_element.subsystem%type;
	-- The p_ mult and cond params may be null and params are never updated
	-- so corresponding new_ values will be updated so that they are guaranteed to
	-- be non-null when used later
	new_mult		miuml.mult;
	new_cond		boolean;
	opp_side		asymmetric_perspective.side%type;
	active_mult		miuml.mult;
	active_cond		boolean;
	active_class	perspective.viewed_class%type;
	passive_mult	miuml.mult;
	passive_cond	boolean;
	passive_class	perspective.viewed_class%type;
	opp_persp		perspective%rowtype;
begin
	-- Get some perspective
	select * into strict my_persp from perspective where
		rnum = p_rnum and side = p_side and domain = p_domain;

	-- Set mult and cond on perspective
	if p_mult is not null then
		if p_mult = 'M' then
			perform method_perspective_migrate_many( p_rnum, p_side, p_domain );
		else
			perform method_perspective_migrate_one( p_rnum, p_side, p_domain );
		end if;
		new_mult := p_mult;
	else
		new_mult := method_perspective_mult( p_rnum, p_side, p_domain );
	end if;

	if p_cond is not null then
		update perspective set conditional = p_cond where
			rnum = my_persp.rnum and side = p_side and domain = p_domain
				returning * into strict my_persp;
		new_cond := p_cond;
	else
		new_cond := my_persp.conditional;
	end if;
	-- Both new_mult and new_cond are now non-null and should now be used
	-- instead of the corresponding p_ params

	-- Re-derive the UML multiplicity based on the new values
	update perspective set
		uml_multiplicity = derive_perspective_uml_mult( new_mult, new_cond ) where
			rnum = my_persp.rnum and side = p_side and domain = p_domain
			returning * into strict my_persp;

	-- Get values for existing perspectives
	if p_side = 'A' then
		active_mult := new_mult;
		active_cond := new_cond;
		active_class := my_persp.viewed_class;
		opp_side := 'P';
		select * into strict opp_persp from perspective where
			rnum = p_rnum and side = opp_side and domain = p_domain;
		passive_mult := method_perspective_mult( p_rnum, opp_side, p_domain );
		passive_cond := opp_persp.conditional;
		passive_class := opp_persp.viewed_class;
	else
		passive_mult := new_mult;
		passive_cond := new_cond;
		passive_class := my_persp.viewed_class;
		opp_side := 'A';
		select * into strict opp_persp from perspective where
			rnum = p_rnum and side = opp_side and domain = p_domain;
		active_mult := method_perspective_mult( p_rnum, opp_side, p_domain );
		active_cond := opp_persp.conditional;
		active_class := opp_persp.viewed_class;
	end if;

	if p_assoc_class is not NULL then
		-- Lookup the existing association subsys
		my_subsys := method_class_get_subsys( my_persp.viewed_class, p_domain );

		-- Associative, 1x or Mx (using an Association Class)
		perform method_assoc_class_new(
			active_mult, active_class, -- active
			passive_mult, passive_class, -- passive
			p_assoc_class, p_assoc_alias,
			p_rnum, my_subsys, p_domain
		);

	else
		-- Fail if M:M and no Association Class specified
		if passive_mult = 'M' and active_mult = 'M' then
			raise 'UI: Association class must be specified on a many-to-many association.';
		end if;

		/*
		raise 'A: %, %, % / P: %, %, %', 
			active_mult, active_cond, active_class,
			passive_mult, passive_cond, passive_class;
			*/

		-- Non-associative 1x (Not using an Association Class)
		perform method_referring_participant_class_new(
			active_mult, active_cond, active_class,
			passive_mult, passive_cond, passive_class,
			NULL, p_rnum, p_domain
		);
	end if;
end
$$
language plpgsql;
