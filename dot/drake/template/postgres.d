;
; USAGE:
;   mkdir -p ./test
;   drake -w postgres.d --base="$(pwd)/test" --tmpdir="$(pwd)/test/drake-tmp" --logfile="$(pwd)/test/drake.log" --auto
;
BASE:=./test
PSQL_EXEC:=/usr/local/bin/psql
POSTGRES_URI:="postgres://postgres:postgres@127.0.0.1:5432/drake_test"

file() [eval]
  echo "$CODE" | tee $OUTPUT | nl

psql()
  $[PSQL_EXEC] $[POSTGRES_URI] -f $INPUT > $OUTPUT

; requirements: Gnu Prallel (version 20180422)
ppsql()
  ls $INPUTS | tee $OUTPUT | parallel --gnu --line-buffer --tagstring "[ {} ]" --results $[BASE]/parallel.stdout.logs --eta --progress --joblog $[BASE]/parallel.job.log -j 4 --halt 1 --load 100% --noswap "cat -n {}; $[PSQL_EXEC] $[POSTGRES_URI] -f {} > {}.o"

diff()
  diff $INPUTS | tee $OUTPUT

%include ./postgres-sql.d

create_tables.sql.o, %create_tables  <- create_tables.sql [method:psql]
load_data.sql.o, %load_tables <- load_data.sql, %create_tables [method:psql]

; issue a query
select_tbl.sql.o <- select_tbl.sql, %load_tables [method:psql]
select_tbl.2.sql.o <- select_tbl.2.sql, %load_tables [method:psql]

; parallel exectuion with Gnu Parallel
;psql <- select_tbl.sql, select_tbl.2.sql [method:ppsql]


