-- Delete Generalization Relationship
begin;
set constraints all deferred;
select UI_delete_relationship( 1, 'App' );
commit;

