-- kill_all_humans.sql
--
-- Wipes out all existing Schemas
--
-- If you aren't familiar with the file name reference, please see:
-- http://www.youtube.com/watch?v=3owLjBkEtHs
--
-- Copyright 2011,2012 Model Integration, LLC
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
set client_min_messages=ERROR;

drop schema if exists mipoly cascade;
drop schema if exists mistate cascade;
drop schema if exists mirrid cascade;
drop schema if exists miform cascade;
drop schema if exists mirel cascade;
drop schema if exists miclass cascade;
drop schema if exists midom cascade;
drop schema if exists mitype cascade;
drop schema if exists miuml cascade;
drop schema if exists mi cascade;

set client_min_messages=NOTICE;
