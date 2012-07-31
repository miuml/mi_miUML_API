create or replace function mirel.method_binary_assoc_new(
	-- Existing
	p_active_class			miclass.class.name%type,	-- Class on active perspective
	p_passive_class			miclass.class.name%type,	-- Class on passive perspective
	p_subsys				midom.subsystem.name%type,	-- The Subsystem
	p_domain				miclass.class.domain%type,	-- Domain of both Classes
	-- New
	p_rnum					binary_association.rnum%type,
	p_formalizing_persp		asymmetric_perspective.side%type,	-- A or P

	p_active_mult			miuml.mult,					-- 1, M
	p_active_cond			boolean,					-- Conditional if true
	p_active_phrase			perspective.phrase%type,	-- Name of active phrase

	p_passive_mult			miuml.mult,					-- 1, M
	p_passive_cond			boolean,					-- Conditional if true
	p_passive_phrase		perspective.phrase%type,	-- Name of passive phrase

	p_assoc_class			miclass.class.name%type,	-- May be NULL
	p_assoc_alias			miclass.class.alias%type	-- May be NULL
) returns binary_association.rnum%type as 
$$
--
-- Create a new Binary Association.  If an Association Class is specified it will be used
-- to formalize the Association.  If the Association Class does not exist, it will be created.
-- If it must be created, then there must be an alias provided.
--
-- If the multiplicity is Mx:Mx, an Association Class must be specified.
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
	my_rnum				binary_association.rnum%type;
	conflict_rnum		association_class.rnum%type;
begin
	-- Create self
	my_rnum := method_assoc_new( p_subsys, p_domain, p_rnum );
	insert into binary_association( rnum, domain ) values( my_rnum, p_domain );

	-- Create Active Perspective
	perform method_perspective_new(
		my_rnum, p_active_class, p_domain,
		p_active_mult, p_active_cond, p_active_phrase, 'A'
	);

	-- Create Passive Perspective
	perform method_perspective_new(
		my_rnum, p_passive_class, p_domain,
		p_passive_mult, p_passive_cond, p_passive_phrase, 'P'
	);

	-- Fail if M:M and no Association Class specified
	if ( p_passive_mult = 'M' and p_active_mult = 'M' ) and p_assoc_class is NULL then
		raise 'UI: Association class must be specified on a many-to-many association.';
	end if;

	if p_assoc_class is not NULL then
		-- Associative, any multiplicity (using an Association Class)
		perform method_assoc_class_new(
			p_active_mult, p_active_class,
			p_passive_mult, p_passive_class,
			p_assoc_class, p_assoc_alias,
			my_rnum, p_subsys, p_domain
		);
	else
		-- Non-associative 1x:1x or 1x:Mx (Not using an Association Class)
		perform method_referring_participant_class_new(
			p_active_mult, p_active_cond, p_active_class,
			p_passive_mult, p_passive_cond, p_passive_class,
			p_formalizing_persp, my_rnum, p_domain
		);
	end if;

	return my_rnum;
end
$$
language plpgsql;
