./rx.py --nocrypt --args "rtl" --gains 'lna:49' -S 960000 -o 25000 --audio-gain=3.5 -U -X -q 0 -v 1 -2 -V -T trunk.tsv -l 'http:0.0.0.0:8080' -O loop0 2> stderr-stream0.2

# ./rx.py --nocrypt --args "rtl=0" --gains 'lna:36' -S 960000 -q 0 -d 0 -v 1 -2 -T trunk.tsv -V -w -M meta.json 2> stderr.2
# default
# ./rx.py --nocrypt --args "rtl=0" --gains 'lna:36' -S 57600 -q 0 -d 0 -v 1 -2 -T trunk.tsv -V -w -M meta.json 2> stderr.2