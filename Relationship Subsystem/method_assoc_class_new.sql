create or replace function mirel.method_assoc_class_new(
	p_active_mult			miuml.mult,					-- 1, M
	p_active_class			miclass.class.name%type,	-- Class on active perspective

	p_passive_mult			miuml.mult,					-- 1, M
	p_passive_class			miclass.class.name%type,	-- Class on passive perspective

	p_assoc_class			association_class.class%type, 	-- New or Existing Class name
	p_assoc_alias			miclass.class.alias%type,		-- NULL if existing

	p_rnum					association_class.rnum%type,
	p_subsys				midom.subsystem.name%type,		-- Needed for new Class
	p_domain				association_class.domain%type,
	p_symmetric				boolean default false
) returns void as 
$$
--
-- Creates a new Association Class role for a Class that already exists or
-- by creating a new Class.
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
begin
	-- Does a Class for this Association Class role already exist?
	perform * from miclass.class where name = p_assoc_class and domain = p_domain;
	if not found then
		-- It doesn't exist, so we'll need an alias
		if p_assoc_alias is NULL then
			raise exception 'UI: No alias supplied for specified association class.';
		end if;
		-- Create the class to be used as an association class first
		perform miclass.method_class_new(
			-- Options NULL: no cnum, true: formalizing class - no id needed
			p_assoc_class, p_assoc_alias, p_subsys, p_domain, NULL, true
		);
	end if;

	-- Create Formalization
	insert into formalizing_class( rnum, class, domain )
		values( p_rnum, p_assoc_class, p_domain );

	declare
		conflict_rnum		association_class.rnum%type;
	begin
		insert into association_class( rnum, class, domain )
			values( p_rnum, p_assoc_class, p_domain );
	exception
		when unique_violation then
			-- The class is already playing an association class role elsewhere
			select rnum from association_class where
				class = p_assoc_class and domain = p_domain into conflict_rnum;
			raise exception
				'UI: Class [%::%] is already used on R[%] as an association class.',
					p_domain, p_assoc_class, conflict_rnum;
	end;


	-- Build T/P References
	-- The t ref -> active persp and p ref -> passive persp
	-- The pairing is arbitrary.  It could have been t to passive, instead.
	--
	-- Create a Reference Path and Reference for each direction

	-- This Reference Path is followed by the T Reference in an Asymmetric Perspective
	-- or BOTH T and P References in a Symmetric Perspective
	insert into reference_path( from_class, to_class, rnum, domain )
		values( p_assoc_class, p_active_class, p_rnum, p_domain );
	if p_symmetric then
		-- Both References (T and P) follow the same Reference Path
		perform miform.method_associative_ref_new(
			'T', 'S', p_active_mult, p_active_mult, -- Both the same
			p_rnum, p_domain, p_assoc_class, p_active_class -- Passive and active are the same
		);
		perform miform.method_associative_ref_new(
			'P', 'S', p_active_mult, p_active_mult,  -- Both the same
			p_rnum, p_domain, p_assoc_class, p_active_class -- Passive and active are the same
		);
		return;  -- We're done, if Symmetric
	end if;

	-- The Perspective is Asymmetric, so the T Reference points to the Active Perspective
	-- Along the first Reference Path
	perform miform.method_associative_ref_new(
		'T', 'A', p_active_mult, p_passive_mult,
		p_rnum, p_domain, p_assoc_class, p_active_class
	);

	-- P ref to Passive Perspective
	-- A separate Reference Path is not required on a reflexive assocaition
	-- Both T and P follow the path from and to the same Class
	if p_passive_class != p_active_class then
		-- Non Reflexive, Asymmetric: Need a second Reference Path
		-- to the other referenced Class
		insert into reference_path( from_class, to_class, rnum, domain )
			values( p_assoc_class, p_passive_class, p_rnum, p_domain );
	end if; -- Otherwise, Reflexive, from-to is the same Path for both T and P References
	perform miform.method_associative_ref_new(
		'P', 'P', p_passive_mult, p_active_mult,
		p_rnum, p_domain, p_assoc_class, p_passive_class
	);
end
$$
language plpgsql;

