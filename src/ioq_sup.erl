% Licensed under the Apache License, Version 2.0 (the "License"); you may not
% use this file except in compliance with the License. You may obtain a copy of
% the License at
%
%   http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
% WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
% License for the specific language governing permissions and limitations under
% the License.

-module(ioq_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).
-export([get_ioq2_servers/0]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    ok = ioq_config_listener:subscribe(),
    {ok, {
        {one_for_one, 5, 10},
        [
            ?CHILD(ioq_opener, worker),
            ?CHILD(ioq_server, worker),
            ?CHILD(ioq_server2, worker),
            ?CHILD(ioq_osq, worker)
        ]
    }}.


get_ioq2_servers() ->
    [ioq_server2 | ioq_opener:get_ioq_pids()].
