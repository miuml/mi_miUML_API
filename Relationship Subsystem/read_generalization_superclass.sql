create or replace function mirel.read_generalization_superclass(
	p_rnum		generalization.rnum%type,
	p_domain	generalization.domain%type
) returns generalization.superclass%type as 
$$
--
-- Read: Generalization.Superclass 
--
--
-- Copyright 2012, Model Integration, LLC
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
	self	generalization%rowtype;
begin
	select * into strict self from generalization where
		rnum = p_rnum and domain = p_domain;

	return self.superclass;
end
$$
language plpgsql;
