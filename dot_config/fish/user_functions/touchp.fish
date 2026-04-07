function touchp --description "指定されたパスにファイルを作成し、必要なディレクトリも作成します"
    if test -z "$argv[1]"
        echo "使用法: touchp <ファイルパス>" >&2
        return 1
    end

    set -l target_path "$argv[1]"
    if not mkdir -p (dirname "$target_path")
        echo "ディレクトリの作成に失敗しました: $target_path" >&2
        return 1
    end

    if not touch "$target_path"
        echo "ファイルの作成に失敗しました: $target_path" >&2
        return 1
    end
end
