\echo
\echo 'Reseting miUML2_tr...'
\pset border 0
\pset t
\echo '================'
select to_char( current_timestamp, 'HH24:MI:SS' );
\echo '================'
\echo
\pset t
\set VERBOSITY default

\set home `echo $miumlhome`
\cd :home

-- KILL ALL HUMANS
-- Drops all schemas so we start with a blank slate
\echo
\echo 'Killing all humans...'
\i kill_all_humans.sql

-- Define Relvars, Constraints, Subsystems and Domains (Tables, Constraints and Schemas )
\echo
\echo 'Loading relvars and constraints...'
\echo

\echo 'mi: System Relvars'
\i System/init_relvars.sql

\echo 'mitrack: Change Tracking Relvars'
\i 'Change Tracking/init_relvars.sql'

\echo 'miuml: Domain Relvars'
\i 'miUML Domain/init_relvars.sql'

\echo 'mitype: Type Subsystem Relvars'
\i 'Type Subsystem/init_relvars.sql'

\echo 'midom: Domain Subsystem Relvars'
\i 'Domain Subsystem/init_relvars.sql'

\echo 'miclass: Class Subsystem Relvars'
\i 'Class Subsystem/init_relvars.sql'

\echo 'mirel: Relationship Subsystem Relvars'
\i 'Relationship Subsystem/init_relvars.sql'

\echo 'miform: Formalization Subsystem Relvars'
\i 'Formalization Subsystem/init_relvars.sql'

\echo 'mirrid: RR Identifier Subsystem Relvars'
\i 'RR Identifier Subsystem/init_relvars.sql'

\echo 'mipoly: Poly Subsystem Relvars'
\i 'Poly Subsystem/init_relvars.sql'

\echo 'mistate: State Subsystem Relvars'
\i 'State Subsystem/init_relvars.sql'

-- Set path to all of the Schemas just created
-- The public schema is NOT used
set search_path to mi, mitrack, miuml, mitype, midom, miclass, mirel, miform, mirrid, mistate, mipoly;

\echo
\echo '--- All Relvars and Constraints Loaded ---'
\echo

-- Functions
\echo
\echo 'Loading Functions and Spec/Initial Data...'
\echo

-- System
\echo 'mi: Operations on System Types'
\set cwd :home '/System'
\cd :cwd
\! fmigen
\i f.sql

-- miUML Domain
\echo 'miuml: Operations on System Types'
\set cwd :home '/miUML Domain'
\cd :cwd
\! fmigen
\i f.sql

-- Change Tracking
\echo 'mitrack: Change Tracking Domain Functions'
\set cwd :home '/Change Tracking'
\cd :cwd
\! fmigen
\i f.sql

-- Type Subsystem
\echo 'mitype: Type Subsystem Functions'
\set cwd :home '/Type Subsystem'
\cd :cwd
\! fmigen
\i f.sql
\echo 'mitype: Starter types'
\i init_test.sql

-- Domain Subsystem
\echo 'midom: Domain Subsystem Functions'
\set cwd :home '/Domain Subsystem'
\cd :cwd
\! fmigen
\i f.sql
\echo 'midom: Spec data'
\i init_dbspec.sql
-- \echo 'midom: Example domain'
-- \i init_scenario.sql

-- Class and Attribute Subsystem
\echo 'miclass: Class Subystem Functions'
\set cwd :home '/Class Subsystem'
\cd :cwd
\! fmigen
\i f.sql

-- Relationship Subsystem
\echo 'mirel: Relationship Subsystem Functions'
\set cwd :home '/Relationship Subsystem'
\cd :cwd
\! fmigen
\i f.sql

-- Formalization Subsystem
\echo 'miform: Formalization Subsystem Functions'
\set cwd :home '/Formalization Subsystem'
\cd :cwd
\! fmigen
\i f.sql

-- RR Identifier Subsystem
\echo 'mirrid: RR Identifier Functions'
\set cwd :home '/RR Identifier Subsystem'
\cd :cwd
\! fmigen
\i f.sql

-- Poly Subsystem
\echo 'mipoly: Poly Functions'
\set cwd :home '/Poly Subsystem'
\cd :cwd
\! fmigen
\i f.sql

-- State Subsystem
\echo 'mistate: State Functions'
\set cwd :home '/State Subsystem'
\cd :cwd
\! fmigen
\i f.sql
\echo 'mistate: Initializing State Build Spec'
\i init_sbspec.sql

-- All relvars and functions loaded
\echo 'All relvars and functions loaded for the miUML domain.'
\cd :home
\set VERBOSITY default
\echo


-- Run Tests (if any)
\echo 'Running tests...'
\pset t
\echo
select to_char( current_timestamp, 'HH24:MI:SS' );
\echo
\pset t
\cd Tests
\i run_tests.sql
\echo '== Tests Completed == '


-- Set some quick nav variables for the psql debugging session
\set h :home
\set t :home '/Tests'
\set d :home '/Domain Subsystem'
\set c :home '/Class Subsystem'
\set r :home '/Relationship Subsystem'
\set i :home '/RR Identifier Subsystem'
\set s :home '/State Subsystem'
\set p :home '/Poly Subsystem'
\set ty :home '/Type Subsystem'
\set sys :home '/System'
\set mi :home  '/miUML Domain'

-- Always start off in the home directory though
\cd :home
\! pwd
\echo 
