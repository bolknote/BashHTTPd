while :;do
    E=echo\ -ne;C=content
    coproc p { nc -l 8080; }

    while read -r a b x; do
        [ ! "$f" ]&&f=".$($E ${b//%/\\x}|sed 'y/+/ /')"

        [ ${#a} -le 1 ]&&{
            $E "HTTP/1.0 200\n$C-length:"
            if [ -f "$f" ]; then
                $E "`wc -c<"$f"`\n$C-type:`file -b --mime-type "$f"`\n\n";cat "$f"
            else
                x=`$E "<a href=..><<</a><hr><ul>";ls -1F "$f"|sed 's/\(.*\)/<li><a href="\1">\1<\/a><br>/'`
                $E "${#x}\n$C-type:text/html;charset=utf-8\n\n$x\n"
            fi

            f=
        }>&${p[1]}
    done<&${p[0]}
done