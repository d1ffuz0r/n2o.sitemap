n2o.sitemap
===========


Integration
-----------

Add to cowboy handlers map

```erlang
cowboy_router:compile([
  {"localhost", [
    {"/sitemap.xml",          sitemap,     []}
  ]}
]).
```
