
base="./src/flatbufferschemas/"
schemas=`ls $base`
cur=`pwd`

generate files
for schema in $schemas ; do
	flatbuffers_schema=$base/$schema
	./dependencies/audio_engine/bin/Debug/flatc --gen-includes -o flatbuffers_scheme/ -I $cur/dependencies/motive/schemas -I $cur/dependencies/audio_engine/schemas -c ${flatbuffers_schema}
done 

# copy schema
find . -name "*.fbs" |xargs -I{}  cp {} assets/schemas/