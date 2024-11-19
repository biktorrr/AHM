:- module(adlib,
	  [ adlib_fetch/4
	  ]).
:- use_module(library(uri)).
:- use_module(library(http/http_open)).
:- use_module(library(sgml)).

%%	adlib_fetch(+BaseURI, +DB, -XML, +Options) is det.
%
%	Fetch records from an adlib  server.   Options  is passed to the
%	search engine and may contain:
%
%	    * search(+Spec)
%	    Searching for =all= retrieves all records
%	    * priref(+PriRef)
%	    * limit(+Count)
%	    * startfrom(+Count)
%	    * xmltype(+Type)
%	    One of =unstructured= or =grouped=
%
%	@see http://test.adlibsoft.com/adlibapi/

adlib_fetch(BaseURI, DB, XML, Options) :-
	(   option(priref(PriRef), Options)
	->  atom_concat('priref=', PriRef, Search),
	    TheOptions = [search(Search)|Options]
	;   TheOptions = Options
	),
	uri_components(BaseURI, Components),
	uri_query_components(Query,
			     [ database(DB)
			     | TheOptions
			     ]),
	uri_data(search, Components, Query),
	uri_components(RequestURI, Components),
	debug(adlib, 'URI=~q', [RequestURI]),
	setup_call_cleanup(http_open(RequestURI, In, []),
			   load_structure(stream(In), XML, [dialect(xml)]),
			   close(In)).
