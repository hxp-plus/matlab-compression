#!/bin/bash
FILE_NAME=IsingSimulationFinal.m
OUTPUT_FILE=IsingSimulationFinal_compressed.m
VAR_NAMES='expect_turn temperature calculate_time conditions_of_spins calculate_time total_energy_before_flip total_energy_after_flip mean_condition total_energy_before_flip test_flip delta_energy possibility_of_slip possibility_random time'
SPACE_AFTER='for if close clear axis'  # Define keywords in MATLAB syntax which space must be appended after.
TEMP_FILE="$FILE_NAME.tmp"
NUM=0

# To extract variables:
# sed -n 's/\([a-zA-Z][^\+\-\*/\.\(\) ]*\)=/match_\1_match=/p' IsingSimulationFinal.m | sed -n 's/.*match_\(.*\)_match.*/\1/p' | sort | uniq

cp $FILE_NAME "$TEMP_FILE"

# Replace Variables
for var_name in $VAR_NAMES
do
	echo "Renaming variable ${var_name} to: a$NUM ";
	NUM=$(($NUM + 1))
	sed -i "s/$var_name/a$NUM/g" "$TEMP_FILE";
done

# To replace variables:
# sed 's/\(^.*$\)/ \1/g' IsingSimulationFinal.m | sed 's/\([^a-zA-Z_]\)n\([^a-zA-Z_]\)/\1match_n_match\2/g' | sed 's/^ \(.*\)$/\1/g'
# Loop variables:
# while read i                                                                      ░▒▓ 115.156.140.91  │ 58%  
# do
# echo $i
# done < vars.txt


# Replace the space to {{space}}
for space_after in $SPACE_AFTER
do
	echo "Appending {{space}} after $space_after";
	sed -i "s/$space_after /$space_after{{space}}/g" "$TEMP_FILE";
done

# Delete all comments
sed -i 's/%.*//g' "$TEMP_FILE"

# Append ;
sed -i '/^[[:space:]]*$/d' "$TEMP_FILE"
sed -i 's/$/;/' "$TEMP_FILE"

# Remove all spaces
cat "$TEMP_FILE" | tr -d '[:space:]' > "$TEMP_FILE.tmp"
rm "$TEMP_FILE"
mv "$TEMP_FILE.tmp" "$TEMP_FILE"

# Remove duplicate ;
sed -i 's/\.\.\.;//g' "$TEMP_FILE"
sed -i 's/;;*/;/g' "$TEMP_FILE"

# Replace space back
sed -i 's/{{space}}/ /g' "$TEMP_FILE"

mv "$TEMP_FILE" "$OUTPUT_FILE"
