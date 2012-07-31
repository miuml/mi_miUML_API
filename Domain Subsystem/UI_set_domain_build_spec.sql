create or replace function midom.UI_set_domain_build_spec(
	-- Focus
	p_name  mi.name default 'singleton',
	-- Modify
    p_new_domain_name_is_default_subsys_name  boolean  default null,    -- ::mi.boolean
    p_new_default_id_name                     text     default null,    -- ::mi.name
    p_new_default_subsys_name                 text     default null,    -- ::mi.name
    p_new_default_subsys_range                integer  default null,    -- ::mi.posint
    p_new_default_id_type                     text     default null    -- ::mi.name
) returns void as 
$$
--
-- UI Bridge: Sets Domain_Build_Spec attributes
-- ++ -
-- Sets any or all default values consulted when a new Domain is created.
-- 
-- new_domain_is_default_subsys_name:  If true, and you create domain named 'App', its default
-- initial subsystem will also be named 'App'.  Otherwise, the new_default_subsys_name is used.
-- 
-- new_default_id_name: Name of default local identifier attribute created for each new class.
-- If it is 'Number', for example, each new Class will automatically be created with an
-- initial Number identifier attribute.
-- 
-- new_default_subsys_name:  Default name of a new Domain's initial subsystem such as 'Main'.
-- Not consulted if new_domain_is_default_subsys_name is true.
-- 
-- new_default_subsys_range:  The initial numbering range of a new Domain's default first
-- subsystem.  100 is typical.
-- 
-- new_default_id_type:  The type of the identifier attribute automatically created for a
-- new class.  Consulted in conjunction with new_default_id_name.  If that value is Number,
-- then Nominal might be a good choice.  On the other hand if the new_default_id_name is
-- Name then the eponymous type Name could be appropriate.
-- ==
--
-- Copyright 2012 Model Integration, LLC
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
declare
	v_new_domain_name_is_default_subsys_name  domain_build_spec.domain_name_is_default_subsys_name%type;
	v_new_default_id_name                     domain_build_spec.default_id_name%type;
	v_new_default_subsys_name                 domain_build_spec.default_subsys_name%type;
	v_new_default_subsys_range                domain_build_spec.default_subsys_range%type;
	v_new_default_id_type                     domain_build_spec.default_id_type%type;
begin
	-- Validate attributes
	begin
		v_new_domain_name_is_default_subsys_name := p_new_domain_name_is_default_subsys_name;
	exception
		when check_violation then
			raise exception 'UI: New domain_name_is_default_subsys_name [%] violates type: boolean.',
            p_new_domain_name_is_default_subsys_name;
	end;
	begin
		v_new_default_id_name := trim( p_new_default_id_name );
	exception
		when check_violation then
			raise exception 'UI: New default_id_name [%] violates type: name.',
            p_new_default_id_name;
	end;
	begin
		v_new_default_subsys_name := trim( p_new_default_subsys_name );
	exception
		when check_violation then
			raise exception 'UI: New default_subsys_name [%] violates type: name.',
            p_new_default_subsys_name;
	end;
	begin
		v_new_default_subsys_range := p_new_default_subsys_range;
	exception
		when check_violation then
			raise exception 'UI: New default_subsys_range [%] violates type: posint.',
            p_new_default_subsys_range;
	end;
	begin
		v_new_default_id_type := trim( p_new_default_id_type );
	exception
		when check_violation then
			raise exception 'UI: New default_id_type [%] violates type: name.',
            p_new_default_id_type;
	end;

	-- Call app
	perform method_domain_build_spec_set(
        p_name := p_name,
        p_new_domain_name_is_default_subsys_name := v_new_domain_name_is_default_subsys_name,
        p_new_default_id_name := v_new_default_id_name,
        p_new_default_subsys_name := v_new_default_subsys_name,
        p_new_default_subsys_range := v_new_default_subsys_range,
        p_new_default_id_type := v_new_default_id_type
    );
end
$$
language plpgsql;
