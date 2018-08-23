Geocoder.configure(
    # Geocoding options
    timeout: 3,                 # geocoding service timeout (secs)
    lookup: :pickpoint,            # name of geocoding service (symbol)
    ip_lookup: :ipstack,      # name of IP address geocoding service (symbol)
    # language: :en,              # ISO-639 language code
    #use_https: true,           # use HTTPS for lookup requests? (if supported)
    # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
    # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
    pickpoint: {
        api_key: Rails.application.secrets.pickpoint_api_key,
        use_https: true
    },
    ipstack: {
        api_key: Rails.application.secrets.ip_stack_api_key,
        use_https: false
    },               # API key for geocoding service

    cache: Redis.new,                 # cache object (must respond to #[], #[]=, and #del)
    cache_prefix: 'geocoder:',  # prefix (string) to use for all cache keys

    # Exceptions that should not be rescued by default
    # (if you want to implement custom error handling);
    # supports SocketError and Timeout::Error
    # always_raise: [],

    # Calculation options
    # units: :mi,                 # :km for kilometers or :mi for miles
    # distances: :linear          # :spherical or :linear
    )
