%%%-------------------------------------------------------------------
%%% @copyright (C) 2011-2016, 2600Hz INC
%%% @doc
%%% Receive route(dialplan) requests from FS, request routes and respond
%%% @end
%%% @contributors
%%%   James Aimonetti
%%%-------------------------------------------------------------------
-module(ecallmgr_fs_router_call).

-behaviour(gen_server).

-export([start_link/1, start_link/2]).

-export([init/1
        ,handle_call/3
        ,handle_cast/2
        ,handle_info/2
        ,terminate/2
        ,code_change/3
        ]).

-include_lib("kazoo_sip/include/kzsip_uri.hrl").
-include("ecallmgr.hrl").

-define(SERVER, ?MODULE).
-define(FETCH_SECTION, 'dialplan').
-define(BINDINGS_CFG_KEY, <<"call_routing_bindings">>).
-define(DEFAULT_BINDINGS, [?DEFAULT_FREESWITCH_CONTEXT]).

-record(state, {node = 'undefined' :: atom()
               ,options = [] :: kz_proplist()
               }).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc Starts the server
%%--------------------------------------------------------------------
-spec start_link(atom()) -> startlink_ret().
-spec start_link(atom(), kz_proplist()) -> startlink_ret().
start_link(Node) -> start_link(Node, []).
start_link(Node, Options) ->
    gen_server:start_link(?SERVER, [Node, Options], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([Node, Options]) ->
    kz_util:put_callid(Node),
    lager:info("starting new fs route listener for ~s", [Node]),
    gen_server:cast(self(), 'bind_to_dialplan'),
    {'ok', #state{node=Node, options=Options}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    {'reply', {'error', 'not_implemented'}, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast('bind_to_dialplan', #state{node=Node}=State) ->
    Bindings = ecallmgr_config:get(?BINDINGS_CFG_KEY, ?DEFAULT_BINDINGS, Node),
    case ecallmgr_fs_router_util:register_bindings(Node, ?FETCH_SECTION, Bindings) of
        'true' -> {'noreply', State};
        'false' ->
            lager:critical("unable to establish route bindings : ~p", [Bindings]),
            {'stop', 'no_binding', State}
    end;
handle_cast(_Msg, State) ->
    lager:debug("unhandled cast: ~p", [_Msg]),
    {'noreply', State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info({'route', Section, _EventName, _SubClass, _Context, Id, 'undefined', _FSData}, #state{node=Node}=State) ->
    lager:warning("fetch unknown callid from ~s: Ev: ~p Sc: ~p, Ctx: ~p Id: ~s"
                 ,[Node, _EventName, _SubClass, _Context, Id]),
    {'ok', Resp} = ecallmgr_fs_xml:empty_response(),
    _ = freeswitch:fetch_reply(Node, Id, Section, Resp),
    {'noreply', State};
handle_info({'route', Section, <<"REQUEST_PARAMS">>, _SubClass, _Context, FSId, CallId, FSData}, #state{node=Node}=State) ->
    _ = kz_util:spawn(fun process_route_req/5, [Section, Node, FSId, CallId, FSData]),
    {'noreply', State, 'hibernate'};
handle_info(_Other, State) ->
    lager:debug("unhandled msg: ~p", [_Other]),
    {'noreply', State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
                                                % terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, #state{node=Node}) ->
    lager:info("route listener for ~s terminating: ~p", [Node, _Reason]).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {'ok', State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

-spec process_route_req(atom(), atom(), ne_binary(), ne_binary(), kz_proplist()) -> 'ok'.
process_route_req(Section, Node, FetchId, CallId, Props) ->
    kz_util:put_callid(CallId),
    case kz_util:is_true(props:get_value(<<"variable_recovered">>, Props)) of
        'false' -> do_process_route_req(Section, Node, FetchId, CallId, Props);
        'true' ->
            lager:debug("recovered channel already exists on ~s, park it", [Node]),
            JObj = kz_json:from_list([{<<"Routes">>, []}
                                     ,{<<"Method">>, <<"park">>}
                                     ]),
            ecallmgr_fs_router_util:reply_affirmative(Section, Node, FetchId, CallId, JObj, Props)
    end.

-spec do_process_route_req(atom(), atom(), ne_binary(), ne_binary(), kz_proplist()) -> 'ok'.
do_process_route_req(Section, Node, FetchId, CallId, Props) ->
    Filtered = ecallmgr_fs_loopback:filter(Node, CallId, Props),
    case ecallmgr_fs_router_util:search_for_route(Section, Node, FetchId, CallId, Filtered) of
	'ok' ->
            lager:debug("xml fetch dialplan ~s finished without success", [FetchId]);
	{'ok', JObj} ->
            ecallmgr_fs_channels:update(CallId, #channel.handling_locally, 'true'),
            maybe_start_call_handling(Node, FetchId, CallId, JObj)
    end.

-spec maybe_start_call_handling(atom(), ne_binary(), ne_binary(), kz_json:object()) -> 'ok'.
maybe_start_call_handling(Node, FetchId, CallId, JObj) ->
    case kz_json:get_value(<<"Method">>, JObj) of
        <<"error">> -> lager:debug("sent error response to ~s, not starting call handling", [Node]);
        _Else -> start_call_handling(Node, FetchId, CallId, JObj)
    end.

-spec start_call_handling(atom(), ne_binary(), ne_binary(), kz_json:object()) -> 'ok'.
start_call_handling(Node, FetchId, CallId, JObj) ->
    ServerQ = kz_json:get_value(<<"Server-ID">>, JObj),
    CCVs =
        kz_json:set_values(
          [{<<"Application-Name">>, kz_json:get_value(<<"App-Name">>, JObj)}
          ,{<<"Application-Node">>, kz_json:get_value(<<"Node">>, JObj)}
          ]
                          ,kz_json:get_value(<<"Custom-Channel-Vars">>, JObj, kz_json:new())
         ),
    _Evt = ecallmgr_call_sup:start_event_process(Node, CallId),
    _Ctl = ecallmgr_call_sup:start_control_process(Node, CallId, FetchId, ServerQ, CCVs),

    lager:debug("started event ~p and control ~p processes", [_Evt, _Ctl]),

    _ = ecallmgr_fs_command:set(Node, CallId, kz_json:to_proplist(CCVs)),
    lager:debug("xml fetch dialplan ~s finished with success", [FetchId]).
