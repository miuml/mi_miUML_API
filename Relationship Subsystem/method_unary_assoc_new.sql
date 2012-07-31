create or replace function mirel.method_unary_assoc_new(
	-- Existing
	p_class			miclass.class.name%type,
	p_subsys		midom.subsystem.name%type,
	p_domain		miclass.class.domain%type,
	-- New
	p_rnum			unary_association.rnum%type,

	p_mult			miuml.mult,					-- 1, M
	p_cond			boolean,					-- Conditional if true
	p_phrase		perspective.phrase%type,	-- Name of active phrase

	p_assoc_class	miclass.class.name%type,	-- May be NULL
	p_assoc_alias	miclass.class.alias%type	-- May be NULL
) returns binary_association.rnum%type as 
$$
--
-- Create a new Unary Association.  If an Association Class is specified, it will be used
-- to formalize the Association.  If the Association Class does not exist, it will be created.
-- If it must be created, then there must be an alias provided.
--
-- If the multiplicity is Mx an Association Class must be specified.
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
	my_rnum				unary_association.rnum%type;
	conflict_rnum		association_class.rnum%type;
begin
	-- Create self
	my_rnum := method_assoc_new( p_subsys, p_domain, p_rnum );
	insert into unary_association( rnum, domain ) values( my_rnum, p_domain );

	-- Create Symmetric Perspective
	perform method_perspective_new(
		my_rnum, p_class, p_domain,
		p_mult, p_cond, p_phrase, 'S'
	);

	-- Fail if Mx and no Association Class specified
	if p_mult = 'M' and p_assoc_class is NULL then
		raise exception 'UI: Association class must be specified on a many symmetric association.';
	end if;

	if p_assoc_class is not NULL then
		-- Associative, 1x or Mx (using an Association Class)
		perform method_assoc_class_new(
			p_mult, p_class, -- active
			p_mult, p_class, -- passive
			p_assoc_class, p_assoc_alias,
			my_rnum, p_subsys, p_domain, true -- symmetric
		);
	else
		-- Non-associative 1x (Not using an Association Class)
		perform method_referring_participant_class_new(
			p_mult, p_cond, p_class, -- active
			p_mult, p_cond, p_class,
			NULL, my_rnum, p_domain
		);
	end if;

	return my_rnum;
end
$$
language plpgsql;
