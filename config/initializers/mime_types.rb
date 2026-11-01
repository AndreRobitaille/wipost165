# Rack's static file handler does not recognize this extension by default.
require "rack/mime"
Rack::Mime::MIME_TYPES[".webmanifest"] = "application/manifest+json"
