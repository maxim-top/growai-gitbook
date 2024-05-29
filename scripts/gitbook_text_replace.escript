#!/usr/bin/env escript
%% -*- mode: erlang;erlang-indent-level: 4;indent-tabs-mode: nil -*-
%% ex: ft=erlang ts=4 sw=4 et
main(_Args) ->
    Files = filelib:wildcard("_book/**/*.html"),
    Rules = [{<<"&#x672C;&#x4E66;&#x4F7F;&#x7528; GitBook &#x53D1;&#x5E03;">>, unicode:characters_to_binary("本文档由 蓝莺GrowAI 发布")},
            {<<"https://www.gitbook.com">>, <<"https://www.lanyingim.com">>},
            {<<"all right reserved&#xFF0C;powered by Gitbook">>, <<>>},
            {regex, "^_book/", <<"(<img src=[^>]*)@([0-9]+)p">>, <<"\\1\" style=\"width:\\2%">>},
            {regex, "^_book/", <<"\"gitbook\":{\"version\":\"3.2.3\",\"time\":\"[^\"}]*\"}">>, <<"\"gitbook\":{\"version\":\"3.2.3\",\"time\":\"0000-00-00T00:00:00.000Z\"}">>}],
    lists:foreach(
        fun(File) ->
            {ok, Bin} = file:read_file(File),
            NewBin = lists:foldl(
                fun({OriginText, ReplaceText}, Acc) ->
                    binary:replace(Acc, OriginText, ReplaceText);
                ({Filter, OriginText, ReplaceText}, Acc) ->
                    case re:run(File, Filter) of
                        nomatch ->
                            Acc;
                        {match, _} ->
                            binary:replace(Acc, OriginText, ReplaceText)
                    end;
                ({regex, Filter, OriginText, ReplaceText}, Acc) ->
                    case re:run(File, Filter) of
                        nomatch ->
                            Acc;
                        {match, _} ->
                            iolist_to_binary(re:replace(Acc, OriginText, ReplaceText, [global]))
                    end
                end, Bin, Rules),
            case Bin /= NewBin of
                true ->
                    file:write_file(File, NewBin);
                false ->
                    skip
            end
        end, Files),
    ok.

