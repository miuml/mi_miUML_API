create or replace function miform.method_referring_participant_class_new(
	p_active_mult			miuml.mult,					-- 1, M
	p_active_cond			boolean,
	p_active_class			miclass.class.name%type,	-- Class on active perspective

	p_passive_mult			miuml.mult,					-- 1, M
	p_passive_cond			boolean,
	p_passive_class			miclass.class.name%type,	-- Class on passive perspective

	p_formalizing_persp		asymmetric_perspective.side%type,	-- A or P
	p_rnum					referring_participant_class.rnum%type,
	p_domain				referring_participant_class.domain%type
) returns void as 
$$
--
-- Create a new Referring Participant Class
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
	-- Reference will be from one class to the other
	-- Using my_ prefix to avoid name conflict with attribute names
	my_from_persp	asymmetric_perspective.side%type;
	my_to_persp		asymmetric_perspective.side%type;
	my_from_class	miclass.class.name%type;
	my_to_class		miclass.class.name%type;
	my_to_cond		boolean;
	my_from_mult	miuml.mult;
begin
	-- You cannot refer to an M side, so the To perspective
	-- must be a 1 side.  So, the formalizing perspective may
	-- be user specified only in the 1x:1x case.
	if p_active_mult = 'M' then
		my_from_persp := 'A';
	elsif p_passive_mult = 'M' then
		my_from_persp := 'P';
	else
		my_from_persp := p_formalizing_persp;
	end if;

	-- Set from and to params
	if my_from_persp = 'A' then
		my_from_class := p_active_class;
		my_from_mult := p_active_mult;
		my_to_persp := 'P';
		my_to_class := p_passive_class;
		my_to_cond := p_passive_cond;
	else -- my_from_persp = 'P'
		my_from_class := p_passive_class;
		my_from_mult := p_passive_mult;
		my_to_persp = 'A';
		my_to_class := p_active_class;
		my_to_cond := p_active_cond;
	end if;

	-- Create Formalization
	insert into formalizing_class( rnum, class, domain )
		values( p_rnum, my_from_class, p_domain );

	-- Create self instance
	insert into referring_participant_class( rnum, class, domain )
		values( p_rnum, my_from_class, p_domain );
	
	-- Create the Reference Path
	insert into reference_path( from_class, to_class, rnum, domain )
		values( my_from_class, my_to_class, p_rnum, p_domain );

	-- Create the To One Reference
	perform miform.method_to_one_ref_new(
		my_from_mult, my_from_class, my_to_class, my_to_persp, my_to_cond, p_rnum, p_domain
	);
end
$$
language plpgsql;
