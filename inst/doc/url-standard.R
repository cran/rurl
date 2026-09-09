## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(rurl)

## ----unreserved---------------------------------------------------------------
get_path("http://example.com/%41%42", url_standard = "rfc3986")
get_path("http://example.com/%41%42", url_standard = "whatwg")

## ----reserved-----------------------------------------------------------------
get_path("http://example.com/a%2Fb", url_standard = "rfc3986")
get_path("http://example.com/a%2fb", url_standard = "whatwg")

## ----ipv4---------------------------------------------------------------------
get_host("http://2130706433/", url_standard = "whatwg")
get_host_type("http://2130706433/", url_standard = "whatwg")
get_url_diagnostics("http://2130706433/", url_standard = "rfc3986")

## ----helpers------------------------------------------------------------------
get_host_type("http://example.com/", url_standard = "whatwg")
get_scheme_class(c("http://a/", "ftps://a/"), url_standard = "whatwg")
get_url_diagnostics("http://0x7f.1/", url_standard = "whatwg")

## ----ports--------------------------------------------------------------------
get_clean_url("http://example.com:80/p", port_handling = "keep")
get_clean_url("http://example.com:80/p", port_handling = "keep",
              url_standard = "whatwg")
get_clean_url("http://example.com:8080/p", port_handling = "keep",
              url_standard = "whatwg")

## ----backslash----------------------------------------------------------------
get_clean_url("http://example.com/a\\b", url_standard = "whatwg")
get_clean_url("http://example.com/a\\b", url_standard = "rfc3986")

## ----resolve------------------------------------------------------------------
resolve_url("../g", "http://a/b/c/d;p?q")
resolve_url("//other.example/p", "http://a/b/c")
resolve_url(c("g", "../h"), "http://a/b/c/")

## ----resolve-whatwg-----------------------------------------------------------
# 1. A reference carrying the base's OWN special scheme is relative, not
#    absolute -- so this is not read as the absolute `http:g`.
resolve_url("http:g", "http://a/b/c/d", url_standard = "whatwg")

# 2. Under a special base, `\` reads as `/`.
resolve_url("..\\g", "http://a/b/c/d", url_standard = "whatwg")

# 3. A leading run of slashes-or-backslashes introduces an authority.
resolve_url("///g", "http://a/b/c/d", url_standard = "whatwg")

# 4. Leading and trailing C0-or-space is stripped before the reference is read.
resolve_url("  \n g ", "http://a/b/c/d", url_standard = "whatwg")

## ----resolve-scheme-----------------------------------------------------------
# `10.0.0.7` cannot be a scheme, so this is a relative path.
resolve_url("10.0.0.7:8080/foo.html", "file:///some/dir/bar.html",
            url_standard = "rfc3986")

# The same tightening cuts the other way for a BASE: a base whose scheme
# existed only under the loose group is not an absolute URL, so there is
# nothing to resolve against.
resolve_url("g", "10.0.0.7:8080/dir/x", url_standard = "rfc3986")

## ----resolve-null-frozen------------------------------------------------------
resolve_url("g", "10.0.0.7:8080/dir/x")

## ----resolve-serialized-------------------------------------------------------
resolve_url("../g", "http://u:pw@a/b/c/d?q#f", url_standard = "whatwg")
resolve_url("../g", "http://u:pw@a/b/c/d?q#f", url_standard = "whatwg",
            output = "serialized")

## ----acceptance---------------------------------------------------------------
# Rejected by the default "web" allowlist ...
get_host("mailto:jane@example.com", url_standard = "whatwg")

# ... parsed under "general".
get_host("mailto:jane@example.com", url_standard = "whatwg",
         scheme_acceptance = "general")

## ----opaque-------------------------------------------------------------------
safe_parse_urls("mailto:jane@example.com", url_standard = "whatwg",
                scheme_acceptance = "general")[, c("host", "user", "path")]

