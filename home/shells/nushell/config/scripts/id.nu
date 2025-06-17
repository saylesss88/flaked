export def s [sel? cmd? pth?] {
    let el = ls -a | enumerate | flatten
    def elp [] { ls -a | enumerate | flatten | print }
    def n2name [n] { $el | get $n | get name }
    def range_cmd [sel cmd] {
        for n in $sel { do_once $n $cmd }
    }
    def do_once [sel cmd] {
        let sel = n2name $sel
        match $cmd {
            "mv" => (mv $sel $pth)
            "cp" => (cp $sel $pth)
            "rm" => (trash put $sel)
            "vi" => (nvim $sel)
        }
    }
    match $sel {
        null => { print $el },
        _ => {match ($sel | describe | str replace --regex '<.*' '') {
            "list" => {
                for item in $sel {
                    match ($item | describe | str replace --regex '<.*' '') {
                        "range" => {
                            range_cmd $sel $cmd
                        },
                        "int" => (do_once $item $cmd),
                    }
                }
                elp
            },
            "range" => {
                range_cmd $sel $cmd
                elp
            },
            "int" => {
                match $cmd {
                    null => { n2name $sel },
                    _ => {
                        do_once $sel $cmd
                        elp
                    }
                }
            },
        }},
    }
}
