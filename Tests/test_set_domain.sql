begin;
set constraints all deferred;
select UI_set_domain( p_name:='App', p_new_name:='Pig' );
commit;
