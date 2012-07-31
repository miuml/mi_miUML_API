create or replace function mirel.method_perspective_new(
	-- Existing
	p_rnum			perspective.rnum%type,
	p_viewed_class	perspective.viewed_class%type,
	p_domain		miclass.class.domain%type,

	-- New
	p_mult			miuml.mult,						-- 1, M
	p_cond			perspective.conditional%type,	-- Conditional if true
	p_phrase		perspective.phrase%type,		-- Name of phrase
	p_side			perspective.side%type			-- A or P or S

) returns void as 
$$
--
-- Create a new Perspective (with all subclasses)
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
	-- Create Perspective instance
	begin
		insert into perspective(
			side, rnum, domain, viewed_class, phrase, conditional, uml_multiplicity
		) values(
			p_side, p_rnum, p_domain, p_viewed_class, p_phrase, p_cond,
			derive_perspective_uml_mult( p_mult, p_cond )
		);
	exception
		when foreign_key_violation then
			raise exception 'UI: Class [%] does not exist for perspective [%:%].',
				p_viewed_class, p_rnum, p_phrase;
	end;

	-- Create One/Many Perspective instance
	if p_mult = '1' then
		insert into one_perspective( rnum, domain, side ) values(
			p_rnum, p_domain, p_side
		);
	else -- p_mult must be 'M'
		insert into many_perspective( rnum, domain, side ) values(
			p_rnum, p_domain, p_side
		);
	end if;

	if p_side = 'S' then
		-- Create Symmetric Perspective
		insert into symmetric_perspective( rnum, domain, side ) values(
			p_rnum, p_domain, p_side
		);
		return;
	end if;
	-- We're done if it was Symmetric, otherwise...

	-- Create Assymmetric Perspective
	insert into asymmetric_perspective( rnum, domain, side ) values(
		p_rnum, p_domain, p_side
	);

	-- Create Active / Passive instances
	if p_side = 'A' then
		insert into active_perspective( rnum, domain, side ) values(
			p_rnum, p_domain, 'A'
		);
	else
		insert into passive_perspective( rnum, domain, side ) values(
			p_rnum, p_domain, 'P'
		);
	end if;
end
$$
language plpgsql;
