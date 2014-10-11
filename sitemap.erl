-module(sitemap).
-author("Roman Gladkov <roman.glv@gmx.com>").
-compile(export_all).
-define(BASE_URL, fun() -> Config = struktur:load_config(),
                           struktur:get_host(Config, http) end).

gendate() ->
    {Year, Month, Day} = erlang:date(),
    io_lib:format("~w-~w-~wT00:00:00-07:00", [Year, Month, Day]).

body() ->
    Date = gendate(),
    Base = ?BASE_URL(),
    Pages = default() ++ ck_web_sup:pages(),

    (
      "<?xml version='1.0' encoding='UTF-8'?>" ++
      "<urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd'>" ++
      [format(Base, Page, Date) || Page <- Pages] ++
      "</urlset>"
    ).

default() ->
    [
     {"/signin", "", ""},
     {"/signup", "", ""},
     {"/subscribe", "", ""}
    ].

format(Base, {Url, _, _}, Date) ->
    io_lib:format("<url><loc>https://~s~s</loc><lastmod>~s</lastmod></url>~n",
                  [Base, Url, Date]).

init(_Transport, Req, [])        -> {ok, Req, undefined}.
terminate(_Reason, _Req, _State) -> ok.
handle(Req, State)               -> main(Req, State).

main(Req, State) ->
    Req1 = wf:response(body(), Req),
    {ok, Req2} = wf:reply(200, Req1),
    {ok, Req2, State}.
