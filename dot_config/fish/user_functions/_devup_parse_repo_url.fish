function _devup_parse_repo_url --description "Parse repo URL into owner and repo name"
    # Usage: _devup_parse_repo_url <url>
    # Sets: _parsed_owner, _parsed_repo, _parsed_clone_url

    set -l input $argv[1]

    # git@github.com:owner/repo.git
    if string match -qr '^git@([^:]+):(.+)/(.+?)(?:\.git)?$' -- $input
        set -g _parsed_owner (string match -r '^git@([^:]+):(.+)/(.+?)(?:\.git)?$' -- $input)[3]
        set -g _parsed_repo (string match -r '^git@([^:]+):(.+)/(.+?)(?:\.git)?$' -- $input)[4]
        set -g _parsed_clone_url $input
        return 0
    end

    # https://github.com/owner/repo[.git]
    if string match -qr '^https?://[^/]+/(.+)/(.+?)(?:\.git)?$' -- $input
        set -g _parsed_owner (string match -r '^https?://[^/]+/(.+)/(.+?)(?:\.git)?$' -- $input)[2]
        set -g _parsed_repo (string match -r '^https?://[^/]+/(.+)/(.+?)(?:\.git)?$' -- $input)[3]
        set -g _parsed_clone_url $input
        return 0
    end

    # owner/repo shorthand
    if string match -qr '^([^/]+)/([^/]+)$' -- $input
        set -g _parsed_owner (string match -r '^([^/]+)/([^/]+)$' -- $input)[2]
        set -g _parsed_repo (string match -r '^([^/]+)/([^/]+)$' -- $input)[3]
        set -g _parsed_clone_url "https://github.com/$input.git"
        return 0
    end

    echo "Invalid repo URL: $input"
    return 1
end
