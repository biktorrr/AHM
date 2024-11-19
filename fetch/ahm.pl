:- module(ahm,
	  [ ahm/3,
	    ahm_save/3,
	    ahm_save_collection/1
	  ]).
:- use_module(adlib).

db(collection, 'ChoiceCollect').
db(people,     'ChoicePeople').
db(thesaurus,  'ChoiceThesaurus').
db(cataloque,  'ChoiceFullCatalogue').

%%	ahm(+DB, -XML, +Options)

ahm(Alias, XML, Options) :-
	db(Alias, DB),
	adlib_fetch('http://ahm.adlibsoft.com/vu_wwwopacx/wwwopac.ashx',
		    DB,
		    XML,
		    Options).


%%	ahm_save(+DBAlias, +File, +Options)
%
%	Used to download complete databases.  E.g.,
%
%	    ==
%	    ?- ahm_save(people, 'people.xml',
%			[ search(all),
%			  xmltype(grouped),
%			  limit(100000)
%			]).
%	    ==

ahm_save(Alias, File, Options) :-
	open(File, write, Out, [encoding(utf8)]),
	call_cleanup((ahm(Alias, XML, Options),
		      xml_write(Out, XML, [])),
		     close(Out)).


ahm_save_collection(Base) :-
	debug(ahm),
	ahm_save_collection(Base, 1, 1000).

ahm_save_collection(Base, From, Size) :-
	End is From+Size,
	format(atom(File), '~w-~w-~w.xml', [Base, From, End]),
	debug(ahm, 'Fetching ~w..~w', [From, End]),
	ahm_save(collection, File,
		 [ search(all),
		   xmltype(grouped),
		   startfrom(From),
		   limit(Size)
		 ]),
	ahm_save_collection(Base, End, Size).
