for test_file in `ls tests/*.rb`; do
  ruby $test_file
done