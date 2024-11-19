:- module(ahm_rewrite,
	  [ rewrite/0,
	    rewrite/1,
	    rewrite/2,
	    list_rules/0
	  ]).
:- use_module(library(semweb/rdf_db)).
:- use_module(xmlrdf(rdf_convert_util)).
:- use_module(xmlrdf(cvt_vocabulary)).
:- use_module(xmlrdf(rdf_rewrite)).

:- debug(rdf_rewrite).

%%	rewrite
%
%	Apply all rules on the graph =data=

rewrite :-
	rdf_rewrite(data).

%%	rewrite(+Rule)
%
%	Apply the given rule on the graph =data=

rewrite(Rule) :-
	rdf_rewrite(data, Rule).

%%	rewrite(+Graph, +Rule)
%
%	Apply the given rule on the given graph.

rewrite(Graph, Rule) :-
	rdf_rewrite(Graph, Rule).

%%	list_rules
%
%	List the available rules to the console.

list_rules :-
	rdf_rewrite_rules.

:- discontiguous
	rdf_mapping_rule/5.

people_type @@
{ A, rdf:type, ahm:'Record' }
	<=>
	{ A, rdf:type, ahm:'Person' }.


people_uris @@
{ A, ahm:name, Name } \ {A} <=>
	rdf_is_bnode(A),
	literal_to_id(Name, ahm, S),
	{S}.

