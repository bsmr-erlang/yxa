%% This module tests interpret_cpl.erl but also a substantial part of
%% interpret_backend.erl, as test_backend.erl mostly sends its calls
%% onward to interpret_backend.erl - the exceptions are a few 
%% functions (mainly test_proxy_destinations(...)) which manipulate 
%% the state in YXA.
%%--------------------------------------------------------------------
-module(interpret_cpl_test).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([
	 test/0
	]).

%%--------------------------------------------------------------------
%% Internal exports
%%--------------------------------------------------------------------
-export([

        ]).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------

-include("cpl.hrl").
%% -include("sipproxy.hrl").
%% -include("siprecords.hrl").

%%--------------------------------------------------------------------
%% Records
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% Macros
%%--------------------------------------------------------------------

%%====================================================================
%% External functions
%%====================================================================

%%====================================================================
%% Behaviour functions
%%====================================================================

%%====================================================================
%% Internal functions
%%====================================================================

%%====================================================================
%% Test functions
%%====================================================================

%%--------------------------------------------------------------------
%% Function: test()
%% Descrip.: autotest callback
%% Returns : ok
%%--------------------------------------------------------------------
test() ->
    
    %% process_cpl_script/7 
    %%--------------------------------------------------------------------
    %% 
    io:format("test: process_cpl_script/7 - 1~n"),
    test1(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 2~n"),
    test2(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 3~n"),
    test3(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 4~n"),
    test4(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 5~n"),
    test5(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 6~n"),
    test6(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 6b~n"),
    test6b(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 6c~n"),
    test6c(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 7~n"),
    test7(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 8~n"),
    test8(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 9~n"),
    test9(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 10~n"),
    test10(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 11~n"),
    test11(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 11b~n"),
    test11b(),
    clean_up(),

    %% time-switch tests

    io:format("test: process_cpl_script/7 - 12~n"),
    test12(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 13~n"),
    test13(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 14~n"),
    test14(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 14b~n"),
    test14b(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 15~n"),
    test15(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 16~n"),
    test16(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 17~n"),
    test17(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 18~n"),
    test18(),
    clean_up(),

    io:format("test: process_cpl_script/7 - 19~n"),
    test19(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 20~n"),
    test20(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 21~n"),
    test21(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 22~n"),
    test22(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 23~n"),
    test23(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 24~n"),
    test24(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 25~n"),
    test25(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 26~n"),
    test26(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 27~n"),
    test27(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 28~n"),
    test28(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 29~n"),
    test29(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 30~n"),
    test30(),
    clean_up(),

    io:format("test: process_cpl_script/7 - 31~n"),
    test31(),
    clean_up(),
    io:format("test: process_cpl_script/7 - 32~n"),
    test32(),
    clean_up(),

    ok.

%% test cases that have proxy tags use put(...) to give 
%% test_proxy_destinations(...) values to return - while all the test 
%% cases should consume their process dict elements this call ensures
%% that none remain when calling later test cases (those test may 
%% otherwise act strange).
clean_up() ->
    %% clean up process dict
    erase().

%% test a minimal script with <incoming>, <location> and <redirect>
test1() ->
    %% create cpl graph
    %% RFC 3880 - Figure 19
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
      <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
        xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
        xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
        <incoming>
          <location url=\"sip:smith@phone.example.com\">
            <redirect/>
          </location>
        </incoming>
      </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 

    %% create request
    RequestStr = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request = sippacket:parse(RequestStr, none),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% process cpl script
    Res =
	interpret_cpl:process_cpl_script(BranchBase, Request, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res = ~p~n",[Res]),
    PermanentR = no,
    LocationsR = lists:sort([sipurl:parse("sip:smith@phone.example.com")]),
    %% io:format("LocationsR = ~p~n",[LocationsR]),
    %% check result
    {redirect, Permanent, Locations} = Res,
    PermanentR = Permanent,
    LocationsR = lists:sort(Locations).
    
%% test <proxy> conditions <busy>, <noanswear> and success (i.e. proxy terminated)
test2() ->
    %% create cpl graph
    %% RFC 3880 - Figure 20
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <subaction id=\"voicemail\">
       <location url=\"sip:jones@voicemail.example.com\">
         <proxy/>
       </location>
     </subaction>
     <incoming>
       <location url=\"sip:jones@jonespc.example.com\">
         <proxy timeout=\"8\">
           <busy>
             <sub ref=\"voicemail\"/>
           </busy>
           <noanswer>
             <sub ref=\"voicemail\"/>
           </noanswer>
         </proxy>
       </location>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 

    %% create request
    RequestStr = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request = sippacket:parse(RequestStr, none),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("0. ~n",[]),
    %% process cpl script
    %% success at first proxy
    put(1, success),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request, User, Graph, Backend, STHandler, Direction),
    {proxy, _Response1}  = Res1,
    
    %% io:format("1. ~n",[]),
    %% success at second voicemail subaction proxy
    put(1, {test2_2a, busy}),
    put(2, {test2_2b, success}),
    Res2a = interpret_cpl:process_cpl_script(BranchBase, Request, User, Graph, Backend, STHandler, Direction),
    {proxy, _Response2a}  = Res2a,
    
    %% io:format("2. ~n",[]),
    %% noanswer at second voicemail subaction proxy
    put(1, {test2_3a, noanswer}),
    put(2, {test2_3b, noanswer}),
    Res3a = interpret_cpl:process_cpl_script(BranchBase, Request, User, Graph, Backend, STHandler, Direction),
    {proxy, _Response3a}  = Res3a,
        
    %% io:format("3. ~n",[]),
    %% failure in first proxy - do default action
    put(1, failure),
    Res4 = interpret_cpl:process_cpl_script(BranchBase, Request, User, Graph, Backend, STHandler, Direction),
    {proxy, _Response4}  = Res4,
    
    %% io:format("4. ~n",[]),
    %% redirection in first proxy - do default action
    put(1, {test2_5, redirection}),
    Res5 = interpret_cpl:process_cpl_script(BranchBase, Request, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res5 = ~p~n",[Res5]),
    {proxy, _Response5}  = Res5.
        
    
%% test <proxy> condition <default>
test3() ->
    %% create cpl graph
    %% RFC 3880 - Figure 21 - redirection proxy case removed, it's unreachable code
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
      xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
      xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
      <incoming>
        <location url=\"sip:jones@jonespc.example.com\">
          <proxy>
            <default>
              <location url=\"sip:jones@voicemail.example.com\">
                <proxy/>
              </location>
            </default>
          </proxy>
        </location>
      </incoming>
    </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 

    %% create request
    RequestStr = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request = sippacket:parse(RequestStr, none),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% success at both proxy nodes
    put(1, success),
    put(2, success),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request, User, Graph, Backend, STHandler, Direction),
    {proxy, _Response1}  = Res1,

    %% io:format("2. ~n",[]),
    %% process cpl script
    %% use default on first node
    put(1, failure), 
    put(2, success),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request, User, Graph, Backend, STHandler, Direction),
    {proxy, _Response2}  = Res2,
    
    %% io:format("3. ~n",[]),
    %% process cpl script
    %% use default on first node, success on second
    put(1, failure), 
    put(2, failure),
    Res3 = interpret_cpl:process_cpl_script(BranchBase, Request, User, Graph, Backend, STHandler, Direction),
    {proxy, _Response3}  = Res3,
    
    %% io:format("4. ~n",[]),
    %% process cpl script
    %% use success on first node, failure on second
    put(1, success), 
    Res4 = interpret_cpl:process_cpl_script(BranchBase, Request, User, Graph, Backend, STHandler, Direction),
    {proxy, _Response3}  = Res4.
    
%% test <reject> and <address-switch> with <address is=...> test
test4() ->
    %% create cpl graph
    %% RFC 3880 - Figure 22
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <address-switch field=\"origin\" subfield=\"user\">
         <address is=\"anonymous\">
           <reject status=\"reject\" reason=\"I reject anonymous calls\"/>
         </address>
       </address-switch>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 

    %% create request
    RequestStr1 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% origin user NOT = anonymous
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {server_default_action}  = Res1,

    %% create request
    RequestStr2 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Test Test\" <sip:anonymous@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request2 = sippacket:parse(RequestStr2, none),

    %% io:format("2. ~n",[]),
    %% process cpl script
    %% origin user = anonymous
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request2, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 603, "I reject anonymous calls"}  = Res2.
    
%% test <reject> and <address-switch> with <address subdomain-of=...>
%% a variation of test4 that tests "subdomain-of" checking in the address tag
test5() ->
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <address-switch field=\"destination\" subfield=\"host\">
         <address subdomain-of=\"org\">
           <reject status=\"reject\" reason=\"I reject calls to .org domains\"/>
         </address>
       </address-switch>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 

    %% create request
    RequestStr1 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% destination host = org
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 603, "I reject calls to .org domains"} = Res1,

    %% create request
    RequestStr2 = 
	"INVITE sip:test@example.com SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Test Test\" <sip:anonymous@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request2 = sippacket:parse(RequestStr2, none),
    %% io:format("Request2 = ~p~n",[Request2]),

    %% io:format("2. ~n",[]),
    %% process cpl script
    %% destination host NOT = org
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request2, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {server_default_action}  = Res2.
                   
%% test <reject> and <address-switch> with <address contains=...> 
%% a variation of test4 that tests "contains" checking in the address tag
test6() ->
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <address-switch field=\"destination\" subfield=\"display\">
         <address contains=\"org\">
           <reject status=\"reject\" reason=\"I reject calls containing .org in display name\"/>
         </address>
       </address-switch>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 

    %% create request
    RequestStr1 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% destination host = org
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {server_default_action} = Res1.


%% test <reject> and <address-switch> with <address contains=...> 
%% a variation of test4 that tests "contains" checking in the address tag
%% XXX should a check for missing "From" in request be included ??? 
%%     can origin | destination | original-destination be missing ??? are these requests discarded/rejected before
%%     they are sent to CPL ???
test6b() ->
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <address-switch field=\"origin\" subfield=\"display\">
         <address contains=\"Test\">
           <reject status=\"reject\" reason=\"I reject calls containing Test in display name\"/>
         </address>
       </address-switch>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
 
    %% create request
    RequestStr1 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% display-name in "From" matched
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 603, "I reject calls containing Test in display name"} = Res1,

    %% create request
    RequestStr2 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Foo Bar\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request2 = sippacket:parse(RequestStr2, none),
    %% io:format("Request2 = ~p~n",[Request2]),

    %% io:format("2. ~n",[]),
    %% process cpl script
    %% display-name in "From" didn't match
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request2, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {server_default_action} = Res2,
    
    %% create request
    RequestStr3 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request3 = sippacket:parse(RequestStr3, none),
    %% io:format("Request3 = ~p~n",[Request3]),

    %% io:format("3. ~n",[]),
    %% process cpl script
    %% display-name in "From" didn't exist
    Res3 = interpret_cpl:process_cpl_script(BranchBase, Request3, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res3 = ~p~n",[Res3]),
    {server_default_action} = Res3.


%% check not-present and otherwise address-switch conditions
test6c() ->
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <address-switch field=\"origin\" subfield=\"display\">
         <not-present>
            <reject status=\"busy\"/>
         </not-present>
         <otherwise>
            <reject status=\"reject\"/>
         </otherwise>
       </address-switch>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
 
    %% create request
    RequestStr1 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% no display-name in "From" found 
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 486} = Res1,

    %% create request
    RequestStr2 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Foo Bar\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request2 = sippacket:parse(RequestStr2, none),
    %% io:format("Request2 = ~p~n",[Request2]),

    %% io:format("2. ~n",[]),
    %% process cpl script
    %% display-name in "From" - but no "is" or "contains" condtion
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request2, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 603} = Res2.



%% test priority switch with <priority greater=...> and <otherwise>
%% based on test9 (without language-switch)
test7() ->  
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
      xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
      xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
      <incoming>
        <priority-switch>
          <priority greater=\"urgent\"/>
          <otherwise>
            <proxy/>
          </otherwise>
        </priority-switch>
      </incoming>
    </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 

    %% create request
    RequestStr1 = 
 	"INVITE sip:test@example.org SIP/2.0\r\n"
 	"Via: SIP/2.0/TCP two.example.org\r\n"
 	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
 	"To: <sip:to@example.org>   \n"
 	"via: SIP/2.0/UDP one.example.org\r\n"
 	"Priority: urgent\r\n"
 	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% process cpl script
    %% request matches otherwise clause
    put(1, success),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {proxy, _Response1}  = Res1,
    
    %% create request
    RequestStr2 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"Priority: emergency\r\n"
	"\r\nbody\r\n",
    Request2 = sippacket:parse(RequestStr2, none),
    %% io:format("Request2 = ~p~n",[Request2]),

    %% io:format("2. ~n",[]),
    %% process cpl script
    %% request matches <priority greater=...>
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request2, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {server_default_action} = Res2. 


%% test priority switch with <priority less=...> and <priority equal=...>
test8() ->  
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
      xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
      xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
      <incoming>
        <priority-switch>
          <priority equal=\"urgent\">
          </priority>
          <priority less=\"urgent\">
            <proxy/>
          </priority>
        </priority-switch>
      </incoming>
    </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 

    %% create request
    RequestStr1 = 
 	"INVITE sip:test@example.org SIP/2.0\r\n"
 	"Via: SIP/2.0/TCP two.example.org\r\n"
 	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
 	"To: <sip:to@example.org>   \n"
 	"via: SIP/2.0/UDP one.example.org\r\n"
 	"Priority: urgent\r\n"
 	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% process cpl script
    %% request matches <priority equal=...>
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {server_default_action} = Res1,
    
    %% create request
    RequestStr2 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"Priority: normal\r\n"
	"\r\nbody\r\n",
    Request2 = sippacket:parse(RequestStr2, none),
    %% io:format("Request2 = ~p~n",[Request2]),

    %% io:format("2. ~n",[]),
    %% process cpl script
    %% request matches <priority less=...>
    put(1, success),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request2, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {proxy, _Response1}  = Res2.
    
%% test <priority-switch> and <language-switch> with <language matches=...> and <otherwise> 
%% based on RFC 3880 - Figure 23, modified so that execution of the "not-present", "matches=es"
%% and "otherwise" cases can easily be distinguished
test9() ->
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
      xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
      xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
      <incoming>
        <priority-switch>
          <priority greater=\"urgent\"/>
          <otherwise>
            <language-switch>
              <language matches=\"es\">
                <location url=\"sip:spanish@operator.example.com\">
                  <proxy/>
                </location>
              </language>
              <not-present>
                <reject status=\"busy\"/>
              </not-present>
              <otherwise>
                <location url=\"sip:english@operator.example.com\"/>
              </otherwise>
            </language-switch>
          </otherwise>
        </priority-switch>
      </incoming>
    </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 

    %% create request
    RequestStr1 = 
 	"INVITE sip:test@example.org SIP/2.0\r\n"
 	"Via: SIP/2.0/TCP two.example.org\r\n"
 	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
 	"To: <sip:to@example.org>   \n"
 	"via: SIP/2.0/UDP one.example.org\r\n"
 	"Accept-Language: en-gb;q=0.8, es, en;q=0.7\r\n"
 	"Priority: urgent\r\n"
 	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% process cpl script (language matches)
    put(1, success),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {proxy, _Response1}  = Res1,
    
    %% create request
    RequestStr2 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"Accept-Language: en-gb;q=0.8, en;q=0.7\r\n"
	"Priority: urgent\r\n"
	"\r\nbody\r\n",
    Request2 = sippacket:parse(RequestStr2, none),
    %% io:format("Request2 = ~p~n",[Request2]),

    %% io:format("2. ~n",[]),
    %% process cpl script (language-switch -> otherwise)
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request2, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    Locations = [ #location{url = sipurl:parse("sip:english@operator.example.com")} ],
    {proxy_or_redirect_to_locations, Locations} = Res2,
    
    %% create request
    RequestStr3 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"Priority: urgent\r\n"
	"\r\nbody\r\n",
    Request3 = sippacket:parse(RequestStr3, none),
    %% io:format("Request3 = ~p~n",[Request3]),

    %% io:format("3. ~n",[]),
    %% process cpl script
    Res3 = interpret_cpl:process_cpl_script(BranchBase, Request3, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res3 = ~p~n",[Res3]),
    {reject, 486} = Res3.


%% test <outgoing>, <address-switch> and <reject>
%% slightly modified (as tel is currently unsupported) version of RFC 3880 - Figure 24 
test10() ->  
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <outgoing>
       <address-switch field=\"original-destination\" subfield=\"host\">
         <address subdomain-of=\"example2.org\">
           <reject status=\"reject\"
               reason=\"Not allowed to make example2.org calls.\"/>
         </address>
       </address-switch>
     </outgoing>
   </cpl>",

    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    %% io:format("Graph = ~p~n", [Graph]),

    %% create request
    RequestStr1 = 
 	"INVITE sip:test@example.org SIP/2.0\r\n"
 	"Via: SIP/2.0/TCP two.example.org\r\n"
 	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
 	"To: <sip:to@example2.org>   \n"
 	"via: SIP/2.0/UDP one.example.org\r\n"
 	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = outgoing,
    
    %% io:format("1. ~n",[]),
    %% process cpl script
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 603, "Not allowed to make example2.org calls."} = Res1.



%% test <lookup> 
test11() ->  
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
      xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
      xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
      <incoming>
         <lookup source=\"registration\">
            <success>
               <proxy/>
            </success>
            <notfound>
            </notfound>
            <failure>
               <reject status=\"error\"/>
            </failure>
         </lookup>
      </incoming>
    </cpl>",

    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    %% io:format("Graph = ~p~n", [Graph]),

    %% create request
    RequestStr1 = 
 	"INVITE sip:test@example.org SIP/2.0\r\n"
 	"Via: SIP/2.0/TCP two.example.org\r\n"
 	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
 	"To: <sip:to@example2.org>   \n"
 	"via: SIP/2.0/UDP one.example.org\r\n"
 	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% process cpl script
    %% do successful lookup and proxy
    put(1, {success, [sipurl:parse("sip:test@foo.org")]}),
    %% proxy return val
    put(2, success),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {proxy, _Respons} = Res1,

    %% io:format("2. ~n",[]),
    %% process cpl script
    %% lookup results in not found
    put(1, notfound),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 404} = Res2, % 404 = notfound

    %% io:format("3. ~n",[]),
    %% process cpl script
    %% lookup results in failure
    put(1, failure),
    Res3 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res3 = ~p~n",[Res3]),
    {reject, 500} = Res3.


%% test <lookup timeout=...>, timeout is currently ignored - so this only validates that no crashes occur
%% as timeout is passed to interpret_backend:lookup(...)
%% this is a timeout modified version of test11 
test11b() ->  
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
      xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
      xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
      <incoming>
         <lookup source=\"registration\" timeout=\"359\">
            <success>
               <proxy/>
            </success>
            <notfound>
            </notfound>
            <failure>
               <reject status=\"error\"/>
            </failure>
         </lookup>
      </incoming>
    </cpl>",

    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    %% io:format("Graph = ~p~n", [Graph]),

    %% create request
    RequestStr1 = 
 	"INVITE sip:test@example.org SIP/2.0\r\n"
 	"Via: SIP/2.0/TCP two.example.org\r\n"
 	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
 	"To: <sip:to@example2.org>   \n"
 	"via: SIP/2.0/UDP one.example.org\r\n"
 	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% process cpl script
    %% do successful lookup and proxy
    put(1, {success, [sipurl:parse("sip:test@foo.org")]}),
    %% proxy return val
    put(2, success),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {proxy, _Respons} = Res1,

    %% io:format("2. ~n",[]),
    %% process cpl script
    %% lookup results in not found
    put(1, notfound),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 404} = Res2, % 404 = notfound

    %% io:format("3. ~n",[]),
    %% process cpl script
    %% lookup results in failure
    put(1, failure),
    Res3 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res3 = ~p~n",[Res3]),
    {reject, 500} = Res3.

%% test handling of preprocessed count time ranges
test12() ->
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
      xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
      xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
      <incoming>
        <time-switch>
          <time dtstart=\"20050101T090000\" duration=\"PT8H\" freq=\"weekly\" count=\"3\">
            <reject status=\"error\"/>
          </time>
          <otherwise>
            <reject status=\"busy\"/>
          </otherwise>
        </time-switch>
      </incoming>
    </cpl>",
    
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    %% io:format("Graph = ~p~n", [Graph]),
    
    %% create request
    RequestStr1 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
  	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),
    
    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% process cpl script
    put(time, #date_time{date = {2005,1,15}, time = {15,34,35}, type = floating}),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 500} = Res1,
    
    %% io:format("2. ~n",[]),
    %% process cpl script - verify that 4:th count fails
    put(time, #date_time{date = {2005,1,22}, time = {15,34,35}, type = floating}),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 486} = Res2.



%% test <time-switch> and <lookup>   
%% RFC 3880 - Figure 25 - removed tzid and tzurl attribute 
%%                        as they are currently unsupported.
%% replaced <proxy> with <reject> to simplify result checking
 test13() ->  
     %% create cpl graph
     ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
     <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
       xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
       xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
       <incoming>
         <time-switch>
           <time dtstart=\"20000703T090000\" duration=\"PT8H\" freq=\"weekly\"
               byday=\"MO,TU,WE,TH,FR\">
             <lookup source=\"registration\">
               <success>
                 <reject status=\"error\"/>
               </success>
             </lookup>
           </time>
           <otherwise>
             <location url=\"sip:jones@voicemail.example.com\">
               <reject status=\"busy\"/>
             </location>
           </otherwise>
         </time-switch>
       </incoming>
     </cpl>",

     Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
     %% io:format("Graph = ~p~n", [Graph]),

     %% create request
     RequestStr1 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
  	"\r\nbody\r\n",
     Request1 = sippacket:parse(RequestStr1, none),
     %% io:format("Request1 = ~p~n",[Request1]),

     %% additional process_cpl_script values 
     BranchBase = "foobar",     
     User = "foobar@su.se", 
     Backend = test_backend, 
     STHandler = dummy_sthandler, 
     Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% 2005-11-15 = tuesday
    put(1, #date_time{date = {2005,11,15}, time = {15,34,35}, type = floating}),
    URI1 = sipurl:parse("sip:me@mobile.provider.net"),
    put(2, {success, [URI1]}),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 500} = Res1,
    
    %% io:format("2. ~n",[]),
    %% 2005-11-19 = saturday
    put(1, #date_time{date = {2005,11,19}, time = {15,34,35}, type = floating}),
    URI2 = sipurl:parse("sip:jones@voicemail.example.com"),
    put(2, {success, [URI2]}),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 486} = Res2.



 test14() ->  
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
     <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
       xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
       xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
       <incoming>
         <time-switch>
           <time dtstart=\"20000703T090000\" duration=\"PT8H\" freq=\"weekly\"
               byday=\"-1MO,TU,+2WE,TH,FR\">
              <reject status=\"error\"/>
           </time>
         </time-switch>
       </incoming>
     </cpl>",
    
     Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
     %% io:format("Graph = ~p~n", [Graph]),

     %% create request
     RequestStr1 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
  	"\r\nbody\r\n",
     Request1 = sippacket:parse(RequestStr1, none),
     %% io:format("Request1 = ~p~n",[Request1]),

     %% additional process_cpl_script values 
     BranchBase = "foobar",     
     User = "foobar@su.se", 
     Backend = test_backend, 
     STHandler = dummy_sthandler, 
     Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% 2005-11-28 = -1MO
    put(1, #date_time{date = {2005,11,28}, time = {15,34,35}, type = floating}),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 500} = Res1,
    
    %% io:format("2. ~n",[]),
    %% 2005-11-01 = TU
    put(1, #date_time{date = {2005,11,1}, time = {15,34,35}, type = floating}),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 500} = Res2,
    
    %% io:format("3. ~n",[]),
    %% 2005-11-09 = +2WE
    put(1, #date_time{date = {2005,11,9}, time = {15,34,35}, type = floating}),
    Res3 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res3 = ~p~n",[Res3]),
    {reject, 500} = Res3,
    
    %% io:format("4. ~n",[]),
    %% 2005-11-24 = TH
    put(1, #date_time{date = {2005,11,24}, time = {15,34,35}, type = floating}),
    Res4 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res4 = ~p~n",[Res4]),
    {reject, 500} = Res4,
    
    %% io:format("5. ~n",[]),
    %% 2005-11-18 = FR
    put(1, #date_time{date = {2005,11,18}, time = {15,34,35}, type = floating}),
    Res5 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res5 = ~p~n",[Res5]),
    {reject, 500} = Res5,
    
    %% io:format("6. ~n",[]),
    %% 2005-11-18 = FR, after [9:00:00, 16:59:59] range
    put(1, #date_time{date = {2005,11,18}, time = {17,0,0}, type = floating}),
    Res6 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res6 = ~p~n",[Res6]),
    {reject, 500} /= Res6,
    
    %% io:format("7. ~n",[]),
    %% 2005-11-19 = SA - invalid day
    put(1, #date_time{date = {2005,11,18}, time = {12,0,0}, type = floating}),
    Res7 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res7 = ~p~n",[Res7]),
    {reject, 500} /= Res7.

%% test <time-switch> 
%% test bysetpos
test14b() ->  
    %% create cpl graph (2000-07-03 = monday)
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
      <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
        xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
        xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
        <incoming>
          <time-switch>
            <time dtstart=\"20000703T090000\" duration=\"PT8H\" freq=\"monthly\"
                byday=\"-1MO,TU,+2WE\" bysetpos=\"1,-1,5\">
                <reject status=\"error\"/>
            </time>
          </time-switch>
        </incoming>
      </cpl>",
    
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    %% io:format("Graph = ~p~n", [Graph]),
    
    %% create request
     RequestStr1 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
  	"\r\nbody\r\n",
     Request1 = sippacket:parse(RequestStr1, none),
     %% io:format("Request1 = ~p~n",[Request1]),

     %% additional process_cpl_script values 
     BranchBase = "foobar",     
     User = "foobar@su.se", 
     Backend = test_backend, 
     STHandler = dummy_sthandler, 
     Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% 2005-09 -1mo = 26, tu = 6 | 13 | 20 | 27, 2we = 14
    %% bysetpos => 6 | 27

    put(1, #date_time{date = {2005,9,6}, time = {9,0,0}, type = floating}),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 500} = Res1,

    put(1, #date_time{date = {2005,9,27}, time = {16,59,59}, type = floating}),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 500} = Res2,

    %% day from bymonthday set, not selected by bysetpos
    put(1, #date_time{date = {2005,9,13}, time = {16,59,59}, type = floating}),
    Res3 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res3 = ~p~n",[Res3]),
    {reject, 500} /= Res3,

    %% day not in bymonthday set
    put(1, #date_time{date = {2005,9,13}, time = {16,59,59}, type = floating}),
    Res4 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res4 = ~p~n",[Res4]),
    {reject, 500} /= Res4.



 test15() ->  
     %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <cpl
     xmlns=\"urn:ietf:params:xml:ns:cpl\"
       xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
       xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
       <incoming>
         <time-switch>
           <time dtstart=\"20000703T090000\" dtend=\"20041130T090012z\">
              <reject status=\"error\"/>
           </time>
         </time-switch>
       </incoming>
     </cpl>",

    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    %% io:format("Graph = ~p~n", [Graph]),
    
    %% create request
    RequestStr1 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
  	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% range start
    put(1, #date_time{date = {2000,7,3}, time = {9,0,0}, type = floating}),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 500} = Res1,

    %% io:format("2. ~n",[]),
    %% range end
    put(1, #date_time{date = {2004,11,30}, time = {9,0,12}, type = utc}),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 500} = Res2,

    %% io:format("3. ~n",[]),
    %% date beyond range
    put(1, #date_time{date = {2005,11,18}, time = {12,0,0}, type = floating}),
    Res3 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res3 = ~p~n",[Res3]),
    {reject, 500} /= Res3.

    
%% test creation of time_switch__cond_5 record
 test16() ->  
     %% create cpl graph
     ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
     <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
       xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
       xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
       <incoming>
         <time-switch>
           <time dtstart=\"20050829T090000\" duration=\"PT8H\" freq=\"weekly\">
             <reject status=\"error\"/>
           </time>
         </time-switch>
       </incoming>
     </cpl>",

     Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
     %% io:format("Graph = ~p~n", [Graph]),

     %% create request
     RequestStr1 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
  	"\r\nbody\r\n",
     Request1 = sippacket:parse(RequestStr1, none),
     %% io:format("Request1 = ~p~n",[Request1]),

     %% additional process_cpl_script values 
     BranchBase = "foobar",     
     User = "foobar@su.se", 
     Backend = test_backend, 
     STHandler = dummy_sthandler, 
     Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% range and week start 
    put(1, #date_time{date = {2005,9,5}, time = {9,0,0}, type = floating}),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 500} = Res1,

    %% io:format("2. ~n",[]),
    %% range end 
    put(1, #date_time{date = {2005,9,5}, time = {16,59,59}, type = floating}),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 500} = Res2,

    %% io:format("3. ~n",[]),
    %% second before range start
    put(1, #date_time{date = {2005,9,5}, time = {8,59,59}, type = floating}),
    Res3 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res3 = ~p~n",[Res3]),
    {reject, 500} /= Res3.


%% test creation of time_switch__cond_5 record, count = 5
 test17() ->  
     %% create cpl graph
     ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
     <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
       xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
       xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
       <incoming>
         <time-switch>
           <time dtstart=\"20050703T090000\" duration=\"PT8H\" freq=\"weekly\" count=\"5\">
             <reject status=\"error\"/>
           </time>
         </time-switch>
       </incoming>
     </cpl>",

     Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
     %% io:format("Graph = ~p~n", [Graph]),

     %% create request
     RequestStr1 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
  	"\r\nbody\r\n",
     Request1 = sippacket:parse(RequestStr1, none),
     %% io:format("Request1 = ~p~n",[Request1]),

     %% additional process_cpl_script values 
     BranchBase = "foobar",     
     User = "foobar@su.se", 
     Backend = test_backend, 
     STHandler = dummy_sthandler, 
     Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% first second of first occurrence
    put(1, #date_time{date = {2005,7,3}, time = {9,0,0}, type = floating}),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 500} = Res1,

    %% io:format("2. ~n",[]),
    %% last second of last (5th) occurrence
    put(1, #date_time{date = {2005,7,31}, time = {16,59,59}, type = floating}),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 500} = Res2,

    %% io:format("2. ~n",[]),
    %% 6th occurrence - fail
    put(1, #date_time{date = {2005,8,7}, time = {16,59,59}, type = floating}),
    Res3 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res3 = ~p~n",[Res3]),
    {reject, 500} /= Res3.



%% test creation of time_switch__cond_5 record, until = COS DATE 
 test18() ->  
    %% create cpl graph
    %% dtstart = 2003-07-03 -> day = th
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
     <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
       xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
       xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
       <incoming>
         <time-switch>
           <time dtstart=\"20030703T090000\" duration=\"PT8H\" freq=\"weekly\" until=\"20050703\">
              <reject status=\"error\"/>
           </time>
         </time-switch>
       </incoming>
     </cpl>",

     Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    %% io:format("Graph = ~p~n", [Graph]),

     %% create request
     RequestStr1 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
  	"\r\nbody\r\n",
     Request1 = sippacket:parse(RequestStr1, none),
     %% io:format("Request1 = ~p~n",[Request1]),

     %% additional process_cpl_script values 
     BranchBase = "foobar",     
     User = "foobar@su.se", 
     Backend = test_backend, 
     STHandler = dummy_sthandler, 
     Direction = incoming,

    %% io:format("1. ~n",[]),
    %% first thursday after "until"
    put(1, #date_time{date = {2005,7,7}, time = {9,0,0}, type = floating}),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 500} /= Res1,

    %% io:format("1. ~n",[]),
    %% last thursday
    put(1, #date_time{date = {2005,6,30}, time = {9,0,0}, type = floating}),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 500} = Res2.




%% test <string-switch> (<string is=...>), <remove-location location=...>, <lookup> and <proxy>
%% based on RFC 3880 - Figure 26
%% Note: the following tests only test on <string-switch field="user-agent">
test19() ->  
     %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <string-switch field=\"user-agent\">
         <string is=\"Inadequate Software SIP User Agent/0.9beta2\">
           <lookup source=\"registration\">
             <success>
               <remove-location location=\"sip:me@mobile.provider.net\">
                 <proxy/>
               </remove-location>
             </success>
           </lookup>
         </string>
       </string-switch>
     </incoming>
   </cpl>",

    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    %% io:format("Graph = ~p~n", [Graph]),
    
    %% create request (user-agent has different case to test case handling)
    RequestStr1 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
	"user-agent: inadEquate soFtware SIP user aGent/0.9beta2\r\n"
  	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),
    
    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% process cpl script (nothing to remove with remove-location tag)
    put(1, {success, [sipurl:parse("sip:test@foo.org")]}),
    put(2, success),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {proxy, _Response} = Res1,
    
    %% io:format("2. ~n",[]),
    %% process cpl script (use remove-location tag to remove a single location so that locations become = [])
    put(1, {success, [sipurl:parse("sip:me@mobile.provider.net")]}),
    put(2, success),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res2]),
    {proxy, _Response} = Res2.


%% test <string-switch> (<string contains=...>), <remove-location location=...> 
%% (checking redirect return values), <lookup> and <redirect>
%% based on RFC 3880 - Figure 26
test20() ->  
     %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <string-switch field=\"user-agent\">
         <string contains=\"SIP User Agent/0.9\">
           <lookup source=\"registration\">
             <success>
               <remove-location location=\"sip:me@mobile.provider.net\">
                 <redirect/>
               </remove-location>
             </success>
             <notfound>
                <reject status=\"error\"/>
             </notfound>
           </lookup>
         </string>
       </string-switch>
     </incoming>
   </cpl>",

    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    %% io:format("Graph = ~p~n", [Graph]),
    
    %% create request (user-agent has different case to test case handling)
    RequestStr1 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
	"user-agent: inadEquate soFtware SIP user aGent/0.9beta2\r\n"
  	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),
    
    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% process cpl script (nothing to remove with remove-location tag)
    URI1 = sipurl:parse("sip:test@foo.org"),
    put(1, {success, [URI1]}),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {redirect, _Permanent, [URI1]} = Res1,
    
    %% io:format("2. ~n",[]),
    %% process cpl script (lookup resulted in notfound)
    put(1, notfound),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 500} = Res2,
    
    %% io:format("3. ~n",[]),
    %% process cpl script (remove-location tag URI3)
    URI3 = sipurl:parse("sip:me@mobile.provider.net"),
    put(1, {success, [URI3]}),
    Res3 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res3 = ~p~n",[Res3]),
    {redirect, _Permanent, []} = Res3.   


%% version of test20 that test that calls <remove-location> without location attribute (remove all locations) 
%% also test <string-switch> <string contains=...> match failure
test21() ->  
     %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <string-switch field=\"user-agent\">
         <string contains=\"SIP User Agent/0.9\">
           <lookup source=\"registration\">
             <success>
               <remove-location>
                 <redirect/>
               </remove-location>
             </success>
           </lookup>
         </string>
         <otherwise>
            <reject status=\"error\"/>
         </otherwise>
       </string-switch>
     </incoming>
   </cpl>",

    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    %% io:format("Graph = ~p~n", [Graph]),
    
    %% create request (user-agent has different case to test case handling)
    RequestStr1 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
	"user-agent: inadEquate soFtware SIP user aGent/0.9beta2\r\n"
  	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),
    
    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,
    
    %% io:format("1. ~n",[]),
    %% process cpl script (nothing to remove with remove-location tag)
    URI1 = sipurl:parse("sip:test@foo.org"),
    put(1, {success, [URI1]}),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {redirect, _Permanent, []} = Res1,
    
    %% create request (user-agent has different case to test case handling)
    RequestStr2 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
	"user-agent: inadEquate soFtware SIP user aGent/10.94.24.5\r\n"
  	"\r\nbody\r\n",
    Request2 = sippacket:parse(RequestStr2, none),
    %% io:format("Request2 = ~p~n",[Request2]),

    %% io:format("2. ~n",[]),
    %% process cpl script (nothing to remove with remove-location tag)
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request2, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 500} = Res2.


%% check not-present and otherwise string-switch conditions
test22() ->
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <string-switch field=\"user-agent\">
         <not-present>
            <reject status=\"busy\"/>
         </not-present>
         <otherwise>
            <reject status=\"reject\"/>
         </otherwise>
       </string-switch>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    
    %% create request
    RequestStr1 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% no user-agent supplied
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 486} = Res1,

    %% create request
    RequestStr2 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: \"Foo Bar\" <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"user-agent: foobar\r\n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request2 = sippacket:parse(RequestStr2, none),
    %% io:format("Request2 = ~p~n",[Request2]),

    %% io:format("2. ~n",[]),
    %% process cpl script
    %% user-agent supplied - but no "is" or "contains" condtion
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request2, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 603} = Res2.



%% test "location" attribute "clear"      
test23() ->
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <location url=\"sip:to1@example.org\" clear=\"no\">
          <location url=\"sip:to2@example.org\" clear=\"yes\">
             <redirect/>
          </location>
       </location>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    
    %% create request
    RequestStr1 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% no user-agent supplied
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    URI1 = sipurl:parse("sip:to2@example.org"),
    {redirect, _Permanent, [URI1]} = Res1.


%% test "lookup" attribute "clear"      
test24() ->
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <lookup source=\"registration\" clear=\"no\">
          <success>
             <lookup source=\"registration\" clear=\"yes\">
                <success>
                   <redirect/>
                </success>
             </lookup>
          </success>
       </lookup>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    
    %% create request
    RequestStr1 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% test that "clear" works by supplying two different lookup results 
    put(1, {success, [sipurl:parse("sip:test1@foo.org")]}),
    put(2, {success, [sipurl:parse("sip:test2@foo.org")]}),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    URI1 = sipurl:parse("sip:test2@foo.org"),
    {redirect, _Permanent, [URI1]} = Res1.



%% test "permanent" attribute in "redirect" tag
test25() ->
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <proxy>
          <noanswer>
            <redirect/>
          </noanswer>
          <busy>
            <redirect permanent=\"yes\"/>
          </busy>
          <default>
            <redirect permanent=\"no\"/>
          </default>
       </proxy>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    
    %% create request
    RequestStr1 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% test ...
    put(1, noanswer),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {redirect, no, []} = Res1,

    %% io:format("2. ~n",[]),
    %% process cpl script
    %% test ...
    put(1, busy),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {redirect, yes, []} = Res2,

    %% io:format("3. ~n",[]),
    %% process cpl script
    %% test ...
    put(1, failure),
    Res3 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res3 = ~p~n",[Res3]),
    {redirect, no, []} = Res3.
    
    

%% test "proxy" tag - trigger all possible failure types, and test that numerical 
%% "reason" attributes can be supplied to "reject" tags
test26() ->
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <proxy recurse=\"no\">
          <busy>
            <reject status=\"401\"/>
          </busy>
          <noanswer>
            <reject status=\"402\"/>
          </noanswer>
          <redirection>
            <reject status=\"501\"/>
          </redirection>
          <failure>
            <reject status=\"602\"/>
          </failure>
       </proxy>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 

    %% create request
    RequestStr1 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% test busy proxy result
    put(1, busy),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 401} = Res1,

    %% io:format("2. ~n",[]),
    %% process cpl script
    %% test noanswer proxy result
    put(1, noanswer),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 402} = Res2,

    %% io:format("3. ~n",[]),
    %% process cpl script
    %% test redirection proxy result
    put(1, redirection),
    Res3 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res3 = ~p~n",[Res3]),
    {reject, 501} = Res3,
    
    %% io:format("4. ~n",[]),
    %% process cpl script
    %% test failure proxy result
    put(1, failure),
    Res4 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res4 = ~p~n",[Res4]),
    {reject, 602} = Res4.
    

%% tests internal interpret_cpl.erl function
test27() ->
    interpret_cpl:test27().


%% test "proxy" tag - ordering="first-only"
test28() ->
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <location url=\"sip:test1@foo.bar\" priority=\"0.8\">
         <location url=\"sip:test2@foo.bar\" priority=\"1.0\">
           <location url=\"sip:test3@foo.bar\" priority=\"0.0\">
             <proxy recurse=\"no\" timeout=\"30\" ordering=\"first-only\">
               <busy>
                 <redirect/> 
               </busy>
             </proxy>
           </location>
         </location>
       </location>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 

    %% create request
    RequestStr1 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% test that ordering="first-only" only removes the highest priority location
    URI1 = sipurl:parse("sip:test1@foo.bar"),
    URI3 = sipurl:parse("sip:test3@foo.bar"),
    put(1, busy),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {redirect, _Permanent, Locs} = Res1,
    %% sort to ensure that matching works (there is no specific order required in Locs)
    LSa = lists:sort([URI1,URI3]),
    LSb = lists:sort(Locs),
    LSa = LSb.


%% test "proxy" tag - ordering="sequential"
test29() ->
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <location url=\"sip:test1@foo.bar\" priority=\"0.8\">
         <location url=\"sip:test2@foo.bar\" priority=\"1.0\">
           <location url=\"sip:test3@foo.bar\" priority=\"0.0\">
             <proxy recurse=\"no\" timeout=\"30\" ordering=\"sequential\">
               <busy>
                 <redirect/> 
               </busy>
             </proxy>
           </location>
         </location>
       </location>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 

    %% create request
    RequestStr1 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% test that proxy removed all locations
    put(1, busy),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {redirect, _Permanent, []} = Res1.


%% test "proxy" tag - ordering="parallel"
test30() ->
    %% create cpl graph
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
   <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
     <incoming>
       <location url=\"sip:test1@foo.bar\" priority=\"0.8\">
         <location url=\"sip:test2@foo.bar\" priority=\"1.0\">
           <location url=\"sip:test3@foo.bar\" priority=\"0.0\">
             <proxy recurse=\"no\" timeout=\"30\" ordering=\"parallel\">
               <busy>
                 <redirect/> 
               </busy>
             </proxy>
           </location>
         </location>
       </location>
     </incoming>
   </cpl>",
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 

    %% create request
    RequestStr1 = 
	"INVITE sip:test@example.org SIP/2.0\r\n"
	"Via: SIP/2.0/TCP two.example.org\r\n"
	"From: <sip:test@example.org>;tag=abc\r\n"
	"To: <sip:to@example.org>   \n"
	"via: SIP/2.0/UDP one.example.org\r\n"
	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),

    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,

    %% io:format("1. ~n",[]),
    %% process cpl script
    %% test that proxy removed all locations
    put(1, busy),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {redirect, _Permanent, []} = Res1.



%% test handling of preprocessed count time ranges, for time_switch__cond_7
test31() ->
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
      xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
      xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
      <incoming>
        <time-switch>
          <time dtstart=\"20050101T090000\" duration=\"PT8H\" freq=\"daily\" count=\"3\" byday=\"SA,SU\">
            <reject status=\"error\"/>
          </time>
          <otherwise>
            <reject status=\"busy\"/>
          </otherwise>
        </time-switch>
      </incoming>
    </cpl>",
    
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    %% io:format("Graph = ~p~n", [Graph]),
    
    %% create request
    RequestStr1 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
  	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),
    
    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,
    
    %% valid dates are 2005-01-01, 2005-01-02, 2005-01-08

    %% io:format("1. ~n",[]),
    %% process cpl script (last second in last count)
    put(time, #date_time{date = {2005,1,8}, time = {16,59,59}, type = floating}),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 500} = Res1,
    
    %% io:format("2. ~n",[]),
    %% process cpl script - verify that 4:th count (2005-01-09) fails
    put(time, #date_time{date = {2005,1,9}, time = {16,59,59}, type = floating}),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 486} = Res2.


%% test handling of preprocessed count time ranges, for time_switch__cond_8   
test32() ->
    ScriptStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <cpl xmlns=\"urn:ietf:params:xml:ns:cpl\"
      xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
      xsi:schemaLocation=\"urn:ietf:params:xml:ns:cpl cpl.xsd \">
      <incoming>
        <time-switch>
          <time dtstart=\"20050101T090000\" duration=\"PT8H\" freq=\"monthly\" count=\"3\" byday=\"SA,SU\"
           bysetpos=\"1\">
            <reject status=\"error\"/>
          </time>
          <otherwise>
            <reject status=\"busy\"/>
          </otherwise>
        </time-switch>
      </incoming>
    </cpl>",
    
    Graph = xml_parse:cpl_script_to_graph(ScriptStr), 
    %% io:format("Graph = ~p~n", [Graph]),
    
    %% create request
    RequestStr1 = 
  	"INVITE sip:test@example.org SIP/2.0\r\n"
  	"Via: SIP/2.0/TCP two.example.org\r\n"
  	"From: \"Test Test\" <sip:test@example.org>;tag=abc\r\n"
  	"To: <sip:to@example2.org>   \n"
  	"via: SIP/2.0/UDP one.example.org\r\n"
  	"\r\nbody\r\n",
    Request1 = sippacket:parse(RequestStr1, none),
    %% io:format("Request1 = ~p~n",[Request1]),
    
    %% additional process_cpl_script values 
    BranchBase = "foobar",     
    User = "foobar@su.se", 
    Backend = test_backend, 
    STHandler = dummy_sthandler, 
    Direction = incoming,
    
    %% valid dates are 2005-01-01, 2005-02-05, 2005-03-05 (first weekend day of each month)

    %% io:format("1. ~n",[]),
    %% process cpl script (last second in last count)
    put(time, #date_time{date = {2005,3,5}, time = {16,59,59}, type = floating}),
    Res1 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res1 = ~p~n",[Res1]),
    {reject, 500} = Res1,
    
    %% io:format("2. ~n",[]),
    %% process cpl script - verify that 4:th count (2005-04-02) fails
    put(time, #date_time{date = {2005,4,2}, time = {16,59,59}, type = floating}),
    Res2 = interpret_cpl:process_cpl_script(BranchBase, Request1, User, Graph, Backend, STHandler, Direction),
    %% io:format("Res2 = ~p~n",[Res2]),
    {reject, 486} = Res2.