BEGIN {
    file="packages.txt"
    while ((getline line < file) > 0)  {
        to_install[line] = 1
    }
    close(file)
}

{
    if ($1 in to_install)
        delete to_install[$1]
}

END {
    out = ""
    for (pkg in to_install)
        out = out " " pkg
    print out
}
