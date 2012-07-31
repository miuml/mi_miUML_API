-- run_tests.sql

\set VERBOSITY default
\pset border 2

-- Test Binary To One Creation

\echo '--- Before Change --- '
\i test_binary_to_one_creation.sql
\i q_class_subsys.sql
\i q_to_one_rel.sql
\i q_to_one_form.sql

-- Test multiplicity change
-- select UI_set_mult( 1, 'P', 'Gas', '1', true );
begin;
set constraints all deferred;
select UI_set_mult( 1, 'P', 'Gas', 'M', false, 'Placement', 'PLACE' );
commit;

\echo '----------------------- After Change ----------------------- '
\i q_class_subsys.sql
\i q_to_one_rel.sql
\i q_to_one_form.sql

\echo '----------------------- State stuff ----------------------- '
-- Create a lifecycle
select UI_new_lifecycle( 'Lab', 'Gas' );

/*
\pset border 0


\i test_loop4.sql
\i q_class_subsys.sql
\i q_assoc_rel.sql
\i q_gen_rel.sql

\pset border 0
\set VERBOSITY terse
set client_min_messages=ERROR;


-- \echo '--- Before Deletion --- '
\i test_create_gen_rel.sql
\i test_binary_assoc_creation.sql
\i test_binary_to_one_creation.sql
\i test_binary_assoc_reflexive_symmetric_creation.sql

\i q_class_subsys.sql
\i q_gen_form.sql
\i q_gen_rel.sql
\i q_assoc_form.sql
\i q_assoc_rel.sql

\echo '--- Before Deletion --- '
\echo '--- After Deletion --- '

\i test_delete__rel.sql
\i q_class_subsys.sql
\i q_gen_form.sql
\i q_gen_rel.sql




\i test_create_classes.sql
\i q_class_subsys.sql

\i test_binary_assoc_reflexive_symmetric_creation.sql
\i q_class_subsys.sql
\i q_assoc_form.sql
\i q_assoc_rel.sql

\echo '--- After Deletion --- '
\i test_delete_rel.sql
\i q_class_subsys.sql
\i q_assoc_form.sql
\i q_assoc_rel.sql


\echo '--- Before Deletion --- '

\i test_binary_assoc_creation.sql
\i q_class_subsys.sql
\i q_assoc_form.sql
\i q_assoc_rel.sql

\echo '--- After Deletion --- '
\i test_delete_rel.sql
\i q_class_subsys.sql
\i q_assoc_form.sql
\i q_assoc_rel.sql


\echo '--- Before Deletion --- '

\i test_binary_to_one_reflexive_creation.sql
\i q_class_subsys.sql
\i q_to_one_form.sql
\i q_to_one_rel.sql

\echo '--- After Deletion --- '

\i test_delete_rel.sql
\i q_class_subsys.sql
\i q_to_one_form.sql
\i q_to_one_rel.sql

*/
