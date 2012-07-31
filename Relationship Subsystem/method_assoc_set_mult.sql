create or replace function mirel.method_assoc_set_mult(
	-- New
	p_new_mult		miuml.mult,
	p_new_cond		boolean,	-- may be null
	-- Existing
	p_rnum			perspective.rnum%type,
	p_side			perspective.side%type,
	p_domain		perspective.domain%type,
	p_assoc_class	association_class.class%type,
	p_assoc_alias	miclass.class.alias%type
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
begin
	-- Keep the Relationship with its Element number and Perspectives, but wipe out all
	-- References and Formalizing Classes.
	perform method_rel_clean( p_rnum, p_domain );

	-- Now rebuild it all based on the new multiplicity
	if method_assoc_subclass( p_rnum, p_domain ) = 'unary' then
		-- Rebuld unary
		perform method_unary_assoc_set_mult(
			p_new_mult, p_new_cond, p_rnum, p_domain, p_assoc_class, p_assoc_alias
		);
	else
		-- Rebuld binary
		perform method_binary_assoc_set_mult( p_new_mult, p_new_cond, p_rnum, p_side, p_domain,
			p_assoc_class, p_assoc_alias
		);
	end if;
end
$$
language plpgsql;
