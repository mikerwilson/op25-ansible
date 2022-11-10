# This one starts it!
./rx.py --nocrypt --args "rtl" --gains 'lna:49' -S 960000 -o 25000 --audio-gain=3.5 -X -q 0 -v 1 -2 -V -U -T trunk.tsv -l 'http:0.0.0.0:8080' -O loop0


# These ones are scratch from other startup scripts (including loopback support)
./rx.py --args "rtl=1" -N 'LNA:49' -n -S 960000 -n -f 772.84375e6 -o 25000 -q -2 --audio-gain=2.5 -T trunk.tsv -V -2 -l 'http:0.0.0.0:8081' -U 2> stderr-stream0.2

./rx.py --args "rtl" -N 'LNA:49' -n -S 960000 -O loop0 -n -f 772.84375e6 -o 25000 --audio-gain=3.5 -T trunk.tsv -V -2 -l 'http:0.0.0.0:8080' -U 2> stderr-stream0.2
