-ifndef(KAPPS_CALL_COMMAND_HRL).

-include_lib("kazoo/include/kz_types.hrl").
-include_lib("kazoo/include/kz_log.hrl").
-include_lib("kazoo_caches/include/kazoo_caches.hrl").
-include("kapps_call_command_types.hrl").

-define(DEFAULT_TIMEOUT_S, 20).

-define(APP_NAME, <<"kapps_call_command">>).
-define(APP_VERSION, <<"4.0.0">>).

-define(MOD_CONFIG_CAT, <<"speech">>).

-define(KAPPS_CALL_COMMAND_HRL, 'true').
-endif.
