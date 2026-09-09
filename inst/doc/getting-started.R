## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(rurl)

## -----------------------------------------------------------------------------
safe_parse_url("https://sub.example.co.uk/path?q=1")

## -----------------------------------------------------------------------------
get_scheme("https://sub.example.com")
get_host("https://sub.example.com")
get_path("https://sub.example.com/path/to/page")

## -----------------------------------------------------------------------------
get_domain("https://a.b.example.co.uk")

## -----------------------------------------------------------------------------
get_tld("https://foo.blogspot.com")

## -----------------------------------------------------------------------------
urls <- c("example.com", "http://example.com", NA)
get_clean_url(urls)

## -----------------------------------------------------------------------------
get_host(
  "www.three.two.one.example.com",
  subdomain_levels_to_keep = 0
) # www_handling default is "none"
# Expected: "www.example.com"

get_host(
  "three.two.one.example.com",
  www_handling = "strip",
  subdomain_levels_to_keep = 0
)
# Expected: "example.com"

get_host("www.three.two.one.example.com", subdomain_levels_to_keep = 1)
# Expected: "www.one.example.com"

get_host(
  "three.two.one.example.com",
  www_handling = "strip",
  subdomain_levels_to_keep = 1
)
# Expected: "one.example.com"

get_host(
  "www.three.two.one.example.com",
  www_handling = "keep",
  subdomain_levels_to_keep = 2
)
# Expected: "www.two.one.example.com"

## -----------------------------------------------------------------------------
get_clean_url(
  "http://www.deep.sub.example.com/some/path",
  subdomain_levels_to_keep = 0,
  www_handling = "keep"
)
# yields http://www.example.com/some/path

get_clean_url(
  "http://deep.sub.example.com/some/path",
  subdomain_levels_to_keep = 1
)
# yields http://sub.example.com/some/path

## ----output-surfaces----------------------------------------------------------
u <- "https://user:pw@Example.COM:443/a/../b?q=1#frag"

# (c) cleaning -- an SEO/canonicalization product, intentionally lossy
get_clean_url(u)

# (b) standard serialization -- the full string, exactly as WHATWG would
#     write it. No presentation dial reaches it.
serialize_url(u)

# (d) safe display -- for showing a person
format_url(u)

## ----output-display-----------------------------------------------------------
format_url("https://example.com/a%2Fb?x=a%26b%3Dc#%E2%80%AEevil")

