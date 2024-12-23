:- set_prolog_stack(global, limit(10**9)),
   set_prolog_stack(trail,  limit(10**9)).

:- prolog_load_context(directory, Dir),
   asserta(user:file_search_path(ahm, Dir)).

user:file_search_path(xmlrdf,     ahm('../xmlrdf')).
user:file_search_path(triple20,   ahm('../triple20/src')).
user:file_search_path(cliopatria, ahm('../ClioPatria')).
user:file_search_path(getty,      ahm('../../eculture/RDF/vocabularies/getty')).
user:file_search_path(serql,      cliopatria('SeRQL')).

:- load_files(library(semweb/rdf_db), [silent(true)]).

:- rdf_register_ns(ahm,	   'http://purl.org/vocabularies/ahm/').
:- rdf_register_ns(ulan,   'http://e-culture.multimedian.nl/ns/getty/ulan#').
:- rdf_register_ns(aatned, 'http://e-culture.multimedian.nl/ns/rkd/aatned/').
:- rdf_register_ns(skos,   'http://www.w3.org/2004/02/skos/core#').
:- rdf_register_ns(foaf,   'http://xmlns.com/foaf/0.1/').

:- load_files([ xmlrdf(xmlrdf),
		xmlrdf(rdf_schema),
		triple20(load),
		library(semweb/rdf_cache),
		serql(lib/semweb/rdf_library),
		library(semweb/rdf_turtle_write),
		xmlrdf(http_browse)
	      ], [silent(true)]).
:- use_module('rewrite-people').

load_ontologies :-
	rdf_attach_library(cliopatria(ontologies)),
	rdf_attach_library(getty(.)),
	rdf_load_library(dc),
	rdf_load_library(skos),
	rdf_load_library(rdfs),
	rdf_load_library(owl),
	absolute_file_name(ahm('ahm-voc-schema.ttl'), Schema, [access(read)]),
	rdf_load(Schema).

:- initialization			% run *after* loading this file
	ensure_dir(cache),
	rdf_set_cache_options([ global_directory('cache/rdf'),
				create_global_directory(true)
			      ]),
	load_ontologies.

ensure_dir(Dir) :-
	exists_directory(Dir), !.
ensure_dir(Dir) :-
	make_directory(Dir).


:- debug(xmlrdf).

run :-
	run('people.xml'),
	make_schema(data, schema).

run(File) :-
	rdf_current_ns(ahm, Prefix),
	load_xml_as_rdf(File,
			[ dialect(xml),
			  unit(record),
			  prefix(Prefix)
			]).


clean :-
	rdf_retractall(_,_,_,data).

save :-
	rdf_save_turtle('people.ttl', [graph(data)]).
