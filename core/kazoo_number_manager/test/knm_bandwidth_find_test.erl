%%%-------------------------------------------------------------------
%%% @copyright (C) 2016, 2600Hz
%%% @doc
%%% @end
%%% @contributors
%%%   James Aimonetti
%%%-------------------------------------------------------------------
-module(knm_bandwidth_find_test).

-include_lib("eunit/include/eunit.hrl").
-include("knm.hrl").

find_test_() ->
    [npan_tests()
    ,area_code_tests()
    ].

npan_tests() ->
    Options = [{?KNM_ACCOUNTID_CARRIER, ?RESELLER_ACCOUNT_ID}
              ,{<<"carriers">>, [<<"knm_bandwidth">>]}
              ],
    Limit = 1,
    Results = knm_carriers:find(<<"+14158867900">>, Limit, Options),

    [{"Verify area code result size"
     ,?_assertEqual(Limit, length(Results))
     }
    ].

area_code_tests() ->
    Options = [{?KNM_ACCOUNTID_CARRIER, ?RESELLER_ACCOUNT_ID}
              ,{<<"carriers">>, [<<"knm_bandwidth">>]}
              ],
    Limit = 15,
    Results = knm_carriers:find(<<"412">>, Limit, Options),

    [{"Verify area code result size"
     ,?_assertEqual(Limit, length(Results))
     }
    ].
