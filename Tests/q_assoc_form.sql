-- Binary Association Formalization (non-associative)

\echo
\echo '--'
\echo 'Formalizing Classes'
select * from formalizing_class;
\echo 'Referring Participant Classes'
select * from referring_participant_class;
\echo 'Reference Paths'
select * from reference_path;
\echo 'References'
select * from reference;
\echo 'Associative References'
select * from associative_reference;
\echo 'T References'
select * from t_reference;
\echo 'P References'
select * from p_reference;
\echo 'Symmetric Associative References'
select * from symmetric_assoc_reference;
\echo 'Asymmetric Associative References'
select * from asymmetric_assoc_reference;
\echo 'To Many in Mx:Mx Associative References'
select * from to_many_in_mx_mx_assoc_ref;
\echo 'To Many in Mx:Mx T Associative References'
select * from to_many_in_mx_mx_assoc_tref;
\echo 'To Many in Mx:Mx P Associative References'
select * from to_many_in_mx_mx_assoc_pref;
\echo '--'
\echo 'RR Associative MM Identifier'
select * from rr_assoc_mm_identifier;
