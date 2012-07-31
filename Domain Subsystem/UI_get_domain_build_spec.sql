create or replace function midom.UI_get_domain_build_spec(
	o_domain_name_is_default_subsys_name		OUT boolean,
	o_default_subsys_name						OUT mi.name,
	o_default_subsys_range						OUT mi.posint,
	o_default_id_name							OUT mi.name,
	o_default_id_type							OUT mi.name
) returns record as 
$$
--
-- Returns all data in the Domain Build Spec.
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
	the_spec	domain_build_spec%rowtype;
begin
	select * into strict the_spec from domain_build_spec where name = 'singleton';

	o_domain_name_is_default_subsys_name := the_spec.domain_name_is_default_subsys_name;
	o_default_subsys_name := the_spec.default_subsys_name;
	o_default_subsys_range := the_spec.default_subsys_range;
	o_default_id_name := the_spec.default_id_name;
	o_default_id_type := the_spec.default_id_type;

exception
	when no_data_found then
		raise exception 'SYS: Domain Build Specification not initialized.';
end
$$
language plpgsql;
