while :;do
    E=echo\ -ne;C=content
    coproc p { nc -l 8080; }

    while read -r b o l; do
        [ ! "$k" ]&&k=".$($E ${o//%/\\x})"

        [ ${#b} -le 1 ]&&{
            $E "HTTP/1.0 200\n$C-length:"
            if [ -f "$k" ]; then
                $E "`wc -c<"$k"`\n$C-type:`file -b --mime "$k"`\n\n";cat "$k"
            else
                l=`$E "<a href=..><<</a><hr><ul>";ls -1F "$k"|sed 's/\(.*\)/<li><a href="\1">\1<\/a><br>/'`
                $E "${#l}\n$C-type:text/html;charset=utf-8\n\n$l\n"
            fi

            k=
        }>&${p[1]}
    done<&${p[0]}
done
